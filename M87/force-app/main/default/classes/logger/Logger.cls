public with sharing class Logger {
    private static final ID NO_ID = null;

    private final Type sourceClass;

    private final List<Log__e> logs;

    public Logger() {
        this.logs = new List<Log__e>();
    }

    public Logger(final Type sourceClass){
        this();
        this.sourceClass = sourceClass;
    }

    private void addStandardInfo(Log__e eventLog){
        eventLog.Quiddity__c = Request.getCurrent().getQuiddity().name();
        eventLog.TransactionId__c = Request.getCurrent().getRequestId();
        eventLog.UserId__c = UserInfo.getUserId();
        eventLog.SourceClass__c = eventLog.SourceClass__c == null ? 
            this.sourceClass?.getName() : eventLog.SourceClass__c;
        eventLog.Severity__c = eventLog.Severity__c != null ? eventLog.Severity__c : LogSeverity.INFO.name();
    }

    public void log(Exception ex){
        log(ex,NO_ID);             
    }

    public void log(Exception ex, Id recordId){
        Log__e newLog = LogMappers.mapFromException(ex);
        addStandardInfo(newLog);
        newLog.RecordId__c = recordId;
        logs.add(newLog);        
    }

    public void log(Log eventLog){
        log(eventLog, NO_ID, LogSeverity.INFO);
    }

    public void log(Log eventLog, LogSeverity severity){
        log(eventLog, NO_ID, severity);        
    }

    public void log(Log eventLog, Id recordId, LogSeverity severity){
        if(!doesSourceClassMatches(eventLog.sourceClass)){
            throw new LogSourceClassDoesNotMatchException();
        }

        Log__e newLog = LogMappers.mapFromLogObject(eventLog);
        newLog.Severity__c = severity?.name();
        newLog.RecordId__c = recordId;
        addStandardInfo(newLog);
        logs.add(newLog);
    }

    private Boolean doesSourceClassMatches(Type logSourceClass){
        return sourceClass != null && logSourceClass != null && logSourceClass == sourceClass;
    }    

    public void log(String message){
        log(message,LogSeverity.INFO);
    }

    public void log(String message, LogSeverity severity){
        if(String.isBlank(message)){
            throw new EmptyLogMessageException();
        }

        Log__e newLog = new Log__e();
        newLog.Info__c = message;
        newLog.Severity__c = severity?.name();

        logs.add(newLog);
    }
}
