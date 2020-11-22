public with sharing class SearchEngagementCaseOptionsBuilder {
    private SearchEngagementCaseOptions options;

    public SearchEngagementCaseOptionsBuilder(){
        initBuilder();
    }

    private void initBuilder(){
        options = new SearchEngagementCaseOptions();
        options.selectedOwners = new List<String>();
        options.selectedStatuses = new List<String>();
        options.selectedPriorities = new List<String>();
    }

    public SearchEngagementCaseOptionsBuilder addOwners(List<String> owners){
        options.selectedOwners.addAll(owners);
        return this;
    }

    public SearchEngagementCaseOptionsBuilder addStatuses(List<String> statuses){
        options.selectedStatuses.addAll(statuses);
        return this;
    }

    public SearchEngagementCaseOptionsBuilder addPriorities(List<String> priorities){
        options.selectedPriorities.addAll(priorities);
        return this;
    }
    
    public SearchEngagementCaseOptionsBuilder setPhrase(String phrase){
        options.phrase = phrase;
        return this;
    }

    public SearchEngagementCaseOptions build(){
        SearchEngagementCaseOptions temp = options;
        initBuilder();
        return temp;
    }
}
