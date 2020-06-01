public with sharing class ACAMSTransferObjectControllerLightning {

    @AuraEnabled
    public static String transferAsset(String recordId) {
        Asset assetToTransfer = Database.query(getObjectQuery('Asset', recordId));

        assetToTransfer.CancelDate__c = Date.today();
        if (assetToTransfer.Enterprise_Product_HL__c != null && assetToTransfer.Enterprise_Product_HL__c.contains('ENT')) {
            assetToTransfer.Cancel_Reason__c = 'Removed from Enterprise';
        } else {
            assetToTransfer.Cancel_Reason__c = 'Transferred between Accounts';
        }
        update assetToTransfer;

        Asset clonedAsset = assetToTransfer.clone(false, true, false, false);
        try {
            clonedAsset.Status__c = 'Active';
            clonedAsset.Cancel_Reason__c = '';
            clonedAsset.CancelDate__c = null;
            clonedAsset.Exam_Schedule_Date__c = null;
            clonedAsset.Assignee__c = null;
            clonedAsset.Enterprise_Welcome_Email_Source__c = '';
            clonedAsset.Enterprise_Welcome_Email__c = false;
            clonedAsset.Enterprise_Renewal_Email__c = false;
            clonedAsset.Application_Date__c = null;
            clonedAsset.Application_Received__c = false;
            clonedAsset.Certification_Approved_Application__c = false;
            clonedAsset.Certification_Exam_Passed__c = false;
            clonedAsset.ExamResult__c = null;
            clonedAsset.White_Paper_Approved_Date__c = null;
            clonedAsset.White_Paper_Assignment_Approved__c = false;
            clonedAsset.White_Paper_Published__c = false;
            clonedAsset.Paid_Cert__c = false;
            insert clonedAsset;
            return clonedAsset.Id;
        } catch (Exception e) {
            return '';
        }
    }

    @AuraEnabled
    public static String transferAssetTerm(String recordId) {
        Asset_Term__c assetTermToTransfer = Database.query(getObjectQuery('Asset_Term__c', recordId));
        assetTermToTransfer.Cancel_Date__c = Date.today();
        update assetTermToTransfer;

        Asset_Term__c clonedAssetTerm = assetTermToTransfer.clone(false, true, false, false);
        try {
            clonedAssetTerm.Cancel_Date__c = null;
            insert clonedAssetTerm;
            return clonedAssetTerm.Id;
        } catch (Exception e) {
            return '';
        }
    }

    public static String getObjectQuery(String objectAPIName, String recordId) {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = 'SELECT ' ;
        for (String s : fieldMap) {
            if (schema.getGlobalDescribe().get(objectAPIName).getDescribe().fields.getMap().get(s).getDescribe().isAccessible()) {
                soqlQuery += +s + ',';
            }
        }
        soqlQuery = soqlQuery.removeEnd(',');
        soqlQuery += ' FROM ' + objectAPIName + ' WHERE ID = \'' + recordId + '\'' ;
        return soqlQuery;
    }

}