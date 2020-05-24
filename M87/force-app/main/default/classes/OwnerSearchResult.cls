public with sharing class OwnerSearchResult {
    @AuraEnabled
    public ID id;

    @AuraEnabled
    public String label;

    public OwnerSearchResult(ID userID,String ownerName){
        this.id = userID;
        this.label = ownerName;
    }

    public OwnerSearchResult(User user){
        this.id = user.ID;
        this.label = user.Name;
    }
}
