public with sharing class EngagementKanbanController {
    
    @AuraEnabled
    public static ApexActionResult retrieveEngagementCases(String searchOptions){
        try{            
            SearchEngagementCaseOptions parsedSearchOptions = 
                (SearchEngagementCaseOptions) JSON.deserialize(searchOptions, SearchEngagementCaseOptions.class);
            EngagementService service = (EngagementService) Application.Service.newInstance(EngagementService.class);
            return ApexActionResult.success(service.retrieveEngagementCases(parsedSearchOptions));
        }catch(Exception ex){
            System.debug(ex.getMessage()+' : '+ex.getStackTraceString());
            return ApexActionResult.fail(ex.getMessage()+' : '+ex.getStackTraceString());
        }
        
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
    
    @AuraEnabled
    public static ApexActionResult searchOwners(String searchPhrase){
        try{
            UserService userService = (UserService) Application.Service.newInstance(UserService.class);
            return ApexActionResult.success(
                userService.searchOwnerByName(searchPhrase)
            );
        }catch(Exception ex){
            System.debug(ex.getMessage());
            return ApexActionResult.fail(ex.getMessage());
        }
    }
}
