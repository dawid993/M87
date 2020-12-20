public with sharing class LogEventTriggerHandlerImp implements LogEventTriggerHandler {
    public void afterInsert(final List<Log__e> logs, final Map<Id,Log__e> logsById){        
        List<EventLog__b> bigLogs = new List<EventLog__b>();
        for(Log__e currentLog : logs){
            EventLog__b eventLog = new EventLog__b();
            eventLog.Details__c = currentLog.Details__c;
            eventLog.ExceptionTypeName__c = currentLog.ExceptionTypeName__c;
            eventLog.Info__c = currentLog.Info__c;
            eventLog.IsException__c = currentLog.IsException__c ? 1 : 0;
            eventLog.LineNumber__c = currentLog.LineNumber__c;
            eventLog.Quiddity__c = currentLog.Quiddity__c;
            eventLog.RecordId__c = currentLog.RecordId__c;
            eventLog.Severity__c = currentLog.Severity__c;
            eventLog.SourceClass__c = currentLog.SourceClass__c;
            eventLog.SourceMethod__c = currentLog.SourceMethod__c;
            eventLog.TransactionId__c = currentLog.TransactionId__c;
            eventLog.UserId__c = currentLog.UserId__c;

            bigLogs.add(eventLog);
        }

        Database.insertImmediate(bigLogs);
    }    
}
