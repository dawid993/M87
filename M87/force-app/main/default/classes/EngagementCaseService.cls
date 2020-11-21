public with sharing class EngagementCaseService{
    private static final Set<String> allowedStatuses = new Set<String>{
        'To Do',
        'In Progress',
        'Done - success',
        'Done - failure'
    };    

    private final CaseRepository caseRepository;

    public EngagementCaseService(CaseRepository caseRepository){
        this.caseRepository = caseRepository;
    }

    public List<Case> retrieveEngagementCases(ID ownerId){
        if(String.isBlank(ownerId)){
            throw new IllegalArgumentException('Cannot retrieve cases for undefined owner.');
        }
       
        return caseRepository.retrieveEngagementCases(ownerId);   
    }

    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){
        if(searchOptions == null){
            throw new IllegalArgumentException('Invalid parameter.');
        }

        return caseRepository.retrieveEngagementCases(searchOptions);        
    }

    public void updateEngagementCaseStatus(ID caseId,String status){
        if(String.isBlank(caseId) || String.isBlank(status)){
            throw new IllegalArgumentException('At least one of input param is empty.');
        }

        if(!allowedStatuses.contains(status)){
            throw new IllegalArgumentException(status+' is invalid status for engagement case');
        }     

        caseRepository.save(new Case(Id=caseId,Status = status));       
    }    
}
