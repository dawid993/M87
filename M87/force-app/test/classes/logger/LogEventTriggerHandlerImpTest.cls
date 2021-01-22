/*
* It's hard to test exception handling in integration test
* so i created this to intentionaly thrown exception and test
* exceptions handling.
*/
@isTest
public with sharing class LogEventTriggerHandlerImpTest {
    
    private static final Boolean SAVE_RESULT_UNSUCCESSFUL = false;
    private static final Boolean SAVE_RESULT_SUCCESSFUL = true;
    private static final Integer NO_RETRY = 0;

    @TestSetup
    private static void initData(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            GroupTestService.assignUserToGroup(
                UserTestDataFactory.getTestRunUser(),
                TestGroupSelector.selectErrorNotifyGroup()
            );
        }
    }

    @isTest
    private static void shouldThrowExceptionBecauseNullReferencePassed(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            Boolean exceptionThrown = false;
            LogEventTriggerHandlerImp handlerImp = handlerWithExceptionNewInstance();
            Test.startTest();

            try{
                handlerImp.afterInsert(null);
            }catch(Exception ex){
                exceptionThrown = true;
            }     
            Test.stopTest();   
            
            System.assertEquals(true, exceptionThrown, 'Should throw exception because null reference passed ' +
                ' to persist.');        
        }
    }
    
    @isTest
    private static void shouldSendEmailToUsersInErrorNotifyGroup(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            LogEventTriggerHandlerImp handlerImp = handlerWithExceptionNewInstance();
            Test.startTest();
            handlerImp.afterInsert(new List<Log__e> {
                new Log__e()
            });
            System.assertEquals(1, Limits.getEmailInvocations(), 'Should send one email');
            Test.stopTest();           
        }
    }

    @isTest
    private static void shouldNotSendEmailBecauseNoUsersInErrorNotifyGroup(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            GroupTestService.deleteAllUsersFromGroup(TestGroupSelector.selectErrorNotifyGroup());
            LogEventTriggerHandlerImp handlerImp = handlerWithExceptionNewInstance();
            Test.startTest();
            handlerImp.afterInsert(new List<Log__e> {
                new Log__e()
            });
            System.assertEquals(0, Limits.getEmailInvocations(), 'Should not send any email because ' + 
                ' no users in error notify group.');
            Test.stopTest();           
        }
    }

    @isTest
    private static void shouldThrowRetryableException(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            Integer numberOfRetry = 0;
            LogEventTriggerHandlerImp handlerImp = handlerWithExceptionNewInstance(2);
            Test.startTest();

            try{
                handlerImp.afterInsert(new List<Log__e> {
                    new Log__e()
                });
            }catch(EventBus.RetryableException ex){
                numberOfRetry++;
            }

            try{
                handlerImp.afterInsert(new List<Log__e> {
                    new Log__e()
                });
            }catch(EventBus.RetryableException ex){
                numberOfRetry++;
            }
            
            System.assertEquals(2, numberOfRetry, 'Should be 2 retry attempts');
            Test.stopTest(); 
        }
    }

    private static LogEventTriggerHandlerImp handlerWithExceptionNewInstance(){
        return handlerWithExceptionNewInstance(NO_RETRY);
    }

    private static LogEventTriggerHandlerImp handlerWithExceptionNewInstance(Integer retryNumber){
        return new LogEventTriggerHandlerImp(
            new LogProblemAdministratorNotifier(               
                GroupUserServiceFactory.newInstance(),
                RepositoryFactory.newEmailTemplateRepository()
            ),
            (LogStorageEntry) Test.createStub(LogStorageEntry.class, new LogStorageThrowExceptionMock()),
            retryNumber
        );
    }

    @isTest
    private static void shouldSendEmailToSubscribersBecauseInvalidSaveResultPresented(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            LogEventTriggerHandlerImp handlerImp = handlerWithSaveResultNewInstance(SAVE_RESULT_UNSUCCESSFUL);
            Test.startTest();
            handlerImp.afterInsert(new List<Log__e> {
                new Log__e()
            });
            System.assertEquals(1, Limits.getEmailInvocations(), 'Should send one email because invalid ' + 
                ' result presented');
            Test.stopTest(); 
        }
    }

    @isTest
    private static void shouldNotSendEmailToSubscribersBecauseInvalidSaveResultNotPresented(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            LogEventTriggerHandlerImp handlerImp = handlerWithSaveResultNewInstance(SAVE_RESULT_SUCCESSFUL);
            Test.startTest();
            handlerImp.afterInsert(new List<Log__e> {
                new Log__e()
            });
            System.assertEquals(0, Limits.getEmailInvocations(), 'Should not send one email because invalid ' + 
                ' result not presented');
            Test.stopTest(); 
        }
    }

    private static LogEventTriggerHandlerImp handlerWithSaveResultNewInstance(Boolean isSuccess){
        return new LogEventTriggerHandlerImp(
            new LogProblemAdministratorNotifier(               
                GroupUserServiceFactory.newInstance(),
                RepositoryFactory.newEmailTemplateRepository()
            ),
            (LogStorageEntry) Test.createStub(LogStorageEntry.class, new LogStorageSaveResultMock(isSuccess)),
            0
        );
    }   
    
}
