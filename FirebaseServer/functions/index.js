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

		if (uidOfUser1 === uidSwipedOn) {
			console.log("User cannot be matched with themself.");
			return SUCCESS;
		}

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
					// The user did swipe right on User1, so attempt to match the
					// users together (will fail if match has already been made
					// between them)
					attemptMatch(uidOfUser1, uidSwipedOn);
				}
				return SUCCESS;
			})
			.catch((error) => {
				console.log("Getting document in swipedRight collection failed " +
										"for reason OTHER than document missing.\n" +
									  "Error message: " + error);
			});
	})

function attemptMatch(uid1, uid2) {
	// Check if match has already been made between the two users
	db.collection('matches')
		.where('members', 'array-contains', uid1)
		.get()
	.then(uid1MatchesQuery => {
	    if (!memberOfAMatch(uid2, uid1MatchesQuery)) {
	      // Match has never been made before, so make the match!
	      match(uid1, uid2);
	    } else {
	      console.log("Didn't make match since match already exists.");
	    }
	    return SUCCESS;
	  })
	.catch(err => {
	    console.log('Error getting documents from matches collection:', err);
	});
}

function memberOfAMatch(uid2, uid1MatchesQuery) {	
	if (uid1MatchesQuery.empty)
		// If uid1 has no matches, then uid2 is certainly not a member of uid1's
		// matches.
		return false;

	else {
		// Assumes uid2 is not in uid1's matches until we find it.
		let isMember = false;

		uid1MatchesQuery.forEach(matchDoc => {
			if (matchDoc.data().members.includes(uid2))
				isMember =  true; // Looks like uid1 is already matched with uid2!
		});
		return isMember;
	}
}

function match(uid1, uid2) {
	db.collection('matches').add({
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
		});	
}
