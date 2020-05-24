public with sharing class AddressSearchParametersStorageImp  implements AddressSearchParametersStorage{
    private String postCode;
    private String city;
    private String street;
    private String houseNumber;

    public AddressSearchParametersStorage setPostCode(String postCode){
        this.postCode = postCode;
        return this;
    }

    public AddressSearchParametersStorage setCity(String city){
        this.city = city;
        return this;
    }

    public AddressSearchParametersStorage setStreet(String street){
        this.street = street;
        return this;
    }

    public AddressSearchParametersStorage setHouseNumber(String houseNumber){
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
