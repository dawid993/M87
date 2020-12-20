public with sharing class LogValidator {
    
    public Boolean areLogsValid(final List<Log__e> logs){
        for(Log__e currentLog : logs){
            if(!isLogValid(currentLog)){
                return false;
            }
        } 

        return true;
    }

    private Boolean isLogValid(final Log__e log){
        return 
            String.isNotBlank(log?.Info__c) &&
            String.isNotBlank(log?.Severity__c) &&
            String.isNotBlank(log?.TransactionId__c) && 
            String.isNotBlank(log?.UserId__c);
    }
}
