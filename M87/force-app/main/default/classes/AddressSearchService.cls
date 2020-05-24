public interface AddressSearchService extends Continuable{
    void setFullSearchParameters(String postCode,String city,String street,String houseNumber);
    void setSearchByPostCodeAndCityAndStreet(String postCode,String city,String street);
    void setSearchByPostCodeOrStreet(String postCode,String CityOrStreet);
    void setSearchByPostCode(String postCode); 
    Continuation createContinuationJob();
    List<AddressStructure> parseResponseAndReturnAddresses(String jsonResponse);
}