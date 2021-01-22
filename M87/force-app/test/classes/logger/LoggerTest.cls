@isTest
public with sharing class LoggerTest {
    private static final Id NO_RECORD_ID = null;
    private static final Integer NO_LINE_NUMBER = null;
    private static final String NO_SOURCE_CLASS = null;

    private static final Boolean IS_EXCEPTION = true;
    private static final Boolean IS_NO_EXCEPTION = false;

    private class LogTestException extends Exception {}

    private static final Boolean PARTIAL_PUBLISH = false;   

    private static void runAsserts(
        EventLog__c sourceLog,        
        final String expectedSeverity,
        final Id expectedUserId, 
        final Id expectedRecordId,
        final String expectedSourceClass
    ){
        System.assertNotEquals(null, sourceLog.EventDate__c, 'Event date should be populated.');
        System.assertNotEquals(null, sourceLog.EventId__c, 'Event Id should be populated.');
        System.assertNotEquals(null, sourceLog.TransactionId__c, 'Transaction Id should be populated.');        
        System.assertEquals(expectedSeverity, sourceLog.Severity__c, 'Severity doesn\'t match.');
        System.assertEquals(expectedUserId, sourceLog.UserId__c, 'User Id doesn\'t match.');
        System.assertEquals(expectedRecordId, sourceLog.RecordId__c, 'Record Id doesn\'t match.');
        System.assertEquals(expectedSourceClass, sourceLog.SourceClass__c, 'Source class doesn\'t match.');
    }

    private static void runAsserts(
        EventLog__c sourceLog,        
        final String expectedSeverity,
        final Id expectedUserId
    ){
        runAsserts(sourceLog,expectedSeverity,expectedUserId,NO_RECORD_ID,NO_SOURCE_CLASS);
    }

    private static void runAssertsForString(EventLog__c sourceLog, String expectedInfo){
        System.assertEquals(expectedInfo, sourceLog.Info__c, 'Info doesn\'t match.');
        System.assertEquals(IS_NO_EXCEPTION, sourceLog.IsException__c, 'Should not be exception.');
    }

    private static void runAssertsForException(EventLog__c sourceLog, Exception ex){
        System.assertEquals(IS_EXCEPTION, sourceLog.IsException__c, 'Should have exception flag checked.');
        System.assertEquals(
            'Message: ' + 
                    ex.getMessage() +
                ', Cause: ' + 
                    ex.getCause() +
                ', Stack: ' +
                ex.getStackTraceString(),
            sourceLog.Details__c,
            'Exception detail doesn\'t match.'
        );
        System.assertEquals(ex.getMessage(), sourceLog.Info__c, 'Info doesn\'t match.');
        System.assertEquals(ex.getTypeName(), sourceLog.ExceptionTypeName__c, 'Exception type doesn\'t match.');      
        System.assertNotEquals(NO_LINE_NUMBER, sourceLog.LineNumber__c, 'Line number doesn\'t match.');          
    }

    private static void runAssertsForLog(EventLog__c sourceLog, Log log){
        System.assertEquals(IS_NO_EXCEPTION, sourceLog.IsException__c, 'Should not be exception.');
        System.assertEquals(log.methodName, sourceLog.SourceMethod__c, 'Source method doesn\'t match.');
        System.assertEquals(log.details, sourceLog.Details__c, 'Details don\'t match.');
        System.assertEquals(log.info, sourceLog.Info__c, 'Details don\'t match.');
    }

    @isTest
    private static void shouldCreateLogUsingStringParamMethod(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final String logMessage = 'Test message';
            final Logger logger = LoggerFactory.getLogger();
            logger.log(logMessage); 

            Test.startTest();
            logger.publish();        
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.'); 
            Test.stopTest();

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(logMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],                
                LogSeverity.INFO.name(),
                UserInfo.getUserId()              
            );

            runAssertsForString(logs[0],logMessage);
        }
    }

    @isTest
    private static void shouldCreateLogUsingStringAndSeverityParamsMethod(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final String logMessage = 'Test message';
            final Logger logger = LoggerFactory.getLogger();
            logger.log(logMessage, LogSeverity.FINEST);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest(); 
            
            final List<EventLog__c> logs = EventLogSelector.selectByInfo(logMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],               
                LogSeverity.FINEST.name(),
                UserInfo.getUserId()                
            );

            runAssertsForString(logs[0],logMessage);
        }    
    }

    @isTest
    private static void shouldCreateLogUsingStringAndSeverityAndRecordIdParamsMethod(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final String logMessage = 'Test message';
            final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());
            
            final Logger logger = LoggerFactory.getLogger();
            logger.log(logMessage, LogSeverity.FINEST, fakeAccountId);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();
            
            final List<EventLog__c> logs = EventLogSelector.selectByInfo(logMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],               
                LogSeverity.FINEST.name(),
                UserInfo.getUserId(),
                fakeAccountId,
                NO_SOURCE_CLASS           
            );

            runAssertsForString(logs[0],logMessage);
        }     
    }

    @isTest
    private static void shouldCreateLogUsingExceptionParamMethod(){   
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final String exceptionMessage = 'Exception test message';    
            final Logger logger = LoggerFactory.getLogger();
            final Exception ex = new LogTestException(exceptionMessage); 
            logger.log(ex);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();     

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(exceptionMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],               
                LogSeverity.ERROR.name(),
                UserInfo.getUserId()                        
            );

            runAssertsForException(logs[0], ex);
        }   
    }

    @isTest
    private static void shouldCreateLogUsingExceptionAndRecordIdParamsMethod(){  
        System.runAs(UserTestDataFactory.getTestRunUser()){     
            final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());

            final String exceptionMessage = 'Exception test message';    
            final Logger logger = LoggerFactory.getLogger();
            final Exception ex = new LogTestException(exceptionMessage); 
            logger.log(ex,fakeAccountId);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest(); 

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(exceptionMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.ERROR.name(),
                UserInfo.getUserId(),
                fakeAccountId,
                NO_SOURCE_CLASS          
            );

            runAssertsForException(logs[0], ex);
        }       
    }

    @isTest
    private static void shouldCreateLogUsingLogParamMethod(){  
        System.runAs(UserTestDataFactory.getTestRunUser()){    
            final String message = 'Message';   
            final Logger logger = LoggerFactory.getLogger();
            final Log log = new Log(message);
            logger.log(log);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(message);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.INFO.name(),
                UserInfo.getUserId()                       
            );

            runAssertsForLog(logs[0], log);
        }       
    }

    @isTest
    private static void shouldCreateLogUsingLogAndSeverityParamsMethod(){    
        System.runAs(UserTestDataFactory.getTestRunUser()){ 
            final String message = 'Message';   
            final Logger logger = LoggerFactory.getLogger();
            final Log log = new Log(message);       
            logger.log(log, LogSeverity.FINEST);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();  
            
            final List<EventLog__c> logs = EventLogSelector.selectByInfo(message);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.FINEST.name(),
                UserInfo.getUserId()                       
            );

            runAssertsForLog(logs[0], log);
        }    
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingStringParamMethod(){
        System.runAs(UserTestDataFactory.getTestRunUser()){ 
            final String logMessage = 'Test message';
            Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            logger.log(logMessage);

            Test.startTest();
            logger.publish();        
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.'); 
            Test.stopTest();

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(logMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.Info.name(),
                UserInfo.getUserId(),
                NO_RECORD_ID,
                LoggerTest.class.getName()                     
            );

            runAssertsForString(logs[0], logMessage);
        }
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingStringAndSeverityParamsMethod(){
        System.runAs(UserTestDataFactory.getTestRunUser()){ 
            final String logMessage = 'Test message';
            Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            logger.log(logMessage, LogSeverity.FINEST);

            Test.startTest();
            logger.publish();        
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.'); 
            Test.stopTest();

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(logMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.FINEST.name(),
                UserInfo.getUserId(),
                NO_RECORD_ID,
                LoggerTest.class.getName()                     
            );

            runAssertsForString(logs[0], logMessage);
        }       
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingStringAndSeverityAndRecordIdParamsMethod(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final String logMessage = 'Test message';
            final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());
            
            Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            logger.log(logMessage, LogSeverity.FINEST, fakeAccountId);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(logMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.FINEST.name(),
                UserInfo.getUserId(),
                fakeAccountId,
                LoggerTest.class.getName()                     
            );

            runAssertsForString(logs[0], logMessage);
        }  
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingExceptionParamMethod(){       
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final String exceptionMessage = 'Exception test message';    
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            final Exception ex = new LogTestException(exceptionMessage); 
            logger.log(ex);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();     

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(exceptionMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],               
                LogSeverity.ERROR.name(),
                UserInfo.getUserId(),
                NO_RECORD_ID,
                LoggerTest.class.getName()                      
            );

            runAssertsForException(logs[0], ex);
        }          
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingExceptionAndRecordIdParamsMethod(){       
        System.runAs(UserTestDataFactory.getTestRunUser()){     
            final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());

            final String exceptionMessage = 'Exception test message';    
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            final Exception ex = new LogTestException(exceptionMessage); 
            logger.log(ex,fakeAccountId);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest(); 

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(exceptionMessage);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.ERROR.name(),
                UserInfo.getUserId(),
                fakeAccountId,
                LoggerTest.class.getName()          
            );

            runAssertsForException(logs[0], ex);
        }               
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingLogParamMethod(){  
        System.runAs(UserTestDataFactory.getTestRunUser()){    
            final String message = 'Message';   
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            final Log log = new Log(message);
            logger.log(log);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(message);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.INFO.name(),
                UserInfo.getUserId(),
                NO_RECORD_ID,
                LoggerTest.class.getName()
            );

            runAssertsForLog(logs[0], log);
        }               
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingLogAndSeverityParamsMethod(){
        System.runAs(UserTestDataFactory.getTestRunUser()){ 
            final String message = 'Message';   
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            final Log log = new Log(message);       
            logger.log(log, LogSeverity.FINEST);

            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();  
            
            final List<EventLog__c> logs = EventLogSelector.selectByInfo(message);
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.FINEST.name(),
                UserInfo.getUserId(),
                NO_RECORD_ID,
                LoggerTest.class.getName()                     
            );

            runAssertsForLog(logs[0], log);
        }           
    }

    @isTest
    private static void shouldThrowExceptionBecauseSourceClassDoesNotMatch(){
        System.runAs(UserTestDataFactory.getTestRunUser()){        
            final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);

            Boolean exceptionThrown = false;

            Test.startTest();
            try{
                logger.log(
                    new Log(
                        'Test info',
                        fakeAccountId,
                        LogTestException.class,
                        'shouldCreateLogWithSourceClassDoesNotMatch',
                        'Details'
                    ),
                    LogSeverity.FINEST
                );
            }catch(LogSourceClassDoesNotMatchException ex){
                exceptionThrown = true;
            }            
            Test.stopTest();        

            System.assertEquals(true, exceptionThrown, 'Exception should be thrown.');       
        }
    }

    @isTest
    public static void shouldThrowExceptionBecauseLogMessageEmpty(){   
        System.runAs(UserTestDataFactory.getTestRunUser()){          
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);

            Boolean exceptionThrown = false;

            Test.startTest();
            try{
                logger.log('');
            }catch(EmptyLogMessageException ex){
                exceptionThrown = true;
            }            
            Test.stopTest();        

            System.assertEquals(true, exceptionThrown, 'Exception should be thrown.');
        } 
    }

    @isTest
    public static void shouldClearLogBufferAfterPublish(){
        System.runAs(UserTestDataFactory.getTestRunUser()){     
            final String message = 'Message';
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);
            logger.log(new Log(message));
            logger.log(new Log(message + '2'));

            Test.startTest();

            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');

            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');

            Test.stopTest();  

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(message);
            System.assertEquals(1, logs.size(), 'Should be only one log.');
        }     
    }

    @isTest
    public static void shouldClearLogBufferAfterPublishAndPublishNewOne(){
        System.runAs(UserTestDataFactory.getTestRunUser()){   
            final String message = 'Message';  
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);     

            Test.startTest();

            logger.log(new Log(message)); 
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');

            logger.log(new Log(message + '2'));
            logger.publish();
            System.assertEquals(2, Limits.getPublishImmediateDML(), 'Should publish two events.');
            
            Test.stopTest();      

            final List<EventLog__c> logs = EventLogSelector.selectAll();
            System.assertEquals(2, logs.size(), 'Should be two log.');  
        }
    }

    @isTest
    public static void shouldThrowExceptionBecauseInfoIsNull(){
        System.runAs(UserTestDataFactory.getTestRunUser()){   
            final Logger logger = LoggerFactory.getLogger();  
            logger.log(new Log()); 

            Boolean exceptionThrown = false;

            Test.startTest(); 

            try{   
                logger.publish();            
            }catch(InvalidLogsException ex){
                exceptionThrown = true;
            }

            Test.stopTest();   
            
            System.assertEquals(true, exceptionThrown, 'Exception should be thrown.');
        }
    }

    @isTest
    public static void shouldFailPublishSilentlyBecauseInfoEmpty(){
        System.runAs(UserTestDataFactory.getTestRunUser()){    
            final Log correctLog = new Log('Message');           
            final Logger logger = LoggerFactory.getLogger(PARTIAL_PUBLISH);  
            logger.log(new Log()); 
            logger.log(new Log('Message'));
            
            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
            Test.stopTest();  
            
            final List<EventLog__c> logs = EventLogSelector.selectAll();
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.INFO.name(),
                UserInfo.getUserId()                            
            );

            runAssertsForLog(logs[0], correctLog);
        }       
    }

    @isTest
    public static void shouldThrowExceptionBecauseInfoIsNullTestWithClassVariant(){
        System.runAs(UserTestDataFactory.getTestRunUser()){            
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class);  
            logger.log(new Log()); 

            Boolean exceptionThrown = false;

            Test.startTest(); 

            try{   
                logger.publish();            
            }catch(InvalidLogsException ex){
                exceptionThrown = true;
            }

            Test.stopTest();   
            
            System.assertEquals(true, exceptionThrown, 'Exception should be thrown.');
        }
    }

    @isTest
    public static void shouldFailPublishSilentlyBecauseInfoEmptyTestWithClassVariant(){
        System.runAs(UserTestDataFactory.getTestRunUser()){        
            final String message = 'Message';
            final Log correctLog = new Log(message);
            final Logger logger = LoggerFactory.getLogger(LoggerTest.class, PARTIAL_PUBLISH);  
            logger.log(new Log()); 
            logger.log(correctLog);
            
            Test.startTest();
            logger.publish();
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish 1 events.');
            Test.stopTest();  

            final List<EventLog__c> logs = EventLogSelector.selectAll();
            System.assertEquals(1, logs.size(), 'Should be only one log.');

            runAsserts(
                logs[0],              
                LogSeverity.INFO.name(),
                UserInfo.getUserId(),
                NO_RECORD_ID,
                LoggerTest.class.getName()                     
            );

            runAssertsForLog(logs[0], correctLog);
        }         
    }

    @isTest
    private static void shouldSendEmailToErrorNotifyGroup(){
        System.runAs(UserTestDataFactory.getTestRunUser()){
            final String logMessage = 'Test message';
            final Logger logger = LoggerFactory.getLogger();
            logger.log(logMessage); 

            Test.startTest();
            logger.publish();        
            System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.'); 
            Test.stopTest();

            final List<EventLog__c> logs = EventLogSelector.selectByInfo(logMessage);
            System.assertEquals(0, logs.size(), 'Should be no logs.');            
        }
    }
}
