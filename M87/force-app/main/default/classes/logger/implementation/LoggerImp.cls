public with sharing class LoggerImp implements Logger {
    private static final String RANDOM_TRANSACTION_ID = ApexUtils.generateUUID();
    private static final ID NO_ID = null;

    private final Type sourceClass;

    private final List<Log__e> logs;

    private final LogEventBusService eventService;

    public LoggerImp(final LogEventBusService eventService) {
        this.eventService = eventService;
        this.logs = new List<Log__e>();
    }

    public LoggerImp(final Type sourceClass,final LogEventBusService eventService){
        this(eventService);
        this.sourceClass = sourceClass;
    }

    private void addStandardInfo(final Log__e eventLog){
        eventLog.Quiddity__c = Request.getCurrent().getQuiddity().name();
        eventLog.TransactionId__c = getTransactionId();
        eventLog.UserId__c = UserInfo.getUserId();
        eventLog.SourceClass__c = eventLog.SourceClass__c == null ? 
            this.sourceClass?.getName() : eventLog.SourceClass__c;
        eventLog.Severity__c = eventLog.Severity__c != null ? eventLog.Severity__c : LogSeverity.INFO.name();        
    }
    
    private String getTransactionId(){
        final String transactionId = Request.getCurrent().getRequestId();
        if(String.isBlank(transactionId)){
            transactionId = RANDOM_TRANSACTION_ID;
        }

        return transactionId;
    }

    public void log(final Exception ex){
        log(ex,NO_ID);             
    }

    public void log(final Exception ex, final Id recordId){
        final Log__e newLog = LogMappers.mapFromException(ex);
        addStandardInfo(newLog);
        newLog.RecordId__c = recordId;
        logs.add(newLog);        
    }

    public void log(final Log eventLog){
        log(eventLog,LogSeverity.INFO);
    }    

    public void log(final Log eventLog, final LogSeverity severity){
        if(doesNotSourceClassMatches(eventLog.sourceClass)){
            throw new LogSourceClassDoesNotMatchException('Inner source class defined in logger differs from log class.');
        }

        Log__e newLog = LogMappers.mapFromLogObject(eventLog);
        newLog.Severity__c = severity?.name();        
        addStandardInfo(newLog);
        logs.add(newLog);
    }

    private Boolean doesNotSourceClassMatches(final Type logSourceClass){
        return sourceClass != null && logSourceClass != null && logSourceClass != sourceClass;
    }    

    public void log(final String message){
        log(message,LogSeverity.INFO,NO_ID);
    }

    public void log(final String message,final LogSeverity severity){
        log(message,severity,NO_ID);
    }

    public void log(final String message,final LogSeverity severity,final Id recordId){
        if(String.isBlank(message)){
            throw new EmptyLogMessageException('Log message cannot be empty.');
        }

        Log__e newLog = new Log__e();
        newLog.Info__c = message;
        newLog.RecordId__c = recordId;
        newLog.Severity__c = severity?.name();
        addStandardInfo(newLog);
        logs.add(newLog);
    }

    public void publish(){
        if(!logs.isEmpty()){
            eventService.publish(logs);
        }

        logs.clear();
    }
}
