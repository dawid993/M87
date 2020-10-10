public with sharing class CommunityUserCreationController {
    
    @AuraEnabled
    public static ApexActionResult searchForUsernameOrEmail(final String username, final String email){
        ApexActionResult result;       

        try{
            final UsernameOrEmailSearchService searchService = Modules.instance().service_getUsernameOrEmailSearch();
            UsernameAndEmailCountDTO dto = searchService.searchForUsernameOrEmail(username, email);
            result = ApexActionResult.success(dto);
        }catch(Exception ex){
            result = ApexActionResult.fail(ApexUtils.APEX_ACTION_EXCEPTION_INFO);
            ApexUtils.logException(LoggingLevel.ERROR, ex);
        }

        return result;
    }     
    
}
