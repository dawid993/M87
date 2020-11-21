public with sharing class EngagementCaseDTO {
    
    @AuraEnabled   
    public DateTime CreatedDate {get; set;}

    @AuraEnabled   
    public String Description {get; set;}

    @AuraEnabled   
    public Id id {get; set;}

    @AuraEnabled   
    public String Priority {get; set;}

    @AuraEnabled   
    public String Status {get; set;}

    @AuraEnabled   
    public String Subject {get; set;}

    @AuraEnabled
    public String ownerName {get;set;}
}
