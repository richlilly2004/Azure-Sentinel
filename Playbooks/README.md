![alt text](https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/Logic_Apps.svg "Azure Logic Apps")
# About
This repo contains sample security playbooks for security automation, orchestration and response (SOAR)

## Each folder contains a security playbook ARM template that uses Microsoft Azure Sentinel trigger.
After selecting a playbook, in the Azure portal:
1. Search for deploy a custom template
2. Click build your own template in the editor
3. Paste the conents from the GitHub playbook 
4. Click Save
5. Fill in needed data and click purchase

Once deployment is complete, you will need to authorize each connection.
1. Click the Azure Sentinel connection resource
2. Click edit API connection
3. Click Authorize
4. Sign in
5. Click Save
6. Repeat steps for other connections
 * For Azure Log Analytics Data Collector,  you will need to add the workspace ID and Key
You can now edit the playbook in Logic apps.

# Suggestions and feedback
For questions or feedback, please contact rich.lilly@outlook.com