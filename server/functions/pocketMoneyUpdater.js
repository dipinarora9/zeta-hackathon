const { v4: uuidv4 } = require('uuid');
const fetch = require("node-fetch");

const fusion_obj = {
    BASE_URL: 'https://fusion.preprod.zeta.in',
    IFIID: '140793',
    ACCOUNT_PRODUCT_ID: 'c1157a6e-472a-40a1-8be2-b2b1b3f86955',
    BUNDLEID: 'd0f32812-d701-4650-945d-f8d8280d621b',
    FUNDACCOUNTID: 'b46779a5-d42d-41b7-ab47-e241c7274a18',
    AUTH_KEY: 'eyJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwidGFnIjoiRXNzLU1QWDFKX3Y3VnI4clNTQ0ZEZyIsImFsZyI6IkExMjhHQ01LVyIsIml2IjoicGI3S3Uya2hSbnBJS1hNLSJ9.Af5ZwXx1nAn-Ur2B4Mtixtq9Er1-q8xyqEttJhdpkic.MPvC3iFhy3inzjk5XN7Ksg.QZo4s_G-3JooPrjw3Of95q2AhBzztKBhQoSMPRqXInujrTpYEsI4D0KSvr_mDRhrv6enxcgLO4FerpaPHykBGRM3_nPVIfYqDU7pVV8Lx0w4ZSr4iPx1V7L30x5nXBwC5_P44ERBJfK__0aUEX5EnPil07z8xROmu7sUeGgpcSUPnowIBGeQR0gZKA2HIktYUVaHQwAI3ALIBRJsLYCmKjxeZlxye4PTxTiNSBg70XAo4Mi8tNsfxfLIhHll5ExuZX4BxfdkUVblKPbSVXGs3Fbi49AdNxhOaC8QTLCaXy48Kzz9UxB8yjtw1q6-IXYt1plRDJaqWGCaEaacW_RZmHHvZQgYJVL5WT92sBftsHZWuKVv1vu5XmF539H2UvNf.SzLl7CbL7_uhdy6mNz4xjw',
}

var serviceAccount = require("./api-key.json");
const firebase = require('firebase-admin');


let firebaseApp = firebase.initializeApp({
    credential: firebase.credential.cert(serviceAccount),
    databaseURL: "https://zeta-hackathon-dipin-prashant-default-rtdb.firebaseio.com"
});

var db = firebaseApp.firestore();
async function script() {
    // const time = getTimestamp(new Date());
    const time = 1630089000;
    // fetch docs of users(parent) with latest renewal date as today 12AM 
    let users = await db.collection('users').where('latest_renewal_date', '==', time).get();
    console.log(users.size);

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
            today.setDate(today.getDate() + plan.recurring_days);
            let accounts = await getAllAccountOfUser(userData.data().individual_id);
            let creditAccountID = accounts.poolAccountID;
            let debitAccountID = accounts.personalAccountID;

            let transactionResult = await doTransaction(creditAccountID, debitAccountID, plan.amount);

            console.log(transactionResult);
            childData.balance += plan.amount;
            childData.pocket_money_details.renewal_date = getTimestamp(today);
            console.log(getTimestamp(today));
            await db.collection('users').doc(userData.id).collection('children').doc(childData.user_id).set(childData);
        }
        if (children.size > 0) {
            let childToGetMoneyNow = await db.collection('users').doc(userData.id).collection('children').orderBy('pocket_money_details.renewal_date').limit(1).get();

            if (childToGetMoneyNow.docs.length == 0)
                continue;

            childToGetMoneyNow = childToGetMoneyNow.docs[0].data();

            const latest_renewal_date = childToGetMoneyNow.pocket_money_details.renewal_date;
            console.log(latest_renewal_date);
            await db.collection('users').doc(userData.id).update({ "latest_renewal_date": latest_renewal_date });
        }
    }
}
script();
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

async function doTransaction(creditAccountID, debitAccountID, amount) {
    return new Promise(async (resolve, reject) => {
        try {
            let formData = {
                "requestID": uuidv4(),
                "amount": {
                    "amount": amount,
                    "currency": "INR",
                },
                "transferCode": "ATLAS_P2M_AUTH",
                "debitAccountID": debitAccountID,
                "creditAccountID": creditAccountID,
                "remarks": "TEST",
                "transferTime": getCurrentServerTime(), // time
                "attributes": {}
            }
            
            let responseTransaction = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/transfers`, {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json",
                    'X-Zeta-AuthToken': fusion_obj.AUTH_KEY
                },
                body: JSON.stringify(formData),
            });
            let status = responseTransaction.status;

            let responseTransactionData = await responseTransaction.json();
            console.log(responseTransactionData);

            if (status !== 200) {
                reject({
                    'message': responseTransactionData.message,
                    'status': 'FAIL',
                });
            }
            resolve({
                'transferID': responseTransactionData.transferID,
                'status': 'SUCCESS',
            });

        } catch (err) {
            reject({
                'message': err.message,
                'status': 'FAIL',
            });
        }
    });
}

async function getAllAccountOfUser(individualID) {
    return new Promise(async (resolve, reject) => {
        try {
            let response = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/individuals/${individualID}/accounts`, {
                method: 'GET',
                headers: {
                    'X-Zeta-AuthToken': fusion_obj.AUTH_KEY
                },
            });
            let responseData = await response.json();
            console.log(responseData);
            if (response.status !== 200) {
                reject({ 'status': 'FAIL', 'message': responseData.message });
            }
            var poolAccountID = "";
            var personalAccountID = "";
            if (responseData.accounts[0].name === "Pool Account") {
                poolAccountID = responseData.accounts[0].id;
                personalAccountID = responseData.accounts[1].id;
            } else {
                poolAccountID = responseData.accounts[1].id;
                personalAccountID = responseData.accounts[0].id;
            }
            resolve({
                'status': 'SUCCESS',
                'poolAccountID': poolAccountID,
                'personalAccountID': personalAccountID
            });
        } catch (err) {
            reject({ 'status': 'FAIL', 'message': err.message });
        }
    })
}
