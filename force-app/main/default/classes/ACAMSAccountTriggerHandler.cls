public with sharing class ACAMSAccountTriggerHandler extends CCAviTriggerHandler {
    private List<Account> newList = (List<Account>) Trigger.new;
    private List<Account> oldList = (List<Account>) Trigger.old;
    private Map<Id, Account> newMap = (Map<Id, Account>) Trigger.newMap;
    private Map<Id, Account> oldMap = (Map<Id, Account>) Trigger.oldMap;

    public Set<Id> contactIds = new Set<Id>();
    public static Boolean raiseException = false;
    public class customException extends Exception {
    }
    public static Boolean isLMSUserCreated = false;

    private List<String> accountGroupNames = new List<String>{
            ACAMSUtil.PORTAL_ACCOUNT,
            ACAMSUtil.PORTAL_ACCOUNT_GOV,
            ACAMSUtil.PORTAL_ACCOUNT_GOV_MEMBER,
            ACAMSUtil.PORTAL_ACCOUNT_MEMBER
    };
    private Map<String, Id> accountGroupsMap = new Map<String, Id>();

    protected override void beforeInsert() {
        this.setFieldsFromCountrySettings(this.newList);

        User drupalIntegration = ACAMSUserDAO.getDrupalIntegrationUser();
        for (Account account : newList) {
            if (UserInfo.getUserId() == drupalIntegration.Id) {
                account.PersonLeadSource = 'Direct Traffic';
            }
            account.Work_Email__pc = account.PersonEmail;
        }
    }

    protected override void beforeUpdate() {
        this.setFieldsFromCountrySettings(
                this.getAccountsWithBillingCountryCodeChanged(this.newList, this.oldMap)
        );
        List<ccrz__E_AccountGroup__c> accountGroups = [
                SELECT Id, Name
                FROM ccrz__E_AccountGroup__c
                WHERE Name IN :accountGroupNames
        ];
        for (ccrz__E_AccountGroup__c accountGroup : accountGroups) {
            accountGroupsMap.put(accountGroup.Name, accountGroup.Id);
        }

        for (Account account : newList) {
            if (account.IsPersonAccount) {
                String oldMembershipType = oldMap.get(account.Id).Membership_Type__pc;
                String newMembershipType = newMap.get(account.Id).Membership_Type__pc;
                if (oldMembershipType != newMembershipType) {
                    String email = newMap.get(account.Id).PersonEmail;
                    Boolean govEmail = email.endsWith('.gov') || email.endsWith('.mil');
                    if ((oldMembershipType == null || oldMembershipType == ACAMSUtil.NON_MEMBER_CAPS) &&
                            newMembershipType == ACAMSUtil.MEMBER_CAPS) {
                        // UPGRADE FROM NON-MEMBER TO MEMBER BY EMAIL
                        if (govEmail) {
                            account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_GOV_MEMBER);
                        } else {
                            account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_MEMBER);
                        }
                    } else if ((oldMembershipType == ACAMSUtil.ENTERPRISE_CAPS ||
                            oldMembershipType == ACAMSUtil.MEMBER_CAPS) && (newMembershipType == null ||
                            newMembershipType == ACAMSUtil.NON_MEMBER_CAPS)) {
                        // DOWNGRADE TO NON-MEMBER BY EMAIL
                        if (govEmail) {
                            account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_GOV);
                        } else {
                            account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT);
                        }

                    } else if (oldMembershipType == ACAMSUtil.ENTERPRISE_CAPS &&
                            newMembershipType == ACAMSUtil.MEMBER_CAPS) {
                        // DOWNGRADE TO MEMBER BY EMAIL
                        if (govEmail) {
                            account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_GOV_MEMBER);
                        } else {
                            account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_MEMBER);
                        }
                    }
                }
            }
        }
        parentAccountCheck();
        primaryEmailCheck();
    }

    public override void afterUpdate() {
        if (!System.isBatch() && !System.isFuture()) {
            if (!ExamResultHelper.isVUERecursiveCheckContact) {
                for (Account newC : this.newList) {
                    for (Account oldC : this.oldList) {
                        if (newC.Pearson_Vue_ID__pc != null &&
                                (newC.Is_Work_Phone_Primary__pc != oldC.Is_Work_Phone_Primary__pc ||
                                        newC.Is_Home_Phone_Primary__pc != oldC.Is_Home_Phone_Primary__pc ||
                                        newC.Is_Mobile_Phone_Primary__pc != oldC.Is_Mobile_Phone_Primary__pc ||
                                        newC.FirstName != oldC.FirstName || newC.LastName != oldC.LastName ||
                                        newC.Legal_First_Name__pc != oldC.Legal_First_Name__pc ||
                                        newC.Legal_Last_Name__pc != oldC.Legal_Last_Name__pc ||
                                        newC.PersonEmail != oldC.PersonEmail ||
                                        newC.BillingStreet != oldC.BillingStreet ||
                                        newC.BillingCountry != oldC.BillingCountry || newC.Phone != oldC.Phone ||
                                        newC.PersonHomePhone != oldC.PersonHomePhone ||
                                        newC.PersonMobilePhone != oldC.PersonMobilePhone
                                        || newC.BillingCity != oldC.BillingCity)) {
                            contactIds.add(newC.Id);
                        }
                    }
                }
                ExamResultHelper.SendContactInfo(contactIds);
            }
            if (!isLMSUserCreated) {
                UpsertLMSUser(this.newList, this.oldMap);
            }
            MemberUpdateOnUser(this.newList, this.oldMap);
        }
    }
    public override void afterInsert() {
 	  	CreatePortalUserAccount(this.newList);

    }

    private void parentAccountCheck() {
        Set<Id> parentAccountsIds = new Set<Id>();
        List<Account> resetAccounts = new List<Account>();
        for (Account account : newList) {
            if (account.IsPersonAccount) {
                if (account.Parent_Account__pc != oldMap.get(account.Id).Parent_Account__pc) {
                    if (account.Parent_Account__pc != null) {
                        parentAccountsIds.add(account.Parent_Account__pc);
                    } else {
                        resetAccounts.add(account);
                    }
                }
            }
        }
        if (!parentAccountsIds.isEmpty()) {
            Map<Id, Account> parentAccountToIdMap = new Map<Id, Account>(ACAMSAccountDAO.getAccountsFromIds(parentAccountsIds));
            for (Account account : newList) {
                Account parentAccount = parentAccountToIdMap.get(account.Parent_Account__pc);
                if (parentAccount.ccrz__E_AccountGroup__c != null) {
                    account.ccrz__E_AccountGroup__c = parentAccount.ccrz__E_AccountGroup__c;
                }
                if (parentAccount.Enterprise_Account__c == true) {
                    account.Enterprise_Account__pc = true;
                } else {
                    account.Enterprise_Account__pc = false;
                }
            }
        }
        if (!resetAccounts.isEmpty()) {
            for (Account account : resetAccounts) {
                String email = account.PersonEmail;
                Boolean govEmail = email.endsWith('.gov') || email.endsWith('.mil');
                if (account.Membership_Type__pc == ACAMSUtil.MEMBER_CAPS) {
                    if (govEmail) {
                        account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_GOV_MEMBER);
                    } else {
                        account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_MEMBER);
                    }
                } else if (account.Membership_Type__pc == ACAMSUtil.NON_MEMBER_CAPS) {
                    if (govEmail) {
                        account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT_GOV);
                    } else {
                        account.ccrz__E_AccountGroup__c = accountGroupsMap.get(ACAMSUtil.PORTAL_ACCOUNT);
                    }
                }
                account.Enterprise_Account__pc = false;
            }
        }
    }

    private List<Account> getAccountsWithBillingCountryCodeChanged(List<Account> currentAccounts, Map<Id, Account> oldAccounts) {
        List<Account> accountsWithBillingCountryChanges = new List<Account>();
        for (Account account : currentAccounts) {
            Account oldAccount = oldAccounts.get(account.Id);
            if (oldAccount.BillingCountry != account.BillingCountry) {
                accountsWithBillingCountryChanges.add(account);
            }
        }
        return accountsWithBillingCountryChanges;
    }

    private void setFieldsFromCountrySettings(List<Account> accounts) {
        Set<String> countryCodes = new Set<String>();
        Map<String, String> settingsMap = new Map<String, String>();
        for (Account accountToUpdate : accounts) {
            if (!String.isBlank(accountToUpdate.BillingCountry)) {
                countryCodes.add(accountToUpdate.BillingCountry);
            }
        }
        for (CountrySettings__mdt countrySetting : [
                SELECT Region__c, Continent__c, Named_Territory__c, SubTerritory__c, DeveloperName
                FROM CountrySettings__mdt
                WHERE DeveloperName IN :countryCodes
        ]) {
            settingsMap.put('region' + countrySetting.DeveloperName, countrySetting.Region__c);
            settingsMap.put('namedTerritory' + countrySetting.DeveloperName, countrySetting.Named_Territory__c);
            settingsMap.put('subTerritory' + countrySetting.DeveloperName, countrySetting.SubTerritory__c);
            settingsMap.put('continent' + countrySetting.DeveloperName, countrySetting.Continent__c);
        }
        for (Account accountToUpdate : accounts) {
            accountToUpdate.Billing_Region__c = settingsMap.get('region' + accountToUpdate.BillingCountry);
            accountToUpdate.Billing_Named_Territory__c = settingsMap.get('namedTerritory' + accountToUpdate.BillingCountry);
            accountToUpdate.Billing_SubTerritory__c = settingsMap.get('subTerritory' + accountToUpdate.BillingCountry);
            accountToUpdate.Billing_Continent__c = settingsMap.get('continent' + accountToUpdate.BillingCountry);
        }
    }

    private void primaryEmailCheck() {
        for (Account account : newList) {
            Account oldAccount = oldMap.get(account.Id);
            if (!String.isBlank(account.Primary_Email__pc)) {
                if (validityCheck(oldAccount.Primary_Email__pc, account.Primary_Email__pc) ||
                        validityCheck(oldAccount.Work_Email__pc, account.Work_Email__pc) ||
                        validityCheck(oldAccount.Secondary_Email__pc, account.Secondary_Email__pc) ||
                        validityCheck(oldAccount.Other_Email__pc, account.Other_Email__pc)) {
                    updatePersonEmail(account);
                }
            }
        }
    }

    private void updatePersonEmail(Account account) {
        switch on account.Primary_Email__pc {
            when 'Work' {
                if (String.isBlank(account.Work_Email__pc)) {
                    account.addError('Work Email is blank on account');
                }
                account.PersonEmail = account.Work_Email__pc;
            }
            when 'Personal' {
                if (String.isBlank(account.Secondary_Email__pc)) {
                    account.addError('Secondary Email is blank on account');
                }
                account.PersonEmail = account.Secondary_Email__pc;
            }
            when 'Other' {
                if (String.isBlank(account.Other_Email__pc)) {
                    account.addError('Other Email is blank on account');
                }
                account.PersonEmail = account.Other_Email__pc;
            }
        }
    }

    private Boolean validityCheck(String oldField, String newField) {
        if (oldField == null && newField == null) {
            return false;
        } else if (oldField == null && newField != null) {
            return true;
        } else if (!oldField.equals(newField)) {
            return true;
        }
        return false;
    }


    public static void UpsertLMSUser(List<Account> newContacts, Map<Id, Account> oldMapContacts) {
        try {
            if (raiseException) throw new customException('Testing code');

            Set<Id> contactIds = new Set<Id>();
            Map<Id, User> contactUserMap = new Map<Id, User>();
            List<LMSUtility.LMSUserRequest> lmsuserList = new List<LMSUtility.LMSUserRequest>();

            //When new Language field is added: Language should be added and LMSIntegration user update should be excluded
            if (newContacts != null && newContacts.size() > 0 && oldMapContacts != null && oldMapContacts.size() > 0) {
                for (Account c : newContacts) {
                    isLMSUserCreated = true;
                    LMSUtility.LMSUserRequest lmsuser = new LMSUtility.LMSUserRequest();
                    lmsuser.contactId = c.Id;
                    lmsuser.firstName = c.FirstName;
                    lmsuser.lastName = c.LastName;
                    if (c.Is_Work_Email_Primary__pc && c.Work_Email__pc != null) {
                        lmsuser.username = c.Work_Email__pc;
                    } else if (c.Is_Home_Email_Primary__pc && c.Home_E_Mail_Address__pc != null) {
                        lmsuser.username = c.Home_E_Mail_Address__pc;
                    } else if (c.Is_Other_Email_Primary__pc && c.Other_Email__pc != null) {
                        lmsuser.username = c.Other_Email__pc;
                    } else {
                        lmsuser.username = c.PersonEmail;
                    }
                    lmsuser.language = '';
                    lmsuser.enabled = true;
                    if (c.Membership_Type__pc != ACAMSUtil.MEMBER_CAPS && c.Membership_Type__pc != null) {
                         if(c.Membership_Type__pc == 'NON-MEMBER'){
                                lmsuser.customerType = 'NON_MEMBER';
                         }
                     	 else{
                                lmsuser.customerType = c.Membership_Type__pc;
                            }
                    } else {
                        lmsuser.customerType = ACAMSUtil.ENTERPRISE_CAPS;
                    }
                    lmsuserList.add(lmsuser);

                    contactIds.add(c.Id);
                }
                System.debug('*****ContactHelper.UpsertLMSUser.contactIds: ' + contactIds);

                if (contactIds.size() > 0) {
                    for (User u : [SELECT Id,ContactId,AccountId,FirstName, Username,LastName, LMS_Role__c, TimeZoneSidKey FROM User WHERE AccountId IN:contactIds]) {
                        contactUserMap.put(u.AccountId, u);
                    }
                    for (LMSUtility.LMSUserRequest lmsU : lmsuserList) {
                        if (contactUserMap.containsKey(lmsU.contactId)) {
                            User u = contactUserMap.get(lmsU.contactId);
                            lmsU.username = (lmsU.username == null ? u.Username : lmsU.username);
                            lmsU.firstName = (!String.isNotBlank(lmsU.firstName) ? u.FirstName : lmsU.firstName);
                            lmsU.lastName = (!String.isNotBlank(lmsU.lastName) ? u.LastName : lmsU.lastName);
                            lmsU.role = u.LMS_Role__c;
                            lmsU.timezone = ''; //lmsU.timezone = u.TimeZoneSidKey; -- Waiting for Timezone Integration
                        }
                    }
                    System.debug('*****ContactHelper.UpsertLMSUser.contactUserMap: ' + contactUserMap);
                }
            }
            System.debug('*****ContactHelper.UpsertLMSUser.lmsuserList: ' + lmsuserList);

            if (lmsuserList.size() > 0) {
                CalloutUtility.SendRequest('UserIntegration', true, LMSUtility.BuildJson(lmsuserList));
            }
        } catch (Exception ex) {

        }
    }

    public static void MemberUpdateOnUser(List<Account> NewContacts, Map<Id, Account> oldMapContacts) {
        Set<Id> cntid = new Set<Id>();
        for (Account nc : NewContacts) {
            Account oldC = oldMapContacts.get(nc.Id);
            if (oldC != null && nc.Membership_Type__pc != oldC.Membership_Type__pc) {
                cntid.add(nc.Id);
            }
        }
        List<User> Userlist = [SELECT Id,Membership_Type__c,Contact_Member_Type__c FROM User WHERE AccountId IN:cntid];
        for (User usr : Userlist) {
            usr.Membership_Type__c = usr.Contact_Member_Type__c;
        }
        update Userlist;
    }
    public static void CreatePortalUserAccount(List<Account> acc){
	List<user> lstuser = new list<user>();
	User objuser;
	User drupalIntegration = ACAMSUserDAO.getDrupalIntegrationUser();
	if (UserInfo.getUserId() != drupalIntegration.Id){
		for (Account objAccount : acc){
			System.debug('ownerId:' + objAccount.ownerid);
			if (objAccount.IsPersonAccount){
				if (objAccount.personemail != null){
					objuser = new User();
					objuser.ContactId = objAccount.PersonContactid;
					objuser.Lastname = objAccount.lastname;
					if (objAccount.Firstname != null){
						objuser.FirstName = objAccount.Firstname;
						objuser.alias = objAccount.Firstname.substring(0, 2) + objAccount.lastname.substring(0, 3);
						objuser.communityNickname = objAccount.Firstname.substring(0, 2) + objAccount.lastname.substring(0, 3) + '_' + Math.random();
					} else{
						objuser.alias = objAccount.lastname.substring(0, 5);
						objuser.communityNickname = objAccount.lastname.substring(0, 5) + '_' + Math.random();
					}
					objuser.Email = objAccount.personemail;
					objuser.Username = objAccount.personemail;
					objuser.ProfileId = ACAMSUserDAO.getB2BProfile().Id;
					objuser.isMigrated__c = true;
					objuser.IsActive = true;
					objuser.TimeZoneSidKey = 'America/New_York';
					objuser.LocaleSidKey = 'en_US';
					objuser.EmailEncodingKey = 'ISO-8859-1';
					objuser.LanguageLocaleKey = 'en_US';
					lstuser.add(objuser);
					System.debug('==lstuser==>' + lstuser);
				}
			}
		}
		if (lstuser.size() > 0 && !test.isRunningTest()){
			insert lstuser;
		}
		if (!test.isRunningTest()){
			for (User objUs : lstuser){
				system.debug('Passworset:  ' + objUs.Member_Number__c);
				if (objUs.Member_Number__c != null)
					System.setPassword(objUs.id, objUs.Member_Number__c);
			}
		}
	}
	}
}