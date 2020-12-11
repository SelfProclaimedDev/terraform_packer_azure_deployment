#Defining and assigning a azure policy to deny deployment of indexed resources if tags are not provided.

#Introduction
Writing a JSON document to prevent creation of resources without indexing.

#Getting Started
You need to have azure account with subscription.

#Dependencies
You should have azure cli downloaded and installed in the system. Run command "az login" to setup your cli for use.

#Instructions

1. First we need to create a policy definition. Go to folder where files are present in cli, then run the below command:

az policy definition create --name tagging-policy --description "This policy enables you to restrict the deploying of indexed resources withouts tags." --display-name "Tagging all resources before deploying" --mode "Indexed" --subscription "Free Trial" --rules tagging-policy.rules.json

Note:- In above command you have to enter your own subscription name.

2. Then we need to assign the policy to the subscription, run this below command in cli:

az policy assignment create --policy tagging-policy

3. Now policy is defined and assigned to the subscription level.