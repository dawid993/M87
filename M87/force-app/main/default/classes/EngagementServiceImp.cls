public with sharing class EngagementServiceImp implements EngagementService {
    private static final Set<String> allowedStatuses = new Set<String>{
        'To Do',
        'In Progress',
        'Done - success',
        'Done - failure'
    };

    public List<Case> retrieveEngagementCases(ID ownerId){
        if(String.isBlank(ownerId)){
            throw new Exceptions.UndefinedOwnerException('Cannot retrieve cases for undefined owner.');
        }

        List<Case> engagementCases = new List<Case>();

        try{
            CaseService caseService = newCaseServiceInstance();
            engagementCases = caseService.retrieveEngagementCases(ownerId);
        }catch(Exception ex){
            System.debug(ex.getMessage());
            throw new Exceptions.UnableToReadDataException('Cannot retrieve data',ex);
        }

        return engagementCases;
    }

    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){
        if(searchOptions == null){
            throw new Exceptions.InvalidServiceActionParametersException('Invalid parameter.');
        }

        List<Case> engagementCases = new List<Case>();

        try{
            System.debug(searchOptions);
            CaseService caseService = newCaseServiceInstance();
            engagementCases = caseService.retrieveEngagementCases(searchOptions);
        }catch(Exception ex){
            System.debug(ex.getMessage());
            throw new Exceptions.UnableToReadDataException('Cannot retrieve data',ex);
        }

        return engagementCases;
    }

    public void updateEngagementCaseStatus(ID caseId,String status){
        if(String.isBlank(caseId) || String.isBlank(status)){
            throw new Exceptions.InvalidServiceActionParametersException('At least one of input param is empty.');
        }

        if(!allowedStatuses.contains(status)){
            throw new Exceptions.InvalidServiceActionParametersException(status+' is invalid status for engagement case');
        }

        CaseService caseService = newCaseServiceInstance();

        try{
            caseService.changeCaseStatus(caseId, status);
        }catch(Exception ex){
            throw new Exceptions.UnableToSaveDataException('Cannot change case status',ex);
        }
    }

    private CaseService newCaseServiceInstance(){
        return (CaseService) Application.Service.newInstance(CaseService.class);
    }
}
