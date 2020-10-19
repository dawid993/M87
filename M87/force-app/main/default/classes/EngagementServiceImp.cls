public with sharing class EngagementServiceImp implements EngagementService {
    private static final Set<String> allowedStatuses = new Set<String>{
        'To Do',
        'In Progress',
        'Done - success',
        'Done - failure'
    };    

    private final EngagementCaseSelector caseSelector;

    public EngagementServiceImp(EngagementCaseSelector caseSelector){
        this.caseSelector = caseSelector;
    }

    public List<Case> retrieveEngagementCases(ID ownerId){
        if(String.isBlank(ownerId)){
            throw new IllegalArgumentException('Cannot retrieve cases for undefined owner.');
        }
       
        return caseSelector.retrieveEngagementCases(ownerId);   
    }

    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){
        if(searchOptions == null){
            throw new IllegalArgumentException('Invalid parameter.');
        }

        return caseSelector.retrieveEngagementCases(searchOptions);        
    }

    public void updateEngagementCaseStatus(ID caseId,String status){
        if(String.isBlank(caseId) || String.isBlank(status)){
            throw new IllegalArgumentException('At least one of input param is empty.');
        }

        if(!allowedStatuses.contains(status)){
            throw new IllegalArgumentException(status+' is invalid status for engagement case');
        }
        
        update new Case(Id=caseId,Status = status);       
    }
}
