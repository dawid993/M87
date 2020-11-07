public with sharing class EngagementLeadDTO {

    @AuraEnabled 
    public LeadDetails leadDetails;

    @AuraEnabled 
    public CommunityUserDetails communityUserDetails;

    @AuraEnabled
    public String fileAsBase64Blob;
    
    public class LeadDetails{
        @AuraEnabled 
        public String leadTitle;

        @AuraEnabled 
        public String leadName;

        @AuraEnabled 
        public String email;

        @AuraEnabled 
        public String phone;

        @AuraEnabled 
        public String companyName;

        @AuraEnabled 
        public String industry;

        @AuraEnabled 
        public Integer numberOfEmployees;

        @AuraEnabled 
        public Decimal annualRevenue;

        @AuraEnabled 
        public Boolean doNotCall;

        @AuraEnabled 
        public String status;

        @AuraEnabled 
        public String rating;
    }

    public class CommunityUserDetails{
        @AuraEnabled 
        public String firstName;

        @AuraEnabled 
        public String lastName;

        @AuraEnabled 
        public String email;

        @AuraEnabled 
        public String userName;
    }
}
