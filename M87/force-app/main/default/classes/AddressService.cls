public interface AddressService{
    void saveAddress(Account account,AddressStructure address);
    Continuation searchAddresses(String postCode,String city,String street);
}