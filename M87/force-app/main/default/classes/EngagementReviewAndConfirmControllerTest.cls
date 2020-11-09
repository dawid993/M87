@isTest
public with sharing class EngagementReviewAndConfirmControllerTest {
    
    @isTest
    public static void shouldCreateLeadAndReturnSuccess(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            ApexActionResult result = EngagementReviewAndConfirmController.saveLead(
                LeadTestDataFactory.createEngagementLeadDTO_withLeadDetails()
            );
            
            System.assertEquals(true, result.success);
            System.assertEquals(true, LeadTestDataFactory.isAnyLeadInDatabase());
        }
    }    
}
