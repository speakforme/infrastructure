const AWS = require('aws-sdk'),
    region = 'eu-west-1';

AWS.config.update({ region: region });

let unsubscribe = function(uuid) {
    let dynamodb = new AWS.DynamoDB({ apiVersion: '2012-08-10' }),
        params = {
            Key: {
                uuid: {
                    S: uuid,
                },
            },
            TableName: 'email-subscriptions',
        };
    return dynamodb.deleteItem(params).promise();
};

exports.handler = function(event, context, callback) {
    let uuid = false,
        res = {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/text; charset=utf-8',
            },
            body: 'Invalid Link',
        };

    if ('uuid' in event.queryStringParameters) {
        uuid = event.queryStringParameters['uuid'];
    }

    if (uuid) {
        // We remove it from the email-subscription table
        unsubscribe(uuid)
            .then(function(data) {
                res.body = 'Unsubscribed';
                callback(null, res);
            })
            .catch(function(err) {
                res.body = err.message;
                callback(null, res);
            });
    } else {
        callback(null, res);
    }
};

exports.unsubscribe = unsubscribe;
