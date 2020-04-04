public with sharing class EngagementKanbanController {
    
    @AuraEnabled(cacheable=true)
    public static List<Case> retrieveEngagementCases(){
        EngagementService service = (EngagementService) Application.Service.newInstance(EngagementService.class);
        return service.retrieveEngagementCases( Id.valueOf(UserInfo.getUserId()));
    }

    @AuraEnabled
    public static ApexActionResult changeCaseStatus(String caseId,String status){
        try{
            EngagementService service = (EngagementService) Application.Service.newInstance(EngagementService.class);
            service.updateEngagementCaseStatus(caseId, status);            
        }catch(Exception ex){
            System.debug(ex.getMessage());
            return ApexActionResult.fail(ex.getMessage());
        }

        return ApexActionResult.success();
    }
    
}
