public with sharing class BigObjectLogStorageEntry implements LogStorageEntry{
    public List<Database.SaveResult> persist(List<Log__e> logs){
        return Database.insertImmediate(toEventLog(logs));
    }
    
    private List<EventLog2__b> toEventLog(List<Log__e> logs){
        final List<EventLog2__b> eventLogs = new List<EventLog2__b>();
        for(Log__e currentLog : logs){            
            EventLog2__b eventLog = new EventLog2__b();
            eventLog.Details__c = currentLog.Details__c;
            eventLog.ExceptionTypeName__c = currentLog.ExceptionTypeName__c;
            eventLog.Info__c = currentLog.Info__c;
            eventLog.IsException__c = currentLog.IsException__c ? 1 : 0;
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
