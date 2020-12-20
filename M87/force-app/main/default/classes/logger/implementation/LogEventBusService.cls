public with sharing class LogEventBusService {
    
    private final LogValidator validator;
    private final LogPublishMode publishMode;

    public LogEventBusService(final LogValidator validator,final LogPublishMode publishMode){
        this.validator = validator;
        this.publishMode = publishMode;
    }

    public void publish(final List<Log__e> logs){
        if(publishMode == LogPublishMode.AVOID_PUBLISH_WHEN_ANY_INVALID){
            if(!validator.areLogsValid(logs)){
                throw new InvalidLogsException('Cannot publish because logs are invalid. Make sure Info has been set.');
            }
        } 

        Database.SaveResult[] saveResults = EventBus.publish(logs);  
        ApexUtils.logDataSaveErrorsForFailedResults(saveResults);      
    }
}
