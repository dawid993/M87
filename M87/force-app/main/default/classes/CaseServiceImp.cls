public with sharing class CaseServiceImp implements CaseService {
    
    public void changeCaseStatus(ID caseId,String newStatus){
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork) Application.UnitOfWork.newInstance();
        uow.registerDirty(new Case(Id=caseId,Status = newStatus));
        uow.commitWork();
    }

    public List<Case> retrieveEngagementCases(ID ownerId){
        CaseSelector caseSelector = (CaseSelector) Application.Selector.newInstance(Case.sObjectType);        
        return caseSelector.retrieveEngagementCases(ownerId);
    }
    
    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){
        CaseSelector caseSelector = (CaseSelector) Application.Selector.newInstance(Case.sObjectType);        
        return caseSelector.retrieveEngagementCases(searchOptions);
    }
}
