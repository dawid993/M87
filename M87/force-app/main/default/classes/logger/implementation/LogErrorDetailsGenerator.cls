public with sharing class LogErrorDetailsGenerator {
    public String generateAffectedLogText(final Map<Id,Log__e> logsGroupedById){
        String logsIdList = '<ol>';
        for(Id logId : logsGroupedById.keySet()){
            logsIdList += '<li>' + logId + '</li>';
        }
        logsIdList += '</ol>';

        return logsIdList;
    }

    public String generateErrorList(final List<Database.SaveResult> failedSaveResults){
        String resultList = '<ol>';
        for(Database.SaveResult saveResult : failedSaveResults){
            if(!saveResult.isSuccess()){
                resultList += '<li>' + saveResult.getErrors()[0].getMessage() + '</li>';
            }            
        }
        resultList += '</ol>';

        return resultList;
    }
}
