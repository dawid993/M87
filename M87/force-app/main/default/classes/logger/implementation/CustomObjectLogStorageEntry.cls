public with sharing class CustomObjectLogStorageEntry implements LogStorageEntry{
    public List<Database.SaveResult> persist(List<Log__e> logs){
        return Database.insert(toEventLog(logs));
    }
    
    private List<EventLog__c> toEventLog(List<Log__e> logs){
        final List<EventLog__c> eventLogs = new List<EventLog__c>();
        for(Log__e currentLog : logs){            
            EventLog__c eventLog = new EventLog__c();
            eventLog.Details__c = currentLog.Details__c;
            eventLog.ExceptionTypeName__c = currentLog.ExceptionTypeName__c;
            eventLog.Info__c = currentLog.Info__c;
            eventLog.IsException__c = currentLog.IsException__c;
            eventLog.LineNumber__c = currentLog.LineNumber__c;
            eventLog.Quiddity__c = currentLog.Quiddity__c;
            eventLog.RecordId__c = currentLog.RecordId__c;
            eventLog.Severity__c = currentLog.Severity__c;
            eventLog.SourceMethod__c = currentLog.SourceMethod__c;
            eventLog.SourceClass__c = currentLog.SourceClass__c;
            eventLog.TransactionId__c = currentLog.TransactionId__c;
            eventLog.UserId__c = currentLog.UserId__c;
            eventLog.EventId__c = currentLog.ReplayId;
            eventLog.EventDate__c = currentLog.CreatedDate;

            eventLogs.add(eventLog);                  
        }

        return eventLogs;
    }
}
