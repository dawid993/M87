public with sharing class CaseServiceImp implements CaseService {
    
    private final CaseSelectorImp caseSelector;

    public CaseServiceImp(CaseSelectorImp caseSelector){
        this.caseSelector = caseSelector;
    }

    public void changeCaseStatus(ID caseId,String newStatus){
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork) Application.UnitOfWork.newInstance();
        uow.registerDirty(new Case(Id=caseId,Status = newStatus));
        uow.commitWork();
    }

    public List<Case> retrieveEngagementCases(ID ownerId){        
        return caseSelector.retrieveEngagementCases(ownerId);
    }
    
    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){           
        return caseSelector.retrieveEngagementCases(searchOptions);
    }
}
