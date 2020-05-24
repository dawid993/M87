public with sharing class AddressSearchServiceImp implements AddressSearchService{  
    private AddressSearchStrategy searchStrategy;
    private AddressSearchParametersStorage addressParamStorage;    
    
    public void setFullSearchParameters(String postCode,String city,String street,String houseNumber){  
        addressParamStorage = newAddressParamStorage();
        addressParamStorage.setPostCode(postCode).setCity(city).setStreet(street).setHouseNumber(houseNumber);
        searchStrategy = newAddressStrategyFactory().getAddressSearchStrategy(AddressSearchStrategyType.FULL_SEARCH);
    }  
    
    public void setSearchByPostCodeAndCityAndStreet(String postCode,String city,String street){
        addressParamStorage = newAddressParamStorage();
        addressParamStorage.setPostCode(postCode).setCity(city).setStreet(street);
        searchStrategy = newAddressStrategyFactory()
            .getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE_AND_CITY_AND_STREET);
    }

    public void setSearchByPostCodeOrStreet(String postCode,String cityOrStreet){
        addressParamStorage = newAddressParamStorage();
        addressParamStorage.setPostCode(postCode).setCity(cityOrStreet).setStreet(cityOrStreet);
        searchStrategy = newAddressStrategyFactory()
            .getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE_OR_STREET);
    }

    public void setSearchByPostCode(String postCode){
        addressParamStorage = newAddressParamStorage();
        addressParamStorage.setPostCode(postCode);
        searchStrategy = newAddressStrategyFactory().getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE);
    }

    public Continuation createContinuationJob(){
        AddressSearchContinuationCreator continuationCreator = 
            (AddressSearchContinuationCreator) Application.Service.newInstance(AddressSearchContinuationCreator.class);
        return continuationCreator.createContinuation(addressParamStorage, searchStrategy);
    }

    private AddressSearchParametersStorage newAddressParamStorage(){
        return (AddressSearchParametersStorage) Application.Service.newInstance(AddressSearchParametersStorage.class);
    }

    private AddressSearchStrategyFactory newAddressStrategyFactory(){
        return (AddressSearchStrategyFactory) Application.Service.newInstance(AddressSearchStrategyFactory.class);
    }
    
    public List<AddressStructure> parseResponseAndReturnAddresses(String jsonResponse){
        try{
            return String.isBlank(jsonResponse)
                ? new List<AddressStructure>()
                : parseResponse(jsonResponse);  
        }catch(Exception ex){
            System.debug(ex.getMessage()+' '+ex.getStackTraceString());
            return new List<AddressStructure>();
        }       
    }

    private List<AddressStructure> parseResponse(String jsonResponse){
        AddressParser parser = (AddressParser) Application.Service.newInstance(AddressParser.class);
        return parser.parseAddresses(jsonResponse);
    }
}
