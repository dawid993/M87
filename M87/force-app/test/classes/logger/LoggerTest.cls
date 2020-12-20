@isTest
public with sharing class LoggerTest {

    private class LogTestException extends Exception {}

    private static final Boolean PARTIAL_PUBLISH = false;

    @isTest
    private static void shouldCreateLogUsingStringParamMethod(){
        final String logMessage = 'Test message';
        Logger logger = LoggerFactory.getLogger();
        logger.log(logMessage);

        Test.startTest();
        logger.publish();        
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.'); 
        Test.stopTest();
    }

    @isTest
    private static void shouldCreateLogUsingStringAndSeverityParamsMethod(){
        final String logMessage = 'Test message';
        Logger logger = LoggerFactory.getLogger();
        logger.log(logMessage, LogSeverity.FINEST);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogUsingStringAndSeverityAndRecordIdParamsMethod(){
        final String logMessage = 'Test message';
        final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());
        
        Logger logger = LoggerFactory.getLogger();
        logger.log(logMessage, LogSeverity.FINEST, fakeAccountId);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogUsingExceptionParamMethod(){       
        Logger logger = LoggerFactory.getLogger();
        logger.log(new LogTestException());

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogUsingExceptionAndRecordIdParamsMethod(){       
        final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());

        Logger logger = LoggerFactory.getLogger();
        logger.log(new LogTestException(), fakeAccountId);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogUsingLogParamMethod(){  
        final String message = 'Message';   
        Logger logger = LoggerFactory.getLogger();
        logger.log(new Log(message));

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogUsingLogAndSeverityParamsMethod(){     
        final String message = 'Message';   
        final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());

        Logger logger = LoggerFactory.getLogger();
        logger.log(new Log(message), LogSeverity.FINEST);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogWithSourceUsingStringParamMethod(){
        final String logMessage = 'Test message';
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(logMessage);

        Test.startTest();
        logger.publish();        
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.'); 
        Test.stopTest();
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingStringAndSeverityParamsMethod(){
        final String logMessage = 'Test message';
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(logMessage, LogSeverity.FINEST);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingStringAndSeverityAndRecordIdParamsMethod(){
        final String logMessage = 'Test message';
        final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());
        
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(logMessage, LogSeverity.FINEST, fakeAccountId);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingExceptionParamMethod(){       
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(new LogTestException());

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingExceptionAndRecordIdParamsMethod(){       
        final Id fakeAccountId = fflib_IDGenerator.generate(Account.getSObjectType());

        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(new LogTestException(), fakeAccountId);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingLogParamMethod(){  
        final String message = 'Message';   
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(new Log(message));

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldCreateLogWithSourceClassUsingLogAndSeverityParamsMethod(){
        final String message = 'Message';   
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(new Log(message), LogSeverity.FINEST);

        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');
        Test.stopTest();        
    }

    @isTest
    private static void shouldThrowExceptionBecauseSourceClassDoesNotMatch(){       
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

    @isTest
    public static void shouldThrowExceptionBecauseLogMessageEmpty(){        
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

    @isTest
    public static void shouldClearLogBufferAfterPublish(){
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);
        logger.log(new Log('Message'));
        logger.log(new Log('Message 2'));

        Test.startTest();

        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');

        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');

        Test.stopTest();        
    }

    @isTest
    public static void shouldClearLogBufferAfterPublishAndPublishNewOne(){
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);        
        Test.startTest();

        logger.log(new Log('Message')); 
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish one event.');

        logger.log(new Log('Message 2'));
        logger.publish();
        System.assertEquals(2, Limits.getPublishImmediateDML(), 'Should publish two events.');
        
        Test.stopTest();        
    }

    @isTest
    public static void shouldThrowExceptionBecauseInfoIsNull(){
        Logger logger = LoggerFactory.getLogger();  
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

    @isTest
    public static void shouldFailPublishSilentlyBecauseInfoEmpty(){
        Logger logger = LoggerFactory.getLogger(PARTIAL_PUBLISH);  
        logger.log(new Log()); 
        logger.log(new Log('Message'));
         
        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish 0 events.');
        Test.stopTest();           
    }

    @isTest
    public static void shouldThrowExceptionBecauseInfoIsNullTestWithClassVariant(){
        Logger logger = LoggerFactory.getLogger(LoggerTest.class);  
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

    @isTest
    public static void shouldFailPublishSilentlyBecauseInfoEmptyTestWithClassVariant(){
        Logger logger = LoggerFactory.getLogger(LoggerTest.class, PARTIAL_PUBLISH);  
        logger.log(new Log()); 
        logger.log(new Log('Message'));
         
        Test.startTest();
        logger.publish();
        System.assertEquals(1, Limits.getPublishImmediateDML(), 'Should publish 0 events.');
        Test.stopTest();           
    }
}
