@isTest
public with sharing class LogProblemAdministratorNotifierTest {
    
    @TestSetup
    public static void initData(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            GroupTestService.assignUserToGroup(
                UserTestDataFactory.getTestRunUser(),
                TestGroupSelector.selectErrorNotifyGroup()
            );
        }
    }

    @isTest
    public static void shouldSendEmailToUsersInErrorNotifyGroup(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            getNotifier().notifyAdministrators(new IllegalArgumentException('TestException'));
            System.assertEquals(1, Limits.getEmailInvocations(), 'Should send one email');
        }
    }

    @isTest
    public static void shouldNotSendEmailBecauseNoUsersInErrorNotifyGroup(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            GroupTestService.deleteAllUsersFromGroup(TestGroupSelector.selectErrorNotifyGroup());
            getNotifier().notifyAdministrators(new IllegalArgumentException('TestException'));
            System.assertEquals(0, Limits.getEmailInvocations(), 'Should send one email');
        }
    }

    private static LogProblemAdministratorNotifier getNotifier(){
        return new LogProblemAdministratorNotifier(                
                GroupUserServiceFactory.newInstance(),
                RepositoryFactory.newEmailTemplateRepository()
        );
    }
}
