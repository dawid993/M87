public with sharing class AddressSearchController {
    private static final String doneParameterName = 'done';
    private static final String recordsParameterName = 'records';
    private static final String callbackMethodName = 'processResponse';
    
    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation searchByPostCode(final String postCode){
        AddressSearchService searchService = getAddressSearchService();
        searchService.setSearchByPostCode(postCode);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation searchByPostCodeOrStreet(final String postCode,final String street){
        AddressSearchService searchService = getAddressSearchService();
        searchService.setSearchByPostCodeOrStreet(postCode,street);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation searchByPostCodeAndCityAndStreet(
        final String postCode,
        final String city,
        final String street){
        AddressSearchService searchService = getAddressSearchService();
        searchService.setSearchByPostCodeAndCityAndStreet(postCode,city,street);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(continuation = true cacheable = false)
    public static Continuation fullSearchParameters(
        final String postCode,
        final String city,
        final String street,
        final String houseNumber){

        AddressSearchService searchService = getAddressSearchService();
        searchService.setFullSearchParameters(postCode,city,street,houseNumber);
        return createAndReturnContinuation(searchService);
    }

    @AuraEnabled(cacheable = false)
    public static Object processResponse(List<String> labels,Object state) {      
        final HttpResponse response = Continuation.getResponse(labels[0]);     
        if(response.getStatusCode() == HttpUtils.HTTP_OK_CODE_STATUS){
            return getAddressSearchService().parseResponseAndReturnAddresses(response.getBody());            
        }else{
            return new List<Object>();
        }    
    }    
    
    private static Continuation createAndReturnContinuation(AddressSearchService service){
        Continuation searchContinuation = service.createContinuationJob();
        searchContinuation.ContinuationMethod = callbackMethodName;
        return searchContinuation;
    }

    private static AddressSearchService getAddressSearchService(){
        return (AddressSearchService) Application.Service.newInstance(AddressSearchService.class);
    } 
}
