@isTest
public class TestschBatchAssetStatusUpdation {
static testMethod void testExcecute() {
        Test.startTest();
        String CRON_EXP = '0 0 * * * ?';
        schBatchAssetStatusUpdation sch = new schBatchAssetStatusUpdation();
        system.schedule('Contact opt', CRON_EXP, sch);
        Test.stopTest();
    }
}