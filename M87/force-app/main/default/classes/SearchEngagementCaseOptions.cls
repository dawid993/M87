public with sharing class SearchEngagementCaseOptions {
    @AuraEnabled        
    public String phrase {get; set;}

    @AuraEnabled        
    public List<String> selectedOwners {get; set;}

    @AuraEnabled
    public List<String> selectedStatuses {get; set;}

    @AuraEnabled
    public List<String> selectedPriorities {get; set;}

}
