@isTest
public class AddressSearchServiceImpTest {
    private static final Integer DEFAULT_TIMEOUT = 60;

    private static fflib_ApexMocks mocks;
    private static AddressSearchStrategyFactory searchFactoryMock;            
    private static AddressSearchStrategy addressSearchStrategyMock;
    private static AddressSearchParametersStorage paramsStorageMock;
    private static AddressSearchContinuationCreator continuationCreatorMock;
    private static AddressParser addressParser;
    private static Continuation testContinuation;      
    
    public static void resetTestSuite(){
        mocks = new fflib_ApexMocks();
        searchFactoryMock = mockAddressSearchStrategyFactory(mocks);            
        addressSearchStrategyMock = mockAddressSearchStrategy(mocks);
        paramsStorageMock = mockParameterStorage(mocks);
        continuationCreatorMock = mockContinuationCreator(mocks);
        addressParser = mockAddressParser(mocks);
        testContinuation = new Continuation(DEFAULT_TIMEOUT);

        mocks.startStubbing();
        mocks.when(paramsStorageMock.setPostCode(fflib_Match.anyString())).thenReturn(paramsStorageMock);
        mocks.when(paramsStorageMock.setStreet(fflib_Match.anyString())).thenReturn(paramsStorageMock);
        mocks.when(paramsStorageMock.setCity(fflib_Match.anyString())).thenReturn(paramsStorageMock);
        mocks.when(paramsStorageMock.setHouseNumber(fflib_Match.anyString())).thenReturn(paramsStorageMock);
        mocks.stopStubbing();
    }

    @isTest
    public static void shouldCreateContinuationForPostCodeSearch(){
        resetTestSuite();  
        
        mocks.startStubbing();
        mocks.when(searchFactoryMock.getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE))
            .thenReturn(addressSearchStrategyMock);
        mocks.when(continuationCreatorMock.createContinuation(paramsStorageMock, addressSearchStrategyMock))
            .thenReturn(testContinuation);
        mocks.stopStubbing();

        final String postCode = 'testPostCode';
        AddressSearchServiceImp addressService = new AddressSearchServiceImp();
        addressService.setSearchByPostCode(postCode);

        ((AddressSearchStrategyFactory) mocks.verify(searchFactoryMock))
            .getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setPostCode(postCode);

        Continuation returnedContinuation = addressService.createContinuationJob();
        fflib_System.assertEquals(fflib_Match.refEq(testContinuation),returnedContinuation);
        
        ((AddressSearchContinuationCreator) mocks.verify(continuationCreatorMock))
            .createContinuation(paramsStorageMock,addressSearchStrategyMock);        
    }

    @isTest
    public static void shouldCreateContinuationForPostCodeOrCityOrStreetSearch(){
        resetTestSuite();               
        
        mocks.startStubbing();
        mocks.when(searchFactoryMock.getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE_OR_STREET))
            .thenReturn(addressSearchStrategyMock);
        mocks.when(continuationCreatorMock.createContinuation(paramsStorageMock, addressSearchStrategyMock))
            .thenReturn(testContinuation);        
        mocks.stopStubbing();

        final String postCode = 'testPostCode';
        final String cityOrStreet = 'testCityOrStreet';        

        AddressSearchServiceImp addressService = new AddressSearchServiceImp();
        addressService.setSearchByPostCodeOrStreet(postCode, cityOrStreet);

        ((AddressSearchStrategyFactory) mocks.verify(searchFactoryMock))
            .getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE_OR_STREET);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setPostCode(postCode);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setCity(cityOrStreet);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setStreet(cityOrStreet);

        Continuation returnedContinuation = addressService.createContinuationJob();
        fflib_System.assertEquals(fflib_Match.refEq(testContinuation),returnedContinuation);
        
        ((AddressSearchContinuationCreator) mocks.verify(continuationCreatorMock))
            .createContinuation(paramsStorageMock,addressSearchStrategyMock);        
    }

    @isTest
    public static void shouldCreateContinuationForPostCodeAndCityAndStreetSearch(){
        resetTestSuite();               
        
        mocks.startStubbing();
        mocks.when(searchFactoryMock.getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE_AND_CITY_AND_STREET))
            .thenReturn(addressSearchStrategyMock);
        mocks.when(continuationCreatorMock.createContinuation(paramsStorageMock, addressSearchStrategyMock))
            .thenReturn(testContinuation);        
        mocks.stopStubbing();

        final String postCode = 'testPostCode';
        final String city = 'testCity';
        final String street = 'testStreet';        

        AddressSearchServiceImp addressService = new AddressSearchServiceImp();
        addressService.setSearchByPostCodeAndCityAndStreet(postCode, city, street);

        ((AddressSearchStrategyFactory) mocks.verify(searchFactoryMock))
            .getAddressSearchStrategy(AddressSearchStrategyType.POST_CODE_AND_CITY_AND_STREET);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setPostCode(postCode);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setCity(city);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setStreet(street);

        Continuation returnedContinuation = addressService.createContinuationJob();
        fflib_System.assertEquals(fflib_Match.refEq(testContinuation),returnedContinuation);
        
        ((AddressSearchContinuationCreator) mocks.verify(continuationCreatorMock))
            .createContinuation(paramsStorageMock,addressSearchStrategyMock);        
    }

    @isTest
    public static void shouldCreateContinuationForFullSearch(){
        resetTestSuite();               
        
        mocks.startStubbing();
        mocks.when(searchFactoryMock.getAddressSearchStrategy(AddressSearchStrategyType.FULL_SEARCH))
            .thenReturn(addressSearchStrategyMock);
        mocks.when(continuationCreatorMock.createContinuation(paramsStorageMock, addressSearchStrategyMock))
            .thenReturn(testContinuation);        
        mocks.stopStubbing();

        final String postCode = 'testPostCode';
        final String city = 'testCity';
        final String street = 'testStreet';
        final String houseNumber = 'houseNumber';        

        AddressSearchServiceImp addressService = new AddressSearchServiceImp();
        addressService.setFullSearchParameters(postCode, city, street, houseNumber);

        ((AddressSearchStrategyFactory) mocks.verify(searchFactoryMock))
            .getAddressSearchStrategy(AddressSearchStrategyType.FULL_SEARCH);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setPostCode(postCode);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setCity(city);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setStreet(street);
        ((AddressSearchParametersStorage) mocks.verify(paramsStorageMock)).setHouseNumber(houseNumber);

        Continuation returnedContinuation = addressService.createContinuationJob();
        fflib_System.assertEquals(fflib_Match.refEq(testContinuation),returnedContinuation);
        
        ((AddressSearchContinuationCreator) mocks.verify(continuationCreatorMock))
            .createContinuation(paramsStorageMock,addressSearchStrategyMock);        
    }

    @isTest
    public static void shouldParseResponseAndReturnAddresses(){
        resetTestSuite();

        List<AddressStructure> addressStructures = new List<AddressStructure>{
            new AddressStructure('1',null,null,null,null,null)
        };

        mocks.startStubbing();
        mocks.when(addressParser.parseAddresses(fflib_Match.anyString())).thenReturn(addressStructures);
        mocks.stopStubbing();

        AddressSearchServiceImp addressService = new AddressSearchServiceImp();
        List<AddressStructure> returnedStructures = addressService.parseResponseAndReturnAddresses('Example response');
        fflib_System.assertEquals(fflib_Match.refEq(addressStructures),returnedStructures);

        ((AddressParser) mocks.verify(addressParser)).parseAddresses(fflib_Match.anyString()); 
    }

    @isTest
    public static void shouldParseBlankResponseAndReturnEmptyList(){
        resetTestSuite();

        AddressSearchServiceImp addressService = new AddressSearchServiceImp();
        List<AddressStructure> returnedStructures = addressService.parseResponseAndReturnAddresses('');
        System.assertEquals(0, returnedStructures.size());       
    }

    @isTest
    public static void shouldParseInvalidResponseAndReturnEmptyListBecauseOfException(){
        resetTestSuite();       

        List<AddressStructure> addressStructures = new List<AddressStructure>{
            new AddressStructure('1',null,null,null,null,null)
        };

        mocks.startStubbing();
        mocks.when(addressParser.parseAddresses(fflib_Match.anyString())).thenReturn(new IllegalArgumentException());
        mocks.stopStubbing();

        AddressSearchServiceImp addressService = new AddressSearchServiceImp();
        List<AddressStructure> returnedStructures = addressService.parseResponseAndReturnAddresses('Invalid response');
        System.assertEquals(0, returnedStructures.size());       
        ((AddressParser) mocks.verify(addressParser)).parseAddresses(fflib_Match.anyString()); 
    }

    private static AddressSearchStrategyFactory mockAddressSearchStrategyFactory(fflib_ApexMocks mocks){
        return (AddressSearchStrategyFactory) MocksUtils.mockServiceAndReturn(AddressSearchStrategyFactory.class, mocks);
    }

    private static AddressSearchStrategy mockAddressSearchStrategy(fflib_ApexMocks mocks){
        return (AddressSearchStrategy) MocksUtils.mockServiceAndReturn(AddressSearchStrategy.class, mocks);
    }

    private static AddressSearchParametersStorage mockParameterStorage(fflib_ApexMocks mocks){
        return (AddressSearchParametersStorage)
            MocksUtils.mockServiceAndReturn(AddressSearchParametersStorage.class, mocks);
    }

    private static AddressSearchContinuationCreator mockContinuationCreator(fflib_ApexMocks mocks){
        return (AddressSearchContinuationCreator)
            MocksUtils.mockServiceAndReturn(AddressSearchContinuationCreator.class, mocks);    
    }

    private static AddressParser mockAddressParser(fflib_ApexMocks mocks){
        return (AddressParser) MocksUtils.mockServiceAndReturn(AddressParser.class, mocks);
    }
    
}
