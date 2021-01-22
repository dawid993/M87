public with sharing class LogEventTriggerHandlerImp implements LogEventTriggerHandler {    

    private final LogProblemAdministratorNotifier notifier;    
    private final LogStorageEntry storageEntry;
    private final Integer allowedRetryAttempts;

    public LogEventTriggerHandlerImp(
        final LogProblemAdministratorNotifier notifier,
        final LogStorageEntry storageEntry,
        final Integer allowedRetryAttempts
    ){
        this.notifier = notifier;      
        this.storageEntry = storageEntry;
        this.allowedRetryAttempts = allowedRetryAttempts;
    }

    public void afterInsert(final List<Log__e> logs){   
        if(logs == null){
            throw new IllegalArgumentException('Logs are not initialized.');
        }   

        final List<Log__e> notNullLogs = filterNotNull(logs);

        try{            
            if(!notNullLogs.isEmpty()){
                List<Database.SaveResult> saveResults = storageEntry.persist(notNullLogs);
                notifyAdministratorsIfAnyFailure(logs, saveResults);
            }           
        }catch(Exception ex){
            handleException(ex);
        }       
    } 
    
    private List<Log__e> filterNotNull(final List<Log__e> logs){
        final List<Log__e> notNullLogs = new List<Log__e>();
        for(Log__e log : logs){
            if(log != null){
                notNullLogs.add(log);
            }
        }

        return notNullLogs;
    }  

    private void notifyAdministratorsIfAnyFailure(final List<Log__e> logs, List<Database.SaveResult> saveResults){
        final List<Database.SaveResult> failedSaveResults = new List<Database.SaveResult>();
        for(Database.SaveResult result : saveResults){
            if(!result.isSuccess()){
                failedSaveResults.add(result);
            }
        }

        if(!failedSaveResults.isEmpty()){
            notifier.notifyAdministrators(logs, failedSaveResults);
        }
    }

    private void handleException(final Exception ex){
        ApexUtils.logException(LoggingLevel.DEBUG, ex);
        
        if(EventBus.TriggerContext.currentContext().retries < allowedRetryAttempts){
            throw new EventBus.RetryableException(ex.getMessage()+' '+ex.getCause()+' '+ex.getStackTraceString());
        }else{
            notifier.notifyAdministrators(ex);
        }
    }     
}
