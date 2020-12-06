public with sharing class AddressSearchFacade {

    public Continuation createFullSearchParametersContinuation(String postCode,String city,String street,
        String houseNumber){  
            
        AddressSearchParametersStorageImp addressParamStorage = new AddressSearchParametersStorageImp().setPostCode(postCode)
        .setCity(city)
        .setStreet(street)
        .setHouseNumber(houseNumber);
        
        return new AddressSearchServiceImp(new AddressSearchByFullParametersSearch(addressParamStorage))
        .createContinuationJob();
    }  
    
    public Continuation createSearchByPostCodeAndCityAndStreetContinuation(String postCode,String city,String street){
        AddressSearchParametersStorageImp addressParamStorage = new AddressSearchParametersStorageImp().setPostCode(postCode)
        .setCity(city)
        .setStreet(street);

        return new AddressSearchServiceImp(new AddressSearchByPostCodeAndCityAndStreet(addressParamStorage))
            .createContinuationJob();
    }

    public Continuation createSearchByPostCodeOrStreetContinuation(String postCode,String cityOrStreet){
        AddressSearchParametersStorageImp addressParamStorage = new AddressSearchParametersStorageImp().setPostCode(postCode)
        .setCity(cityOrStreet)
        .setStreet(cityOrStreet);

        return new AddressSearchServiceImp(new AddressSearchByPostCodeAndCityAndStreet(addressParamStorage))
            .createContinuationJob();
    }

    public Continuation createSearchByPostCodeContinuation(String postCode){
        AddressSearchParametersStorageImp addressParamStorage = new AddressSearchParametersStorageImp().setPostCode(postCode);
        return new AddressSearchServiceImp(new AddressSearchByPostCode(addressParamStorage))
            .createContinuationJob();
    }
       
}
