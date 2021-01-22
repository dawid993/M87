public interface GroupMemberRepository {
    
    List<Id> retrieveGroupMembersFromGroup(Group targetGroup);
}
