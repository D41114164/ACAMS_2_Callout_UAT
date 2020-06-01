/***
 * test class for test CalloutUtility
 * test cases should test whole class method by method
 * @ Ray - May 14, 2020
 */
@IsTest
public with sharing class FSIT_CalloutUtilityTest {
    public FSIT_CalloutUtilityTest() {
        CalloutUtility util = new CalloutUtility();
        System.assertNotEquals(util, null);
    }

    @IsTest
    public static void testGenerateHMACToken() {
        CalloutUtility.generateHMACToken('test-UTF-8');
    }

    @IsTest
    public static void testSendRequest(){
        List<Global_Variable__c>  globalVal = FSIT_CalloutUtilityTestDataFactory.createGlobalVariable();
        List<LMSUtility.LMSUserRequest> lmsuserList = new List<LMSUtility.LMSUserRequest>();
        CalloutUtility.SendRequest('UserIntegration',true,JSON.serialize(lmsuserList));
    }

    @IsTest
    public static void SendRequestMerge(){
        
    }
}