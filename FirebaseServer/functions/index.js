"use strict";

const admin = require('firebase-admin');
const functions = require('firebase-functions');

admin.initializeApp(functions.config().firebase);
let db = admin.firestore();
let SUCCESS = 0;

// Called when some User1 swipes right on another user (which causes a document
// to be created in their swipedRight collection)
exports.checkForMatchOnSwipeRight = functions.firestore
	.document('profiles/{uidOfUser1}/swipedRight/{uidSwipedOn}')
	.onCreate((snap, context) => {
		let uidOfUser1 = snap.ref.parent.parent.id;
		let uidSwipedOn = snap.id;
		let swipedRightCollectionOfUserSwipedOn =
			db.collection('profiles').doc(uidSwipedOn).collection('swipedRight');

		// Now we check if the user that User1 swiped on also swiped right on User1
		// - We do this by trying to get a document in the swipedOn user's
		//   swipedRight collection whose title matches User1's uid.
		// - If we can find the document, that means they both swiped right on each
		//   other, so we have a match!
		return swipedRightCollectionOfUserSwipedOn.doc(uidOfUser1).get()
			.then(doc => {
				if (doc.exists) {
					// The user did swipe right on User1, so match the users together!
					match(uidOfUser1, uidSwipedOn);
				}
				return SUCCESS;
			})
			.catch((error) => {
				console.log("Getting document in swipedRight collection failed " +
										"for reason OTHER than document missing.\n" +
									  "Error message: " + error);
			})
	})

function match(uid1, uid2) {
	return db.collection('matches').add({
		members: [uid1, uid2],
		timestamp: admin.firestore.Timestamp.now()
	})
		// NOTE: For some reason the catch below is never being called even when
		// there is an error in the add() function call above. Instead, it just
		// bubbles up to the catch after the get() in checkForMatchOnSwipeRight.
		.catch((error) => {
			console.log("Failed to add new match between " + uid1 + " and " +
									 uid2 + "." +
								  "Error message: " + error);
		})
}
