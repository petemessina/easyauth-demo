# EasyAuth Setup With Private Endpoint

The purpose of this project is to provide a baseline bicep and JAVA function example that has a private endpoint connection to both the function and the key vault with easyauth turned on.

![Alt text](assets/Architecture.png?raw=true "Architecture Diagram")

## Application Registration Setup
### To enable EasyAuth through the bicep templates in this project please follow the steps below.

1. Navigate to Azure Application Registrations
![Alt text](assets/AppRegistration.png?raw=true "Azure Application Registration")

2. Create a new application Registration and take note of the Application (client) ID
![Alt text](assets/NewRegistration.png?raw=true "New Registration")
![Alt text](assets/ClientId.png?raw=true "Client Id")

3. Enable ID Tokens on the Authentications tab
![Alt text](assets/IdTokens.png?raw=true "Enable ID Tokens")

4. Set the Application ID URI
![Alt text](assets/ExposeAPI.png?raw=true "Expose API")

### To create a service that can call the function utilizing an access token please follow the steps below.

1. Create a new application Registration and take note of the Application (client) ID
![Alt text](assets/NewRegistration.png?raw=true "New Registration")
![Alt text](assets/ClientId.png?raw=true "Client Id")

2. Create an application secret.
![Alt text](assets/ClientSecret.png?raw=true "Client Secret")

### At this point all service can call this function. To restrict access to specific users and services please follow the steps below.

1. Navigate to Enterprise applications and select the application registration created in step 1 for the EasyAuth function.  
![Alt text](assets/EnterpriseApps.png?raw=true "Enterprise Apps")

2. On the properties pain set Assignment required to yes.  
![Alt text](assets/AssignmentRequired.png?raw=true "Assignment Required")

3. Navigate back to Application registrations that aligns to the function and select the application created in step 1 for the EasyAuth function. Then navigate to App Roles and create a new application role for both (Users/Groups + Applications)  
![Alt text](assets/ApplicationRole.png?raw=true "Application Role")

4. Navigate to Application that aligns to the application calling the function and select API permissions and add a permission.  
![Alt text](assets/APIPermissions.png?raw=true "API Permissions")

5. Select My APIs and chose the API and scope from the list.  
![Alt text](assets/MyApis.png?raw=true "My Apis")

6. Select the scope that aligns with the role in step 3.  
![Alt text](assets/Scope.png?raw=true "Scope")

7. Grant admin consent.  
![Alt text](assets/Consent.png?raw=true "Consent")

## IaC Code


## Additional Resources

