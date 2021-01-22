public with sharing class RepositoryFactory {
    
    public static GroupRepository newGroupRepository(){
        return new GroupRepositoryImp();
    }

    public static EmailTemplateRepository newEmailTemplateRepository(){
        return new EmailTemplateRepositoryImp();
    }

    public static GroupMemberRepository newGroupMemberRepository(){
        return new GroupMemberRepositoryImp();
    }
}
