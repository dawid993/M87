public with sharing class SearchEngagementCaseOptions {
    public static final String ALL_OWNER_OPTION_ID = 'ALL_OWNERS_SEARCH' ;

    @AuraEnabled        
    public String phrase {get; set;}

    @AuraEnabled        
    public List<String> selectedOwners {get; set;}

    @AuraEnabled
    public List<String> selectedStatuses {get; set;}

    @AuraEnabled
    public List<String> selectedPriorities {get; set;}

}
