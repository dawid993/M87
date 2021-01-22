public with sharing class GroupRepositoryImp implements GroupRepository {
    private static final String ERROR_NOTIFY_GROUP_DEV_NAME = 'ErrorNotifyGroup';
    public Group retrieveErrorNotifyGroup() {
        return [SELECT Id, Name FROM Group WHERE DeveloperName = :ERROR_NOTIFY_GROUP_DEV_NAME LIMIT 1];
    }
}
