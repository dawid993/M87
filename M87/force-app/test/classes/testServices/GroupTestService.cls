@isTest
public with sharing class GroupTestService {
    public static void assignUserToGroup(final User usr, final Group targetGroup){
        insert new GroupMember(GroupId = targetGroup.Id, UserOrGroupId = usr.Id);
    }

    public static void deleteAllUsersFromGroup(final Group targetGroup){
        delete [SELECT Id FROM GroupMember WHERE GroupId = :targetGroup.Id];
    }
}
