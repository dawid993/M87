public interface AddressSearchParametersStorage {
    AddressSearchParametersStorage setPostCode(String postCode);
    AddressSearchParametersStorage setCity(String city);
    AddressSearchParametersStorage setStreet(String street);
    AddressSearchParametersStorage setHouseNumber(String houseNumber);
    String getPostCode();
    String getCity();
    String getStreet();
    String getHouseNumber();
}
