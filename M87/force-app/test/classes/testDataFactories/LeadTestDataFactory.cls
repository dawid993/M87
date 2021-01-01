@isTest
public class LeadTestDataFactory {
    public static EngagementLeadDTO createEngagementLeadDTO_withLeadDetails(){
        final EngagementLeadDTO dto = new EngagementLeadDTO();
        dto.leadDetails = createLeadDetails();
        
        return dto;
    }

    public static EngagementLeadDTO createEngagementLeadDTO_leadDetails_commUser(){
        final EngagementLeadDTO dto = new EngagementLeadDTO();
        dto.leadDetails = createLeadDetails();
        dto.communityUserDetails = createCommunityUser(); 

        return dto;
    }

    public static EngagementLeadDTO createEngagementLeadDTO_leadDetails_commUser_file(){
        final EngagementLeadDTO dto = new EngagementLeadDTO();
        dto.leadDetails = createLeadDetails();
        dto.communityUserDetails = createCommunityUser();        
        dto.fileAsBase64Blob = createFakeBlob();

        return dto;
    }

    private static EngagementLeadDTO.LeadDetails createLeadDetails(){
        final EngagementLeadDTO.LeadDetails details = new EngagementLeadDTO.LeadDetails();
        details.leadTitle = 'Test';
        details.leadName = 'Test Test';
        details.email = 'testLeadDTO254124@test.m87.com.pl';
        details.phone = '0123456789';
        details.companyName = 'Test';
        details.industry = 'Banking';
        details.numberOfEmployees = 10;
        details.annualRevenue = 1000000.0;
        details.doNotCall = true;
        details.status = 'To Do';
        details.rating = 'Hot'; 

        return details;
    }

    private static EngagementLeadDTO.CommunityUserDetails createCommunityUser(){
        final EngagementLeadDTO.CommunityUserDetails comUser = new EngagementLeadDTO.CommunityUserDetails();
        comUser.firstName = 'Test';
        comUser.lastName = 'Test';
        comUser.email = 'testLeadDTO254124@test.m87.com.pl';
        comUser.userName = 'testLeadDTO254124@test.m87.com.pl';

        return comUser;
    }

    private static String createFakeBlob(){
        return 'YXNkYXNkYWRz';
    }

    public static Boolean isAnyLeadInDatabase(){
        return [SELECT count() FROM Lead] > 0;
    }
}
