public with sharing class EngagementCaseService{
    private static final Set<String> ALLOWED_STATUSES = new Set<String>{
        CaseUtils.STATUS_TO_DO,
        CaseUtils.STATUS_IN_PROGRES,
        CaseUtils.STATUS_DONE_SUCCESS,
        CaseUtils.STATUS_DONE_FAILURE      
    };    

    private final CaseRepository caseRepository;

    public EngagementCaseService(CaseRepository caseRepository){
        this.caseRepository = caseRepository;
    }

    public List<Case> retrieveEngagementCasesByOwnerId(final ID ownerId){
        if(String.isBlank(ownerId)){
            throw new IllegalArgumentException('Cannot retrieve cases for undefined owner.');
        }
       
        return caseRepository.retrieveEngagementCases(ownerId);   
    }

    public List<Case> retrieveEngagementCases(final SearchEngagementCaseOptions searchOptions){
        if(searchOptions == null){
            throw new IllegalArgumentException('Search option cannot be blank.');
        }

        if(areSearchOptionInvalid(searchOptions)){
            throw new IllegalArgumentException('Search options parameters are invalid. Cannot perform search!');
        }

        return caseRepository.retrieveEngagementCases(searchOptions);        
    }

    private Boolean areSearchOptionInvalid(final SearchEngagementCaseOptions options){
        return options.selectedOwners.isEmpty() || options.selectedPriorities.isEmpty() || 
            options.selectedStatuses.isEmpty();
    }

    public void updateEngagementCaseStatus(final ID caseId,final String status){
        if(String.isBlank(caseId) || String.isBlank(status)){
            throw new IllegalArgumentException('At least one of input param is empty.');
        }

        if(!ALLOWED_STATUSES.contains(status)){
            throw new IllegalArgumentException(status+' is invalid status for engagement case');
        }     

        caseRepository.save(new Case(Id=caseId,Status = status));       
    }    
}
