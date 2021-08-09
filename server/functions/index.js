const functions = require("firebase-functions");
const firebase = require('firebase-admin');
let firebaseApp = firebase.initializeApp();
var db = firebaseApp.firestore();
/*
if (location.hostname === "localhost") {
    db.useEmulator("localhost", 8080);
}
*/
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.pocketMoneyUpdater = functions.https.onRequest(async (request, response) => {
    // fetch date convert to millisecond epoch 12 AM
    let today = new Date();
    let dd = String(today.getDate()).padStart(2, '0');
    let mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
    let yyyy = today.getFullYear();
    today = new Date(`${mm}/${dd}/${yyyy} 00:00:00`);
    let time = today.getTime();

    // fetch docs of users(parent) with latest renewal date as today 12AM 
    let map = {};
    let users = await db.collection('users').where('latest_renewal_date', '==', time).get();

    // fetch child of that parent id with renewal time stamp is today 12AM
    users.forEach(async (doc) => {
        let child = await db.collection('users').doc(doc.id).collection('children').where('pocket_money_details.renewal_date', '==', time).get();
        let childData = child.docs[0].data();
        let plan_id = childData.pocket_money_details.pocket_money_plan_id;

        let newChild = {
            pocket_money_details: childData.pocket_money_details,
            username: childData.username,
            user_id: childData.user_id,
            balance: childData.balance,
            renewal_date: childData.pocket_money_details.renewal_date,
            plan_id: childData.pocket_money_details.pocket_money_plan_id,
            //parent_id: childData.parent_id,
            //payment_permission_required: childData.payment_permission_required,
            //created_date: childData.created_date,
            //aadhaar_number: childData.aadhaar_number,
            //is_parent: childData.is_parent,
            //email: childData.email,
        };
        console.log(`plan id: ${plan_id}`);

        let pocketMoneyPlans = await db.collection('users').doc(doc.id).collection('pocket_money_plans').where('plan_id', '==', plan_id).get();
        let plan = pocketMoneyPlans.docs[0].data();
        console.log(plan);
        let today = new Date();

        newChild.balance += plan.amount;
        newChild.pocket_money_details.renewal_date = today.setDate(today.getDate() + plan.recurring_days);

        console.log(newChild);
        await db.collection('users').doc(doc.id).collection('children').doc(child.docs[0].id).set(newChild);
    });

    // fetch pocket money plan
    // add balance update renewal date
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});
