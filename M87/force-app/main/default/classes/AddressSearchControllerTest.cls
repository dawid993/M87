@isTest
public class AddressSearchControllerTest {
    public static final Integer DEFAULT_TEST_TIMEOUT = 10000;

    @isTest
    public static void shouldCreateContinuationForPostCodeSearch() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        AddressSearchService searchAddressService = 
            (AddressSearchService) MocksUtils.mockServiceAndReturn(AddressSearchService.class,mocks);

        String postCode = 'testPostCode';
        Continuation con = new Continuation(DEFAULT_TEST_TIMEOUT);

        mocks.startStubbing();
        mocks.when(searchAddressService.createContinuationJob()).thenReturn(con);
        mocks.stopStubbing();
        
        Continuation returnedContinuation = AddressSearchController.searchByPostCode(postCode);

        fflib_System.assertEquals(fflib_Match.refEq(con),returnedContinuation);
        ((AddressSearchService) mocks.verify(searchAddressService)).setSearchByPostCode(fflib_Match.anyString());
    }
}
