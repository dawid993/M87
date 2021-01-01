public with sharing class LogEventTriggerHandlerFactory {    
    public static LogEventTriggerHandler newHandler(){       
        return new LogEventTriggerHandlerImp(
            new LogProblemAdministratorNotifier(),
            new LogStorageEntryResolver().getLogStorageEntry()
        );
    }   
}
