const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.pocketMoneyUpdater = functions.https.onRequest((request, response) => {

    // fetch date convert to millisecond epoch 12 AM
    // fetch docs of users(parent) with latest renewal date as today 12AM 
    // fetch child of that parent id with renewal time stamp is today 12AM
    // fetch pocket money plan
    // add balance update renewal date
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});
