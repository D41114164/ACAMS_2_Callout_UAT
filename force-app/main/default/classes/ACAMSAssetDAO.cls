public with sharing class ACAMSAssetDAO {

    public static List<Asset> getAssetsByContactIds(Set<Id> contactIds) {
        List<Asset> assetsList = [
                SELECT
                        Id,
                        Name,
                        Assignee__c,
                        Current_Expiration_Date__c,
                        Subscription_Term__c
                FROM
                        Asset
                WHERE
                        Assignee__c IN :contactIds
        ];

        return assetsList;
    }

    public static List<Asset_Group__c> getAssetGroupsByOrderItemIds(Set<Id> orderItemIds) {
        List<Asset_Group__c> assetGroups = [
                SELECT
                        Id,
                (
                        SELECT
                                Id,
                                Asset__c
                        FROM
                                Asset_Group_Items__r
                )
                FROM
                        Asset_Group__c
                WHERE
                        CC_Order_Item__c IN :orderItemIds
        ];
        return assetGroups;
    }

    public static List<Asset_Term__c> getAssetTermsByAssetIds(Set<Id> assetIds) {
        List<Asset_Term__c> assetTerms = [
                SELECT
                        Id,
                        Asset__c,
                        Asset__r.Status__c,
                        Asset__r.CC_Product__c,
                        Asset__r.Name,
                        Paid__c,
                        Start_Date__c,
                        Term__c
                FROM
                        Asset_Term__c
                WHERE
                        Asset__c IN :assetIds
                AND
                        ((Start_Date__c <= TODAY AND Expiration_Date__c >= TODAY AND Asset__r.Status__c = 'Inactive')
                                OR (Start_Date__c >= TODAY AND Asset__r.Status__c = 'Active'))

        ];
        return assetTerms;
    }

    public static List<Asset> getAssetsByIds(Set<Id> assetIds) {
        List<Asset> assets = [
                SELECT
                        AccountId,
                        CC_Product__c,
                        CC_Product__r.Event_Date__c,
                        Id,
                        Name,
                        Paid_Cert__c,
                        RecordTypeId,
                        Status__c,
                        Subscription_Term__c
                FROM
                        Asset
                WHERE
                        Id IN :assetIds
        ];
        return assets;
    }
}