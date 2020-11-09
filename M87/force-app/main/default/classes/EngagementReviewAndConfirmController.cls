public with sharing class EngagementReviewAndConfirmController {

    @AuraEnabled   
    public static ApexActionResult saveLead(EngagementLeadDTO leadDTO){
        ApexActionResult result;  
        System.debug(leadDTO);
        try{
            final EngagementLeadService leadService = Modules.instance().service_getEngagementLeadService();
            leadService.createLead(leadDto);
            result = ApexActionResult.success();
        }catch(Exception ex){
            result = ApexActionResult.fail(ApexUtils.APEX_ACTION_EXCEPTION_INFO);
            ApexUtils.logException(LoggingLevel.ERROR, ex);
        }

        return result;
    }
}
