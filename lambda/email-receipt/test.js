const lambda = require('./lambda');

const receivedHeader =
	'from out.migadu.com (out.migadu.com [91.121.223.63]) by inbound-smtp.eu-west-1.amazonaws.com with SMTP id 9prtp795j7bp2k95q3t0ftbur4s6pv416eegqco1 for bcc+j@email.speakforme.in; Sat, 05 Jan 2019 20:31:29 +0000 (UTC)';

process.env['AWS_MOCK'] = true;

let event = {
	Records: [
		{
			ses: {
				mail: {
					headers: [
						{
							name: 'Received',
							value: receivedHeader,
						},
					],
					source: 'speakforme@example.com',
					from: 'speakforme@example.com',
					commonHeaders: {
						returnPath: 'me@example.com',
						subject: 'Test Subject',
						from: ['Test <me@example.com>'],
						date: 'Sat, 5 Jan 2019 23:33:05 +0530',
						to: ['Test <test@example.com>'],
						messageId:
							'<122ca86f-b0eb-99c4-aa3b-71bb17e94c02@captnemo.in>',
					},
				},
			},
		},
	],
};
lambda.handler(event);
