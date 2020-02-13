public with sharing class AddressStructure {
    public final String street;
    public final String city;
    public final String disctrict;    
    public final String postCode;
    public final String houseNumber;

    public AddressStructure(String street,String city,String disctrict,String postCode,String houseNumber) {
        this.street = street;
        this.city = city;
        this.disctrict = disctrict;
        this.postCode = postCode;
        this.houseNumber = houseNumber;
    }
}