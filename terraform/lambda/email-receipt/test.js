const lambda = require('./lambda');

let event = {
  Records: [
    {
      ses: {
        mail: {
          source: 'capt.n3m0@gmail.com',
          from: 'capt.n3m0@gmail.com',
          commonHeaders: {
            subject: 'Email Subject',
            to: ['a@google.com', 'b@google.com'],
            cc: ['c@google.com'],
            bcc: ['info@email.speakforme.in', 'test@example.com'],
          },
        },
      },
    },
  ],
};
lambda.handler(event);
