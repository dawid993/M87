public with sharing class EngagementKanbanController {
    
    @AuraEnabled(cacheable=true)
    public static List<Case> retrieveEngagementCases(){
        CaseSelectorImp caseSelector = new CaseSelectorImp();
        return caseSelector.retieveEngagementCases(UserInfo.getUserId());
    }

    @AuraEnabled
    public static ApexActionResult changeCaseStatus(String caseId,String status){
        try{
            new CaseServiceImp().changeCaseStatus(caseId, status);            
        }catch(Exception ex){
            System.debug(ex.getMessage());
            return ApexActionResult.fail(ex.getMessage());
        }

        return ApexActionResult.success();
    }
    
}
