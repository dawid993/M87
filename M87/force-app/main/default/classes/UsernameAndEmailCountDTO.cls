public with sharing class UsernameAndEmailCountDTO {
    
    @AuraEnabled
    public String searchedUsername {get;set;}

    @AuraEnabled    
    public String searchedEmail {get;set;}

    @AuraEnabled
    public Integer usernameCount {get;set;}

    @AuraEnabled
    public Integer emailCount {get;set;}

}
