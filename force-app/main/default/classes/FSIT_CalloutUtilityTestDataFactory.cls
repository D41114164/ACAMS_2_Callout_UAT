@isTest
public with sharing class FSIT_CalloutUtilityTestDataFactory {
    public FSIT_CalloutUtilityTestDataFactory() {

    }

    public static List<Global_Variable__c> createGlobalVariable() {
        List<Global_Variable__c> globalRecords = new List<Global_Variable__c>();
        Global_Variable__c lmsAccountMergeIntegrationEndpoint = new Global_Variable__c(Name='LMS.AccountMergeIntegration.Endpoint',Value__c='/integration/users/merge/{0}',ACAMS_Migrated__c=false);
        Global_Variable__c lmsAccountMergeIntegrationMethod = new Global_Variable__c(Name='LMS.AccountMergeIntegration.Method', Value__c='POST',ACAMS_Migrated__c=false);
        Global_Variable__c lmsAccountMergeIntegrationTimeout = new Global_Variable__c(Name='LMS.AccountMergeIntegration.TimeOut', Value__c='120000',ACAMS_Migrated__c=false);
        Global_Variable__c lmsAppServer = new Global_Variable__c(Name='LMS.APP.Server', Value__c='https://lmsacams-qa.becker.com',ACAMS_Migrated__c=true);
        
        Global_Variable__c lmsEnrlmtMergeIntegrationEndPoint = new Global_Variable__c(Name='LMS.EnrlmntMergeIntegration.Endpoint', Value__c='/integration/users/merge/subscriptions/{0}');
        Global_Variable__c lmsEnrollmentIntegrationCMethod = new Global_Variable__c(Name='LMS.EnrollmentIntegration.C.Method', Value__c='POST');
        Global_Variable__c lmsEnrollmentIntegrationEndpoint = new Global_Variable__c(Name='LMS.EnrollmentIntegration.Endpoint', Value__c='/integration/enrollment/{0}');
        Global_Variable__c lmsEnrollmentIntegrationTimeout = new Global_Variable__c(Name='LMS.EnrollmentIntegration.TimeOut', Value__c='120000');
        Global_Variable__c lmsEnrollmentIntegrationUMethod = new Global_Variable__c(Name='LMS.EnrollmentIntegration.U.Method', Value__c='PUT');
        Global_Variable__c lmsSecretKey = new Global_Variable__c(Name='LMS.SecretKey', Value__c='prdMMjNcXVAcmLXKyV2NceFfSS7BuZwNCzZ59446tnBcxGjJ2uK8aHvLcCf4KZAJGGwh7HgLrhgpepaKpXpM7g4jjr7FWLyWUV7muCmSntD6RyAh6ajLUC6VQs3PdwqnLpZ');
        Global_Variable__c lmsServer = new Global_Variable__c(Name='LMS.Server', Value__c='https://lmsacams-api.becker.com');    
        
        globalRecords.add(lmsAccountMergeIntegrationEndpoint);
        globalRecords.add(lmsAccountMergeIntegrationMethod);
        globalRecords.add(lmsAccountMergeIntegrationTimeout);
        globalRecords.add(lmsAppServer);
        globalRecords.add(lmsEnrlmtMergeIntegrationEndPoint);
        globalRecords.add(lmsEnrollmentIntegrationCMethod);
        globalRecords.add(lmsEnrollmentIntegrationEndpoint);
        globalRecords.add(lmsEnrollmentIntegrationTimeout);
        globalRecords.add(lmsEnrollmentIntegrationUMethod);
        globalRecords.add(lmsSecretKey);
        globalRecords.add(lmsServer);
        
        return globalRecords;
    }

    public static List<Contact> createContactRecord(){
        List<Contact> cList = new List<Contact>();
        Contact c = new Contact();
        c.LastName = 'Contact Last Name';
        cList.add(c);
        return cList;
    }

    public static List<Account> createAccount(Integer accountNum){
        List<Account> acctList = new List<Account>();
        for(Integer i; i < accountNum; i++){
            Account a = new Account(Name='testAcct'+i, BillingCountry='United States', BillingPostalCode='41234', BillingState='FL', BillingStreet='some street');
            acctList.add(a);
        }

        return acctList;
    }

    public static List<User> createSystemAdminUsers(){
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        List<User> uList = new List<User>();
        User u = new User
        (
            alias = 'alias',
            email='email' + '1' + '@salesforce.com',
            emailencodingkey='UTF-8',
            lastname='lastname',
            languagelocalekey='en_US',
            localesidkey='en_US',
            profileId = profile.Id,
            timezonesidkey='America/Los_Angeles',
            username='username' + '1' + '@salesforce.com'
        );

        uList.add(u);
        return uList;
    }
}