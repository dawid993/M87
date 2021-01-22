public with sharing class GroupMemberRepositoryImp implements GroupMemberRepository {
    public List<Id> retrieveGroupMembersFromGroup(Group targetGroup){
        List<Id> ids = new List<Id>();
        for(GroupMember member : [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :targetGroup.Id]){
            ids.add(member.UserOrGroupId);
        }

        return ids;
    }
}
