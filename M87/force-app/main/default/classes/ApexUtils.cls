public with sharing class ApexUtils {
    public static final String APEX_ACTION_EXCEPTION_INFO = 'Unfortunatelly action execution failed';

    public static void logException(LoggingLevel level,Exception ex){
        System.debug(
            level, 
            ex.getTypeName()+' '+ex.getMessage()+' '+ex.getStackTraceString()+' '+ex.getLineNumber()+' '+ex.getCause()
        );        
    }

    public static void logDataSaveErrorsForFailedResults(List<Database.SaveResult> results){
        for(Database.SaveResult result : results != null ? results : new List<Database.SaveResult>()){
            if(!result.isSuccess()){
                for(Database.Error err : result.getErrors()) {
                    System.debug('Error returned: ' +  err.getStatusCode() + ' - ' + err.getMessage());
                }
            }
        }       
    }

    public static String generateUUID(){
        Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        return h.SubString(0,8) 
            + '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
    }
}
