public with sharing class EngagementKanbanController {
    
    @AuraEnabled
    public static ApexActionResult retrieveEngagementCases(String searchOptions){
        try{            
            SearchEngagementCaseOptions parsedSearchOptions = 
                (SearchEngagementCaseOptions) JSON.deserialize(searchOptions, SearchEngagementCaseOptions.class);
            EngagementCaseService service = Modules.instance().service_getEngagementCaseService();

            return ApexActionResult.success(
                CaseConverter.convertToCaseDTO(service.retrieveEngagementCases(parsedSearchOptions))
            );
        }catch(Exception ex){
            System.debug(ex.getMessage()+' : '+ex.getStackTraceString());
            return ApexActionResult.fail(ex.getMessage()+' : '+ex.getStackTraceString());
        }        
    }

    @AuraEnabled
    public static ApexActionResult changeCaseStatus(String caseId,String status){
        try{
            EngagementCaseService service = Modules.instance().service_getEngagementCaseService();
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
            UserService userService = Modules.instance().service_getUserService();
            return ApexActionResult.success(
                userService.searchOwnerByName(searchPhrase)
            );
        }catch(Exception ex){
            System.debug(ex.getMessage());
            return ApexActionResult.fail(ex.getMessage());
        }
    }
}
