public with sharing class AddressSearchController {
    private static final String doneParameterName = 'done';
    private static final String recordsParameterName = 'records';
    private static final String callbackMethodName = 'processResponse';
    
    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation searchByPostCode(final String postCode){
        AddressSearchService searchService = new AddressSearchServiceImp();
        searchService.setSearchByPostCode(postCode);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation setSearchByPostCodeOrStreet(final String postCode,final String street){
        AddressSearchService searchService = new AddressSearchServiceImp();
        searchService.setSearchByPostCodeOrStreet(postCode,street);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation setSearchByPostCodeAndCityAndStreet(
        final String postCode,
        final String city,
        final String street){
        AddressSearchService searchService = new AddressSearchServiceImp();
        searchService.setSearchByPostCodeAndCityAndStreet(postCode,city,street);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation setFullSearchParameters(
        final String postCode,
        final String city,
        final String street,
        final String houseNumber){

        AddressSearchService searchService = new AddressSearchServiceImp();
        searchService.setFullSearchParameters(postCode,city,street,houseNumber);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(cacheable = false)
    public static Object processResponse(List<String> labels,Object state) {      
        final HttpResponse response = Continuation.getResponse(labels[0]);     
        if(response.getStatusCode() == HttpUtils.HTTP_OK_CODE_STATUS){
            Map<String,Object> addressResults = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            Boolean isSucceeded = (Boolean) addressResults.get(doneParameterName);
            return isSucceeded ?  addressResults.get(recordsParameterName) : new List<Object>();
        }else{
            return new List<Object>();
        }    
    }    
    
    private static Continuation createAndReturnContinuation(AddressSearchService service){
        Continuation searchContinuation = service.createContinuationJob();
        searchContinuation.ContinuationMethod = callbackMethodName;
        return searchContinuation;
    }
}
