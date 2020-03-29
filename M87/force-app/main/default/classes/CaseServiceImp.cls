public with sharing class CaseServiceImp implements CaseService {
    
    public void changeCaseStatus(ID caseId,String newStatus){
        fflib_ISObjectUnitOfWork uow = (fflib_ISObjectUnitOfWork) Application.UnitOfWork.newInstance();
        uow.registerDirty(new Case(Id=caseId,Status = newStatus));
        uow.commitWork();
    }

    public List<Case> retieveEngagementCases(ID ownerId){
        CaseSelector caseSelector = (CaseSelector) Application.Selector.newInstance(Case.sObjectType);        
        return caseSelector.retieveEngagementCases(ownerId);
    }    
}
