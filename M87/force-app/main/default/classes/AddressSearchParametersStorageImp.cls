public with sharing class AddressSearchParametersStorageImp {
    private String postCode;
    private String city;
    private String street;
    private String houseNumber;

    public AddressSearchParametersStorageImp setPostCode(String postCode){
        this.postCode = postCode;
        return this;
    }

    public AddressSearchParametersStorageImp setCity(String city){
        this.city = city;
        return this;
    }

    public AddressSearchParametersStorageImp setStreet(String street){
        this.street = street;
        return this;
    }

    public AddressSearchParametersStorageImp setHouseNumber(String houseNumber){
        this.houseNumber = houseNumber;
        return this;
    }

    public String getPostCode(){
        return postCode;
    }

    public String getCity(){
        return city;
    }

    public String getStreet(){
        return street;
    }

    public String getHouseNumber(){
        return houseNumber;
    }
}
