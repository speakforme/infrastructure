var AWS = require('aws-sdk');

AWS.config.update({ region: 'eu-west-1' });

var fromEmail = 'capt.n3m0@gmail.com';

exports.handler = function(event, context, callback) {
  // https://docs.aws.amazon.com/ses/latest/DeveloperGuide/receiving-email-notifications-contents.html#receiving-email-notifications-contents-mail-object
  var from = event.Records[0].ses.mail.source || event.Records[0].ses.mail.from;

  // Create the promise and SES service object
  var sendPromise = new AWS.SES({ apiVersion: '2010-12-01' })
    .sendTemplatedEmail({
      Destination: {
        /* required */
        ToAddresses: [
          // We are sending an acknowledgements
          from,
          /* more To email addresses */
        ],
      },
      Source: fromEmail /* required */,
      Template: 'Acknowledgement' /* required */,
      // TODO: URL Encode This
      TemplateData:
        '{ "email":"' +
        require('querystring').escape(from) +
        '" }' /* required */,
      ReplyToAddresses: [fromEmail],
    })
    .promise();

  // Handle promise's fulfilled/rejected states
  sendPromise
    .then(function(data) {
      console.log(data);
    })
    .catch(function(err) {
      console.error(err, err.stack);
    });
};
