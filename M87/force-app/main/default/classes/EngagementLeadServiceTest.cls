@isTest
public class EngagementLeadServiceTest {
    
    @isTest
    public static void shouldCreateLeadWith_Details(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            EngagementLeadService engagementLeadService = Modules.instance().service_getEngagementLeadService();
            Lead lead = 
                engagementLeadService.createLead(LeadTestDataFactory.createEngagementLeadDTO_withLeadDetails());

            System.assertNotEquals(null, lead.Id);
            Lead savedLead = engagementLeadService.getEngagementLead(lead.Id);
            System.assertNotEquals(null, savedLead);            
            System.assertEquals(lead.Email.toLowerCase(), savedLead.Email.toLowerCase());
            System.assertEquals(lead.Status, savedLead.Status);
            System.assertEquals(lead.Industry, savedLead.Industry);
        }
    }

    @isTest
    public static void shouldCreateLeadWith_Details_CommunityUser(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            EngagementLeadService engagementLeadService = Modules.instance().service_getEngagementLeadService();
            Lead lead = 
                engagementLeadService.createLead(LeadTestDataFactory.createEngagementLeadDTO_leadDetails_commUser());

            System.assertNotEquals(null, lead.Id);

            Lead savedLead = engagementLeadService.getEngagementLead(lead.Id);
            System.assertNotEquals(null, savedLead);   
            
            List<CommunityUser__c> commUsers = engagementLeadService.getCommunityUsersForEngagementLead(savedLead);
            System.assertNotEquals(0, commUsers.size());            
        }
    }

    @isTest
    public static void shouldCreateLeadWith_Details_CommunityUser_Attachment(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            EngagementLeadService engagementLeadService = Modules.instance().service_getEngagementLeadService();
            Lead lead = 
                engagementLeadService.createLead(LeadTestDataFactory.createEngagementLeadDTO_leadDetails_commUser_file());

            System.assertNotEquals(null, lead.Id);

            Lead savedLead = engagementLeadService.getEngagementLead(lead.Id);
            System.assertNotEquals(null, savedLead);   
            
            List<CommunityUser__c> commUsers = engagementLeadService.getCommunityUsersForEngagementLead(savedLead);
            System.assertNotEquals(0, commUsers.size());  
            System.assertNotEquals(0, getAttachments(savedLead.Id).size());          
        }
    }

    @isTest
    public static void shouldThrowExceptionWhenDTOEmpty(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            Boolean dtoEmptyExceptionThrown = false;
            EngagementLeadService engagementLeadService = Modules.instance().service_getEngagementLeadService();

            try{
                engagementLeadService.createLead(null);
            }catch(IllegalArgumentException ex){
                dtoEmptyExceptionThrown = true;
            }

            System.assertEquals(true, dtoEmptyExceptionThrown);
        }               
    }

    @isTest
    public static void shouldThrowExceptionWhenLeadDetailsEmpty(){
        System.runAs(UserTestDataFactory.buildUserTestRun()){
            Boolean leadDetailsEmptyExceptionThrown = false;
            EngagementLeadService engagementLeadService = Modules.instance().service_getEngagementLeadService();
            
            try{
                engagementLeadService.createLead(new EngagementLeadDTO());
            }catch(IllegalArgumentException ex){
                leadDetailsEmptyExceptionThrown = true;
            }

            System.assertEquals(true, leadDetailsEmptyExceptionThrown);
        }               
    }

    private static List<Attachment> getAttachments(Id parentId){
        return [SELECT Id FROM Attachment WHERE ParentId = :parentId];
    }
}
