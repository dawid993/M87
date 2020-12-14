public with sharing class Log {    
    public final String info;
    public final Id recordId;
    public final Type sourceClass;
    public final String methodName;
    public final String details;

    public Log() {}

    public Log(final String info) {
        this.info = info;        
    }

    public Log(
        final String info,
        final Id recordId,
        final Type sourceClass,
        final String methodName,
        final String details
    ) {
        this.info = info;
        this.recordId = recordId;
        this.sourceClass = sourceClass;
        this.methodName = methodName;
        this.details = details;
    }
}
