@isTest
public with sharing class TestGroupSelector {
    public static final String ERROR_NOTIFY_GROUP_DEV_NAME = 'ErrorNotifyGroup';

    public static Group selectErrorNotifyGroup(){
        return [SELECT Id, Name FROM Group WHERE DeveloperName = :ERROR_NOTIFY_GROUP_DEV_NAME LIMIT 1];
    }
}
