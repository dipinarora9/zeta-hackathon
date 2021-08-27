const functions = require("firebase-functions");
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
// var messaging = admin.messaging();

function getCurrentServerTime() {
    return (new Date()).getTime();
}

async function createNewIndividual(data) {
    return new Promise(async (resolve, reject) => {
        try {
            let response = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/applications/newIndividual`, {
                method: 'POST',
                headers: {
                    'X-Zeta-AuthToken': fusion_obj.AUTH_KEY,
                    'Cache-Control': 'no-cache',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data),
            });
            let responseData = await response.json();

            if (response.status !== 200) {
                reject({ 'status': 'FAIL', 'message': responseData.message });
            }

            resolve({
                'status': 'SUCCESS',
                'individualID': responseData.individualID
            });
        } catch (err) {
            console.log('error creating new individual here');

            reject({ 'status': 'FAIL', 'message': err.message });
        }
    })
}

async function issueBundle(bundleName, accountHolderID, email) {
    return new Promise(async (resolve, reject) => {
        try {
            let formData = {
                "accountHolderID": accountHolderID,
                "name": bundleName,
                "email": email
            }
            let issueResponse = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/bundles/${fusion_obj.BUNDLEID}/issueBundle`, {
                method: 'POST',
                headers: {
                    'X-Zeta-AuthToken': fusion_obj.AUTH_KEY,
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(formData),
            });
            let issueResponseData = await issueResponse.json();
            console.log(issueResponseData);
            if (issueResponse.status !== 200) {
                reject({
                    'status': 'FAIL',
                    'message': issueResponseData.message
                });
            } else {
                resolve({
                    'status': 'SUCCESS',
                    'accountID': issueResponseData.accounts[0].accountID,
                    'accountHolderID': issueResponseData.accounts[0].accountHolderID,
                    'resourceID': issueResponseData.paymentInstruments[0].resourceID,
                });
            }
        } catch (err) {
            reject({
                'status': 'FAIL',
                'message': err.message
            });
        }
    });
}

// exports.ParentSignUp = functions.https.onRequest(async (request, response) => {
exports.ParentSignUp = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }
    // create acc holder
    // issue bundle -> name: parent account
    // pool account create
    let temp = data;
    return new Promise(async (resolve, reject) => {
        try {
            let params = temp;
            // let params = request.body;
            params.ifiID = fusion_obj.IFIID;
            params.individualType = 'REAL';
            params.applicationType = "CREATE_ACCOUNT_HOLDER";

            let newIndividualData = await createNewIndividual(params);

            if (newIndividualData.status === 'FAIL') {
                reject({
                    'status': 'FAIL',
                    'message': data.message
                });
            } else {
                // issue bundle -> bundle name, id, email
                let accountPaymentProducts = await issueBundle('parent account', newIndividualData.individualID, params.vectors[0].value);
                if (accountPaymentProducts.status === 'FAIL') {
                    reject({
                        'status': 'FAIL',
                        'message': data.message
                    });
                } else {
                    // account id, accountHolderID , resource id
                    let formData = {
                        "accountHolderID": accountPaymentProducts.accountHolderID,
                        "accountProductID": fusion_obj.ACCOUNT_PRODUCT_ID,
                        "name": "Pool Account"
                    }
                    let issueAccountResponse = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/bundles/${fusion_obj.BUNDLEID}/issueAccount`, {
                        method: 'POST',
                        headers: {
                            'X-Zeta-AuthToken': fusion_obj.AUTH_KEY,
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(formData),
                    });
                    let issueAccountResponseData = await issueAccountResponse.json();
                    console.log(issueAccountResponseData);

                    if (issueAccountResponse.status !== 200) {
                        reject({
                            'status': 'FAIL',
                            'message': issueAccountResponseData.message
                        });
                    } else {
                        accountPaymentProducts.poolAccountID = issueAccountResponseData.accountID;
                        resolve(accountPaymentProducts);
                    }
                }
            }
        } catch (err) {
            reject({
                'status': 'FAIL',
                'message': err.message
            });
        }
    })
    // response.send(res);

});

// exports.ChildSignUp = functions.https.onRequest(async (request, response) => {
exports.ChildSignUp = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }
    // create acc holder
    // issue bundle -> name: child account
    // map paymentProduct to parents pool account
    let temp = data;
    return new Promise(async (resolve, reject) => {
        try {
            let params = temp;
            // let params = request.body;
            let targetAccountID = params.targetAccountID;
            delete params.targetAccountID;
            params.ifiID = fusion_obj.IFIID;
            params.individualType = 'REAL';
            params.applicationType = "CREATE_ACCOUNT_HOLDER";

            let newIndividualData = await createNewIndividual(params);

            if (newIndividualData.status === 'FAIL') {
                reject({
                    'status': 'FAIL',
                    "message": data.message
                });
            } else {
                let accountPaymentProducts = await issueBundle('parent account', newIndividualData.individualID, params.vectors[0].value);
                console.log(accountPaymentProducts);
                if (accountPaymentProducts.status === 'FAIL') {
                    reject({
                        'status': 'FAIL',
                        'message': data.message
                    });
                } else {
                    let paymentResourceID = accountPaymentProducts.resourceID;

                    let mapResponse = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/resources/${paymentResourceID}/target`, {
                        method: 'PATCH',
                        headers: {
                            'X-Zeta-AuthToken': fusion_obj.AUTH_KEY,
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({
                            "target": `account://${targetAccountID}`,
                        }),
                    });
                    let mapResponseData = await mapResponse.json();
                    console.log(mapResponseData);
                    if (mapResponse.status !== 200) {
                        reject({
                            'status': 'FAIL',
                            "message": mapResponseData.message,
                        });
                    } else {
                        resolve(accountPaymentProducts);
                    }
                }
            }

        } catch (err) {
            console.log({
                'status': 'FAIL',
                'message': err.message
            });
            reject({
                'status': 'FAIL',
                'message': err.message
            });
        }
    });
    // response.send(res);
});
// exports.A2ATransaction = functions.https.onRequest(async (request, response) => {
exports.A2ATransaction = functions.https.onCall(async (data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }
    // make transaction

    return new Promise(async (resolve, reject) => {
        try {
            let params = data;
            // let params = request.body;
            let creditAccountID = params.creditAccountID;
            let debitAccountID = params.debitAccountID;
            let amount = params.amount;

            let transactionResult = await doTransaction(creditAccountID, debitAccountID, amount);

            resolve(transactionResult);

        } catch (err) {
            reject({
                'message': err.message,
                'status': 'FAIL',
            });
        }
    });
    // response.send(res);
    // return res;
});

// exports.checkBalance = functions.https.onRequest(async (request, response) => {
exports.checkBalance = functions.https.onCall(async (data, conext) => {
    if (!context.auth) {
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    }
    // check balance
    return new Promise(async (resolve, reject) => {
        try {
            let accountID = data.accountID;
            // let accountID = request.body.accountID;
            let responseBalance = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/accounts/${accountID}/balance`, {
                method: 'GET',
                headers: {
                    'X-Zeta-AuthToken': fusion_obj.AUTH_KEY
                },
            });
            let responseBalanceData = await responseBalance.json();

            let status = responseBalance.status;


            if (status !== 200) {
                reject({
                    'message': responseBalanceData.message,
                    'status': 'FAIL'
                });
            }

            resolve({
                'balance': responseBalanceData.balance,
                'currency': responseBalanceData.currency,
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

    // response.send(res);
    // return res;
});

// exports.getAccountDetails = functions.https.onRequest(async (request, response) => {
//     response.send("HEY");
// })

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

// function getAccountIDViaAccountHolderID(accountHolderID) {
//     return new Promise(async (resolve, reject) => {
//         let accountIDResponse = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/individuals/${accountHolderID}/accounts`, {
//             method: 'GET',
//             headers: {
//                 'X-Zeta-AuthToken': fusion_obj.AUTH_KEY
//             },
//         })
//         let responseObj = await accountHolderID.json();
//         if (accountIDResponse.status !== 200) {
//             reject('');
//         }
//         resolve(responseObj.id);
//     });
// }

// async function getAccountIDsViaEmail(email) {
//     let res = await new Promise(async (resolve, reject) => {
//         try {
//             let accountHolderIDResponse = await fetch(`${fusion_obj.BASE_URL}/api/v1/ifi/${fusion_obj.IFIID}/individualByVector/e/${email}`, {
//                 method: 'GET',
//                 headers: {
//                     'X-Zeta-AuthToken': fusion_obj.AUTH_KEY
//                 }
//             });
//             let status = accountHolderIDResponse.status;
//             let accountHolderID = await accountHolderIDResponse.json();
//             if (status !== 200) {
//                 // error
//                 reject('');
//             }
//             let response = await getAccountIDViaAccountHolderID(accountHolderID);
//             if (response === '') reject('');
//             else resolve(response);
//         } catch (err) {
//             // error
//             reject('');
//         }
//     });
//     console.log(res);
//     return res;
// }

