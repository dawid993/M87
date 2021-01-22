public with sharing class GroupUserServiceImp implements GroupUserService {
    private final GroupRepository groupRepository;
    private final GroupMemberRepository groupMemberRepository;

    public GroupUserServiceImp(
        final GroupRepository groupRepository,
        final GroupMemberRepository groupMemberRepository
    ) {
        this.groupRepository = groupRepository;
        this.groupMemberRepository = groupMemberRepository;
    }

    public List<User> retrieveUsersFromGroup(Group targetGroup){
        return [SELECT Email FROM User WHERE Id IN (
					  	SELECT UserOrGroupId
					  	FROM GroupMember
					  	WHERE GroupId = :targetGroup.Id
		)];
    }

    public List<User> retrieveUsersFromErrorNotifyGroup(){
        Group targetGroup = groupRepository.retrieveErrorNotifyGroup();
        return retrieveUsersFromGroup(targetGroup);
    }
}
