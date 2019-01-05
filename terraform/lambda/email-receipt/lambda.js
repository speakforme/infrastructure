const AWS = require('aws-sdk'),
  uuidv4 = require('uuid/v4'),
  atomicCounter = require('dynamodb-atomic-counter'),
  region = 'eu-west-1',
  _ = require('underscore.deferred'),
  mimelib = require('mimelib');

AWS.config.update({ region: region });
atomicCounter.config.update({ region: region });

let sendAcknowledgement = async function(
  subject,
  sourceEmail,
  unsubscribeLink
) {
  let fromEmail = 'info@email.speakforme.in';

  if (!subject) {
    subject = 'Speak For Me Acknowledgement';
  } else {
    subject = 'Re: ' + subject;
  }

  // Create the promise and SES service object
  await new AWS.SES({
    apiVersion: '2010-12-01',
  })
    .sendEmail({
      Destination: {
        ToAddresses: [sourceEmail],
      },
      Message: {
        Body: {
          Text: {
            Charset: 'UTF-8',
            Data: `Hi,

This is an acknowledgement that the Speak For Me campaign has received a copy of your email.

To protect your privacy, we will soon delete the email we received. However, we'd like to keep you updated on the campaign's progress and will send you regular email updates. If you prefer to not receive any email from us, please follow this link to unsubscribe:

Unsubscribe: ${unsubscribeLink}

The campaign will publish statistics of the emails received, to encourage the media and policy makers to respond to public sentiment. You can follow the numbers from @bulletinbabu on Twitter.

For more information on the people behind this campaign, see https://www.speakforme.in/humans.txt`,
          },
        },
        Subject: {
          Charset: 'UTF-8',
          Data: subject,
        },
      },
      ReplyToAddresses: ['info@speakforme.in'],
      Source: fromEmail,
      Tags: [
        {
          Name: 'Type',
          Value: 'Acknowledgement',
        },
        {
          Name: 'Campaign',
          Value: 'v2',
        },
      ],
    })
    .promise();
};

// Write the from Email to DynamoDB
let subscribeEmail = async function(sourceEmail) {
  let dynamodb = new AWS.DynamoDB({ apiVersion: '2012-08-10' }),
    uuid = uuidv4();

  let params = {
    Item: {
      uuid: {
        S: uuid,
      },
      email: {
        S: sourceEmail,
      },
    },
    ReturnValues: 'ALL_OLD',
    TableName: 'email-subscriptions',
  };

  await dynamodb.putItem(params).promise();
  return uuid;
};

let bumpCounters = function(emails, cb) {
  let promises = [];
  for (let i in emails) {
    promises.push(
      // See https://github.com/serg-io/dynamodb-atomic-counter/#increment-counterid-options-
      // for docs
      atomicCounter.increment(emails[i], {
        tableName: 'email-counters',
        keyAttribute: 'email',
        countAttribute: 'count',
      })
    );
  }

  _.when(promises)
    .done(cb)
    .fail(function(err) {
      console.log('FAILED');
      console.log(err);
    });
};

// Extracts information from the email and then:
// 1. Writes email to subscriptions table (so we can keep them updated)
// 2. Sends back an acknowledgement
// 3. TODO: Bumps counters for every email in the To: field
exports.handler = async function(event, context, callback) {
  // https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-notifications-contents.html#receiving-email-notifications-contents-mail-object
  let sourceEmail =
      event.Records[0].ses.mail.source || event.Records[0].ses.mail.from,
    subject = event.Records[0].ses.mail.commonHeaders.subject;

  let uuid = await subscribeEmail(sourceEmail);
  let unsubscribeLink =
    'https://campaign.speakforme.in/unsubscribe?uuid=' + uuid;

  await sendAcknowledgement(subject, sourceEmail, unsubscribeLink);
  console.log('Sent acknowledgement email to ' + sourceEmail);

  // Gets all unique emails in the commonHeaders.{to,cc,bcc} fields
  let destinationEmails = event.Records[0].ses.mail.commonHeaders.to
    .concat(event.Records[0].ses.mail.commonHeaders.cc)
    .concat(event.Records[0].ses.mail.commonHeaders.bcc);
  let d2 = destinationEmails
    .map(function(header) {
      let addresses = mimelib.parseAddresses(addresses);
      console.log('Address Size = ' + addresses.length);
      return addresses[0].address;
    })
    .filter(function(elem, pos) {
      return destinationEmails.indexOf(elem) == pos && elem;
    });

  console.log('Unique Emails: ' + d2.join() + ' SIZE = ' + d2.length);

  bumpCounters(destinationEmails, function(data) {
    console.log('Counters Bumped for ' + destinationEmails.join());
  });
};
