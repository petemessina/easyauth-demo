# EasyAuth Setup With Private Endpoint

The purpose of this project is to provide a baseline bicep and JAVA function example that has a private endpoint connection to both the function and the key vault.

![Alt text](assets/Architecture.png?raw=true "Architecture Diagram")

## Application Registration Setup
### To enable EasyAuth through the bicep templates in this project please follow the steps below.

1. Create a new application Registration and take note of the Application (client) ID
2. Enable ID Tokens on the Authentications tab
3. Set the Application ID URI

### To create a service that can call the function utilizing an access token please follow the steps below.

1. Create a new application Registration and take note of the Application (client) ID
2. Create an application secret.

### At this point all service can call this function. To restrict access to specific users and services please follow the steps below.

1. Navigate to Enterprise applications and select the application registration created in step 1 for the EasyAuth function.
2. On the properties pain set Assignment required to yes.
3. Navigate back to Application registrations and select the application created in step 1 for the EasyAuth function.
4. Navigate to App Roles and create a new application role for both (Users/Groups + Applications)
5. Navigate back to Application registrations and select the application created in step 1 for the calling service.
6. Select API permissions and add a permission.
7. Select My APIs and chose the API and scope from the list. 
8. Grant admin consent. 
 
## IaC Code


## Additional Resources
