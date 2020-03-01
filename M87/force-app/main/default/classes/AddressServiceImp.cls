public with sharing class AddressServiceImp implements AddressService {  

    public void saveAddress(Account account,AddressStructure address){
        account.BillingStreet = address.street;
        account.BillingState = address.disctrict;
        account.BillingPostalCode = address.postCode;
        account.BillingCity = address.city;

        update account;
    }    
}
