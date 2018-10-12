const main = require('./index');

main.unsubscribe('3d4b022b-e71c-4446-9560-12ca5f1f553b').catch(function(err) {
	console.log(err.message);
});
