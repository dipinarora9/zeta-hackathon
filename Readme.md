Pocket money dispenser is an app for parents and their children. 
The app will allow the parent to link their bank account and add their children details to set up an automatic pocket money dispenser system and track their transaction usage.

The child will use a common account set up by the parent.
A parent can store multiple pocket money plans, each pocket money plan will have two properties - the amount and the number of days after which that plan should get renewed.
A child can be assigned any pocket money plan. 
Because we will have a common account for the parent (full privileges) and his children(partial privileges), the parent can see the transaction done by his children and the analytics like which child is spending more, and where.
While a child can only see analytics of his transactions.

A child can only log in when a parent sends him a passwordless email invite for the app.

A pocket money updater script will run in a cron job at a specified time every day to update the balance of children if their renewal date has come.

There is also a feature to request money if a transaction amount exceeds the child's balance, then a notification will be sent to the parent to allow/deny the same.
A parent can allow setup payment permission for an individual child, in this whenever a child tries to make a transaction, a notification is sent to the parent to allow/deny it.

This app will help parents to keep an eye on how their children are spending their money.