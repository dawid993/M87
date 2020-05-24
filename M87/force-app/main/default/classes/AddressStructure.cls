public with sharing class AddressStructure {
    @AuraEnabled
    public final String id;
    @AuraEnabled
    public final String street;
    @AuraEnabled
    public final String city;
    @AuraEnabled
    public final String disctrict;  
    @AuraEnabled  
    public final String postCode;
    @AuraEnabled
    public final String houseNumber;

    public AddressStructure(String id,String street,String city,String disctrict,String postCode,String houseNumber) {
        this.id = id;
        this.street = street;
        this.city = city;
        this.disctrict = disctrict;
        this.postCode = postCode;
        this.houseNumber = houseNumber;
    }
}