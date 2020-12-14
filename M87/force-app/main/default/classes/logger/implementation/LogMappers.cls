public with sharing class LogMappers {
    
    public static Log__e mapFromException(Exception ex){
        return new FromExceptionObject().doMap(ex);
    }

    public static Log__e mapFromLogObject(Log log){
        return new FromLogObject().doMap(log);
    }

    private class FromExceptionObject {
        private Log__e doMap(Exception ex){
            Log__e eventLog = new Log__e();
            eventLog.IsException__c = true;
            eventLog.Info__c = ex.getMessage();
            eventLog.Details__c = 'Message: ' +ex.getMessage() + ', Cause: ' + ex.getCause() + ', Stack: ' +
                ex.getStackTraceString();
            eventLog.LineNumber__c = ex.getLineNumber();
            eventLog.ExceptionTypeName__c = ex.getTypeName();
            eventLog.Severity__c = LogSeverity.ERROR.name();

            return eventLog;
        }
    }

    private class FromLogObject {
        private Log__e doMap(Log currentLog){
            Log__e eventLog = new Log__e();
            eventLog.IsException__c = false;
            eventLog.Info__c = currentLog.info;
            eventLog.Details__c = currentLog.details;
            eventLog.SourceClass__c = currentLog.sourceClass?.getName();
            eventLog.SourceMethod__c = currentLog.methodName;          
            
            return eventLog;
        }
    }
}
