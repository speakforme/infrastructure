const AWS = require('aws-sdk'),
  uuidv4 = require('uuid/v4'),
  atomicCounter = require('dynamodb-atomic-counter'),
  region = 'eu-west-1',
  _ = require('underscore.deferred'),
  mimelib = require('mimelib');

const ACKNOWLEDGEMENT_FROM_EMAIL = 'info@email.speakforme.in',
  ACKNOWLEDGEMENT_SUBJECT = 'Speak For Me Acknowledgement',
  BCC_EMAIL_REGEX = /bcc(\+?[^@]+)@email\.speakforme\.in/g,
  ACKNOWLEDGEMENT_REPLY_TO_EMAIL = 'info@speakforme.in',
  UNSUBSCRIBE_LINK_PREFIX = 'https://campaign.speakforme.in/unsubscribe?uuid=',
  DEFAULT_BCC_CAMPAIGN_EMAIL = 'bcc@email.speakforme.in';

AWS.config.update({ region: region });
atomicCounter.config.update({ region: region });

let sendAcknowledgement = async function(
  subject,
  sourceEmail,
  unsubscribeLink
) {
  let fromEmail = ACKNOWLEDGEMENT_FROM_EMAIL;

  if (!subject) {
    subject = ACKNOWLEDGEMENT_SUBJECT;
  } else {
    subject = 'Re: ' + subject;
  }

  if (process.env['AWS_MOCK']) {
    return;
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
      ReplyToAddresses: [ACKNOWLEDGEMENT_REPLY_TO_EMAIL],
      Source: ACKNOWLEDGEMENT_FROM_EMAIL,
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
  let uuid = uuidv4();

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

  if (!process.env['AWS_MOCK']) {
    let dynamodb = new AWS.DynamoDB({ apiVersion: '2012-08-10' });
    await dynamodb.putItem(params).promise();
  }

  return uuid;
};

// Since SES does not send us the details in the commonHeaders
// for BCC addresses, we extract it from the RECEIEVED header instead
let getBccEmailFromReceivedHeader = function(sesMail) {
  receivedHeader = sesMail.headers
    .filter(function(e) {
      return e['name'] == 'Received';
    })
    .map(function(e) {
      return e['value'];
    });

  while ((m = BCC_EMAIL_REGEX.exec(receivedHeader)) !== null) {
    // This is necessary to avoid infinite loops with zero-width matches
    if (m.index === BCC_EMAIL_REGEX.lastIndex) {
      BCC_EMAIL_REGEX.lastIndex++;
    }
    return m[0];
  }
  return DEFAULT_BCC_CAMPAIGN_EMAIL;
};

let bumpCounters = async function(emails) {
  let promises = [];
  for (let i in emails) {
    // See https://github.com/serg-io/dynamodb-atomic-counter/#increment-counterid-options-
    // for docs
    await atomicCounter.increment(emails[i], {
      tableName: 'email-counters',
      keyAttribute: 'email',
      countAttribute: 'count',
    });
  }
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
  let unsubscribeLink = UNSUBSCRIBE_LINK_PREFIX + uuid;

  await sendAcknowledgement(subject, sourceEmail, unsubscribeLink);
  console.log('Sent acknowledgement email to ' + sourceEmail);

  // Gets all unique emails in the commonHeaders.{to,cc,bcc} fields
  let destinationEmails = (event.Records[0].ses.mail.commonHeaders.to || [])
    .concat(event.Records[0].ses.mail.commonHeaders.cc || [])
    // bcc does not work properly: https://stackoverflow.com/q/45050168
    // So we hack around it (see getBccEmailFromReceivedHeader)
    .concat(event.Records[0].ses.mail.commonHeaders.bcc || [])
    // This is the speakforme email to which we were bcc'd
    .concat([getBccEmailFromReceivedHeader(event.Records[0].ses.mail)]);

  destinationEmails = Array.from(
    new Set(
      destinationEmails.map(function(header) {
        let addresses = mimelib.parseAddresses(header);
        return addresses.length > 0 ? addresses[0].address : null;
      })
    )
  ).filter(Boolean);

  console.log(destinationEmails);

  if (!process.env['AWS_MOCK']) {
    console.log('Bumping Counters');
    await bumpCounters(destinationEmails.concat(['total']));
    console.log('Counters bumped');
  }
};
