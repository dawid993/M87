public with sharing class ApexUtils {
    public static final String APEX_ACTION_EXCEPTION_INFO = 'Unfortunatelly action execution failed';

    public static void logException(LoggingLevel level,Exception ex){
        System.debug(
            level, 
            ex.getTypeName()+' '+ex.getMessage()+' '+ex.getStackTraceString()+' '+ex.getLineNumber()+' '+ex.getCause()
        );        
    }
}
