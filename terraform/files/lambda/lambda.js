var AWS = require('aws-sdk'),
  qs = require('querystring');

AWS.config.update({ region: 'eu-west-1' });

exports.handler = function(event, context, callback) {
  var fromEmail = 'info@speakforme.in';

  // https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-notifications-contents.html#receiving-email-notifications-contents-mail-object
  var userEmail =
    event.Records[0].ses.mail.source || event.Records[0].ses.mail.from;

  var subject = event.Records[0].ses.mail.commonHeaders.subject;

  if (!subject) {
    subject = 'Speak For Me Acknowledgement';
  } else {
    subject = 'Re: ' + subject;
  }

  var unsubscribe_link =
    'https://campaign.speakforme.in/unsubscribe?email=' + qs.escape(userEmail);
  // Create the promise and SES service object
  var sendPromise = new AWS.SES({
    apiVersion: '2010-12-01',
  }).sendEmail(
    {
      Destination: {
        ToAddresses: [userEmail],
      },
      Message: {
        Body: {
          Text: {
            Charset: 'UTF-8',
            Data: `Hi,

This is an acknowledgement that the Speak For Me campaign has received a copy of your email.

To protect your privacy, we will soon delete the email we received. However, we'd like to keep you updated on the campaign's progress and will send you regular email updates. If you prefer to not receive any email from us, please follow this link to unsubscribe:

Unsubscribe: ${unsubscribe_link}

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
    },
    function(err, data) {
      if (!err) {
        console.log('Email sent to ' + userEmail);
      } else {
        console.log(err);
      }
      console.log(data);
    }
  );
};
