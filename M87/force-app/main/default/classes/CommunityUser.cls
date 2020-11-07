public with sharing class CommunityUser {
    private CommunityUser__c communityUser;

    public CommunityUser() {
        this.communityUser = new CommunityUser__c();
    }

    public CommunityUser(CommunityUser__c user){
        this.communityUser = user;
    }

    public void setFirstName(String firstName){
        communityUser.firstName__c = firstName;
    }    

    public String getFirstName(){
        return communityUser.firstName__c;
    }

    public void setLastName(String lastName){
        communityUser.LastName__c = lastName;
    }    

    public String getLastName(){
        return communityUser.LastName__c;
    }

    public void setEmail(String email){
        communityUser.email__c = email;
    }

    public String getEmail(){
        return communityUser.email__c;
    }

    public void setUsername(String email){
        communityUser.username__c = email;
    }

    public String getUsername(){
        return communityUser.username__c;
    }
}
