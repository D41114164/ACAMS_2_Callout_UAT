@IsTest
class ACAMSAccountTriggerHandlerTest {

    @IsTest
    static void testBillingCountryCodeUpdated() {
        List<Account> accounts = new List<Account>();
        Account account1 = new Account();
        account1.Name = 'testAccount1';
        account1.BillingCountry = 'US';
        accounts.add(account1);
        Account account2 = new Account();
        account2.Name = 'testAccount2';
        account2.BillingCountry = 'US';
        accounts.add(account2);
        insert accounts;

        account1.BillingCountry = 'UY';
        account2.BillingCountry = 'SI';
        update accounts;

        List<Account> updatedAccounts = [
                SELECT
                        Id,
                        Billing_Named_Territory__c
                FROM
                        Account
                WHERE
                        Id IN :accounts
        ];

        System.assert(updatedAccounts.get(0).Billing_Named_Territory__c.equals('LATAM'));
        System.assert(updatedAccounts.get(1).Billing_Named_Territory__c.equals('Other Europe'));
    }

}