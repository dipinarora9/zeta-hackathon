const functions = require("firebase-functions");
const firebase = require('firebase-admin');
let firebaseApp = firebase.initializeApp();
var db = firebaseApp.firestore();
const { v4: uuidv4 } = require('uuid');
const fetch = require("node-fetch");

const fusion_obj = {
    BASE_URL: 'https://fusion.preprod.zeta.in',
    IFIID: '140793',
    BUNDLEID: 'd0f32812-d701-4650-945d-f8d8280d621b',
    FUNDACCOUNTID: 'b46779a5-d42d-41b7-ab47-e241c7274a18',
}
// var messaging = admin.messaging();

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
            //----------------------------------- transfer money from main acc to pool account
            //----------------------------------- transfer money from main acc to pool account
            //----------------------------------- transfer money from main acc to pool account
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

function getCurrentServerTime() {
    return (new Date()).getTime();
}

/*exports.sendNotification = functions.https.onRequest(async (request, response) => {
    messaging.send({
        token: request.parent_id,
        data: {
            "amount": request.amount,
            "reason": request.reason,
            "child_id": request.childId,
            "parent_id": request.parentId,
            "budget_exceeded": request.budgetExceeded,
        },
        // Set Android priority to "high"
        android: {
            priority: "high",
        },
    });
});*/

exports.ParentSignUp = functions.https.onRequest(async (request, response) => {
    // create acc holder
    // issue bundle -> name: pool account / personal account
    // pool account create
    // 
});

exports.ChildSignUp = functions.https.onRequest(async (request, response) => {
    // create acc holder
    // issue bundle -> name: child account
    // map paymentProduct to parents pool account
    // 
});

exports.A2ATransaction = functions.https.onRequest(async (request, response) => {
    // fetch sender reciver accountID using email using fusion API, 
    // SUCCESS in response
    // make transaction
    let res = await new Promise(async (resolve, reject) => {
        try {
            let params = request.body;
            let email = params.email;
            let amount = params.amount;
            console.log(email, ' ', amount);
            let creditAccountID = '398c1a31-8fe0-4ebb-81ab-70a91c158dee';
            let debitAccountID = 'e45f4149-2ff0-4ec7-89fa-0248724c3277';
            // let formData = {
            //     "requestID": uuidv4(),
            //     "amount": {
            //         "amount": amount,
            //         "currency": "INR",
            //     },
            //     "transferCode": "ATLAS_P2M_AUTH",
            //     "debitAccountID": debitAccountID,
            //     "creditAccountID": creditAccountID,
            //     "remarks": "TEST",
            //     "transferTime": getCurrentServerTime(), // time
            //     "attributes": {}
            // }
            let formData = {
                "requestID": "19",
                "amount": {
                    "currency": "INR",
                    "amount": 1
                },
                "transferCode": "ATLAS_P2M_AUTH",
                "debitAccountID": "398c1a31-8fe0-4ebb-81ab-70a91c158dee",
                "creditAccountID": "e45f4149-2ff0-4ec7-89fa-0248724c3277",
                "transferTime": 1574741608000,
                "remarks": "DIPIN TO SHAHINA",
                "attributes": {}
            }
            // console.log(formData);
            // let { creditAccountID, debitAccountID } = getAccountIDsViaEmail;
            let responseTransaction = await fetch(`https://fusion.preprod.zeta.in/api/v1/ifi/${fusion_obj.IFIID}/transfers`, {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json",
                    'X-Zeta-AuthToken': fusion_obj.AUTH_KEY
                },
                body: formData,
            });
            let status = responseTransaction.status;
            console.log(status);
            let response = await responseTransaction.json();
            console.log('response');
            console.log(response);
            if (status !== 200) {
                reject({
                    'message': response.message,
                    'status': 'FAIL',
                });
            }
            resolve({
                'transferID': response.transferID,
                'status': 'SUCCESS',
            });

        } catch (err) {
            // filter message
            console.log('error here');
            reject({
                'message': err.message,
                'status': 'FAIL',
            });
        }
    });
    //     status: 'success' / 'fail'
    console.log(res);
    resolve.send(res);
    // return res;
});

exports.checkBalance = functions.https.onRequest(async (request, response) => {
    // check balance
    let res = await new Promise(async (resolve, reject) => {
        try {
            let accountID = request.body.accountID;
            let responseBalance = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/accounts/${accountID}/balance`, {
                method: 'GET',
                headers: {
                    'X-Zeta-AuthToken': fusion_obj.AUTH_KEY
                },
            });
            let response = await responseBalance.json();

            let status = responseBalance.status;
            // console.log(status);

            if (status !== 200) {
                reject({
                    'message': response.message,
                    'status': 'FAIL'
                });
            }
            // console.log('Hello WOrld');
            resolve({
                'balance': response.balance,
                'currency': response.currency,
                'status': 'SUCCESS'
            });
        } catch (err) {
            let message = err.message;
            reject({
                'message': message,
                'status': 'FAIL'
            });
        }
    })

    response.send(res);
    // return res;
});

exports.getAccountDetails = functions.https.onRequest(async (request, response) => {
    // get the details of all accounts and id of that user
})
