@isTest
public class AddressSearchControllerTest {
    public static final Integer DEFAULT_TEST_TIMEOUT = 10000;
    public static fflib_ApexMocks mocks;
    public static AddressSearchService searchAddressService;
    public static Continuation con;

    
    public static void resetTestSuite(){
        mocks = new fflib_ApexMocks();
        searchAddressService = (AddressSearchService) MocksUtils.mockServiceAndReturn(AddressSearchService.class,mocks);
        con = new Continuation(DEFAULT_TEST_TIMEOUT);

        mocks.startStubbing();
        mocks.when(searchAddressService.createContinuationJob()).thenReturn(con);
        mocks.stopStubbing();
    }

    @isTest
    public static void shouldCreateContinuationForPostCodeSearch() {
        resetTestSuite();      
        Continuation returnedContinuation = AddressSearchController.searchByPostCode('postCode');

        fflib_System.assertEquals(fflib_Match.refEq(con),returnedContinuation);
        ((AddressSearchService) mocks.verify(searchAddressService)).setSearchByPostCode(fflib_Match.anyString());
    }

    @isTest
    public static void shouldCreateContinuationForPostCodeOrStreetSearch() {
        resetTestSuite();
        Continuation returnedContinuation = AddressSearchController.searchByPostCodeOrStreet('postCode','street');

        fflib_System.assertEquals(fflib_Match.refEq(con),returnedContinuation);
        ((AddressSearchService) mocks.verify(searchAddressService)).setSearchByPostCodeOrStreet(
            fflib_Match.anyString(),
            fflib_Match.anyString()
        );
    }

    @isTest
    public static void shouldCreateContinuationForPostCodeAndStreetAndCitySearch() {
        resetTestSuite();
        Continuation returnedContinuation = 
            AddressSearchController.searchByPostCodeAndCityAndStreet('postCode', 'city', 'street');

        fflib_System.assertEquals(fflib_Match.refEq(con),returnedContinuation);
        ((AddressSearchService) mocks.verify(searchAddressService)).setSearchByPostCodeAndCityAndStreet(
            fflib_Match.anyString(),
            fflib_Match.anyString(),
            fflib_Match.anyString()
        );
    }

    @isTest
    public static void shouldCreateContinuationForFullSearch() {
        resetTestSuite();
        Continuation returnedContinuation = 
            AddressSearchController.fullSearchParameters('postCode', 'city', 'street', 'houseNumber');

        fflib_System.assertEquals(fflib_Match.refEq(con),returnedContinuation);
        ((AddressSearchService) mocks.verify(searchAddressService)).setFullSearchParameters(
            fflib_Match.anyString(),
            fflib_Match.anyString(),
            fflib_Match.anyString(),
            fflib_Match.anyString()
        );
    }
}
