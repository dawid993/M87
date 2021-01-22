public with sharing class GroupUserServiceFactory {
    
    public static GroupUserService newInstance(){
        return new GroupUserServiceImp(
            RepositoryFactory.newGroupRepository(),
            RepositoryFactory.newGroupMemberRepository()
        );
    }
}
