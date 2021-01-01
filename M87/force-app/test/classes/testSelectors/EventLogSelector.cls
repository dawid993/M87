@isTest
public with sharing class EventLogSelector {
    
    public static List<EventLog__c> selectByInfo(String info){
        return [
            SELECT 
                CreatedDate,
                Details__c,
                EventDate__c,
                EventId__c,
                Name,
                ExceptionTypeName__c,
                Info__c,
                IsException__c,
                LastModifiedById,
                LineNumber__c,
                OwnerId,
                Quiddity__c,
                RecordId__c,
                Record_Id__c,
                Severity__c,
                SourceClass__c,
                SourceMethod__c,
                TransactionId__c,
                UserId__c
            FROM EventLog__c
            WHERE Info__c = :info
        ];
    }

    public static List<EventLog__c> selectAll(){
        return [
            SELECT 
                CreatedDate,
                Details__c,
                EventDate__c,
                EventId__c,
                Name,
                ExceptionTypeName__c,
                Info__c,
                IsException__c,
                LastModifiedById,
                LineNumber__c,
                OwnerId,
                Quiddity__c,
                RecordId__c,
                Record_Id__c,
                Severity__c,
                SourceClass__c,
                SourceMethod__c,
                TransactionId__c,
                UserId__c
            FROM EventLog__c            
        ];
    }
}
