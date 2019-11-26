const functions = require('firebase-functions');

exports.checkAndMakeMatchOnSwipeRight = functions.firestore
	.document('profiles/swipedRight/{uid}')
	.onCreate((snap, context) => {
		let uidSwipedOn = snap.id;


	});
