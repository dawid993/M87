public with sharing class LogProblemAdministratorNotifier {
    
    public void notifyAdministrators(final Exception ex){

    }

    public void notifyAdministrators(final List<Log__e> logs, final List<Database.SaveResult> failedSaveResults){
        final Map<Id,Log__e> logsGroupedById = groupById(logs); 
    }

    private Map<Id, Log__e> groupById(final List<Log__e> logs){
        final Map<Id,Log__e> groupedById = new Map<Id,Log__e>();
        for(Log__e log : logs){
            groupedById.put(log.Id,log);
        }

        return groupedById;
    }

}
