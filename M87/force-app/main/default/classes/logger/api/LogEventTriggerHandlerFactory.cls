public with sharing class LogEventTriggerHandlerFactory {  
    private static final Integer MAX_RETRY_ATTEMPTS = 6;

    public static LogEventTriggerHandler newHandler(){       
        return new LogEventTriggerHandlerImp(
            new LogProblemAdministratorNotifier(               
                GroupUserServiceFactory.newInstance(),
                RepositoryFactory.newEmailTemplateRepository()
            ),
            new LogStorageEntryResolver().getLogStorageEntry(),
            MAX_RETRY_ATTEMPTS
        );
    }   
}
