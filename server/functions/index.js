const functions = require("firebase-functions");
const firebase = require('firebase-admin');
let firebaseApp = firebase.initializeApp();
var db = firebaseApp.firestore();

exports.pocketMoneyUpdater = functions.https.onRequest(async (request, response) => {
    const time = getTimestamp(new Date());
    // fetch docs of users(parent) with latest renewal date as today 12AM 
    let users = await db.collection('users').where('latest_renewal_date', '==', time).get();
    console.log(time);
    for (let i = 0; i < users.size; i++) {
        let userData = users.docs[i];

        // fetch child of that parent id with renewal time stamp is today 12AM
        let children = await db.collection('users').doc(userData.id).collection('children').where('pocket_money_details.renewal_date', '==', time).get();
        let pocket_money_plans = {};

        for (let j = 0; j < children.size; j++) {
            let childData = children.docs[j].data();

            let plan_id = childData.pocket_money_details.pocket_money_plan_id;

            if (!(plan_id in pocket_money_plans)) {
                // fetch pocket money plan
                let pocketMoneyPlans = await db.collection('users').doc(userData.id).collection('pocket_money_plans').where('plan_id', '==', plan_id).get();
                pocket_money_plans[plan_id] = pocketMoneyPlans.docs[0].data();
            }
            const plan = pocket_money_plans[plan_id];

            let today = new Date();
            // add balance update renewal date
            today.setDate(today.getDate() + plan.recurring_days)
            childData.balance += plan.amount;
            childData.pocket_money_details.renewal_date = getTimestamp(today);
            console.log(getTimestamp(today));
            await db.collection('users').doc(userData.id).collection('children').doc(childData.user_id).set(childData);
        }
        if (children.size > 0) {
            let childToGetMoneyNow = await db.collection('users').doc(userData.id).collection('children').orderBy('pocket_money_details.renewal_date').limit(1).get();

            if (childToGetMoneyNow.docs.length == 0)
                continue;
            //1628533600
            childToGetMoneyNow = childToGetMoneyNow.docs[0].data();

            const latest_renewal_date = childToGetMoneyNow.pocket_money_details.renewal_date;
            console.log(latest_renewal_date);
            await db.collection('users').doc(userData.id).update({ "latest_renewal_date": latest_renewal_date });
        }
    }
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Updated");
});


function getTimestamp(date) {
    // fetch date convert to millisecond epoch 12 AM
    let dd = String(date.getUTCDate()).padStart(2, '0');
    let mm = String(date.getUTCMonth()).padStart(2, '0'); //January is 0!
    let yyyy = date.getUTCFullYear();
    const d = new Date(Date.UTC(yyyy, mm, dd, 0, 0, 0));
    return d.getTime() / 1000;
}