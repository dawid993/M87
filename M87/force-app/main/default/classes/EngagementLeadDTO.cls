public with sharing class EngagementLeadDTO {

    @AuraEnabled 
    public LeadDetails leadDetails {get; set;}

    @AuraEnabled 
    public CommunityUserDetails communityUserDetails {get; set;}

    @AuraEnabled
    public String fileAsBase64Blob {get; set;}
    
    public class LeadDetails{
        @AuraEnabled 
        public String leadTitle {get; set;}

        @AuraEnabled 
        public String leadName {get; set;}

        @AuraEnabled 
        public String email {get; set;}

        @AuraEnabled 
        public String phone {get; set;}

        @AuraEnabled 
        public String companyName {get; set;}

        @AuraEnabled 
        public String industry {get; set;}

        @AuraEnabled 
        public Integer numberOfEmployees {get; set;}

        @AuraEnabled 
        public Decimal annualRevenue {get; set;}

        @AuraEnabled 
        public Boolean doNotCall {get; set;}

        @AuraEnabled 
        public String status {get; set;}

        @AuraEnabled 
        public String rating {get; set;}
    }

    public class CommunityUserDetails{
        @AuraEnabled 
        public String firstName {get; set;}

        @AuraEnabled 
        public String lastName {get; set;}

        @AuraEnabled 
        public String email {get; set;}

        @AuraEnabled 
        public String userName {get; set;}
    }
}
