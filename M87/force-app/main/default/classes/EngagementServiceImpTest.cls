@isTest
public class EngagementServiceImpTest {
    
    @isTest
    public static void shouldRetrieveEngagementCase(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CaseService mockedCaseService = (CaseService) MocksUtils.mockServiceAndReturn(CaseService.class, mocks);
        ID ownerId = fflib_IDGenerator.generate(User.sObjectType);

        EngagementServiceImp engagementService = new EngagementServiceImp();
        mocks.startStubbing();
        mocks.when(mockedCaseService.retrieveEngagementCases(fflib_Match.eqId(ownerId))).thenReturn(new List<Case>());
        mocks.stopStubbing();

        final Integer retrieveCalloutsNumber = 10;

        for(Integer i = 0 ; i <retrieveCalloutsNumber; i++){
            engagementService.retrieveEngagementCases(ownerId);
        }

        ((CaseService) mocks.verify(
            mockedCaseService,
            new fflib_VerificationMode().atLeast(1)
        )).retrieveEngagementCases(fflib_Match.eqId(ownerId));

        ((CaseService) mocks.verify(
            mockedCaseService,
            10
        )).retrieveEngagementCases(fflib_Match.eqId(ownerId));

    }

    @isTest
    public static void shouldThrowExceptionBecauseCaseServiceThrownException(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CaseService mockedCaseService = (CaseService) MocksUtils.mockServiceAndReturn(CaseService.class, mocks);
        ID ownerId = fflib_IDGenerator.generate(User.sObjectType);

        EngagementServiceImp engagementService = new EngagementServiceImp();
        mocks.startStubbing();
        mocks.when(mockedCaseService.retrieveEngagementCases(fflib_Match.eqId(ownerId))).thenThrow(
            new Exceptions.UnableToReadDataException('Exception message.')
        );
        mocks.stopStubbing();

        Exception thrownException;

        try{
            engagementService.retrieveEngagementCases(ownerId);
        }catch(Exceptions.UnableToReadDataException ex){
            thrownException = ex;
        }

        System.assertNotEquals(null, thrownException);        

    }

    @isTest
    public static void shouldThrowExceptionBecauseOwnerIdIsBlank(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();        
        ID ownerId = null;

        EngagementServiceImp engagementService = new EngagementServiceImp();     
        Exception thrownException;

        try{
            engagementService.retrieveEngagementCases(ownerId);
        }catch(Exceptions.UndefinedOwnerException ex){
            thrownException = ex;
        }

        System.assertNotEquals(null, thrownException);        
    }

    @isTest
    public static void shouldThrowExceptionBecauseSearchOptionsAreInvalid(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();        
        SearchEngagementCaseOptions searchOptions = null;

        EngagementServiceImp engagementService = new EngagementServiceImp();     
        Exception thrownException;

        try{
            engagementService.retrieveEngagementCases(searchOptions);
        }catch(Exceptions.InvalidServiceActionParametersException ex){
            thrownException = ex;
        }

        System.assertNotEquals(null, thrownException);       
    }

    @isTest
    public static void shouldThrowExceptionBecauseCaseServiceThrowException_searchByOptions(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CaseService mockedCaseService = (CaseService) MocksUtils.mockServiceAndReturn(CaseService.class, mocks);
        SearchEngagementCaseOptions searchOptions = new SearchEngagementCaseOptions();

        EngagementServiceImp engagementService = new EngagementServiceImp();
        mocks.startStubbing();
        mocks.when(mockedCaseService.retrieveEngagementCases(searchOptions)).thenThrow(
            new Exceptions.UnableToReadDataException('Exception message.')
        );
        mocks.stopStubbing();

        Exception thrownException;

        try{
            engagementService.retrieveEngagementCases(searchOptions);
        }catch(Exceptions.UnableToReadDataException ex){
            thrownException = ex;
        }

        System.assertNotEquals(null, thrownException);          
    }

    @isTest
    public static void shouldRetrieveEngagementCase_searchByOption(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CaseService mockedCaseService = (CaseService) MocksUtils.mockServiceAndReturn(CaseService.class, mocks);
        SearchEngagementCaseOptions searchOptions = new SearchEngagementCaseOptions();

        ID firstCaseId = fflib_IDGenerator.generate(Case.getSObjectType());
        ID secondCaseId = fflib_IDGenerator.generate(Case.getSObjectType());

        List<Case> returnCases = new List<Case>{
            new Case(ID = firstCaseId),
            new Case(ID = secondCaseId)
        };

        EngagementServiceImp engagementService = new EngagementServiceImp();
        mocks.startStubbing();
        mocks.when(mockedCaseService.retrieveEngagementCases(searchOptions)).thenReturn(returnCases);

        mocks.stopStubbing();

        fflib_System.assertEquals(
            fflib_Match.sObjectsWith(
                new List<Map<Schema.SObjectField, Object>>{

                    new Map<Schema.SObjectField, Object>{
                        Case.ID.getDescribe().getSOBjectField() => firstCaseId
                    },

                    new Map<Schema.SObjectField, Object>{
                        Case.ID.getDescribe().getSOBjectField() => secondCaseId
                    }
                }
            ),
            engagementService.retrieveEngagementCases(searchOptions)
        );

        ((CaseService) mocks.verify(mockedCaseService)).retrieveEngagementCases(searchOptions);               
    }

    @isTest
    public static void shouldUpdateCaseStatus(){
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CaseService mockedCaseService = (CaseService) MocksUtils.mockServiceAndReturn(CaseService.class, mocks);

        ID caseID = fflib_IDGenerator.generate(Case.getSObjectType());
        String status = 'To Do';

        EngagementServiceImp engagementService = new EngagementServiceImp();
        engagementService.updateEngagementCaseStatus(caseId, status);

        ((CaseService) mocks.verify(mockedCaseService)).changeCaseStatus(fflib_Match.eqId(caseID),fflib_Match.eqString(status));

    }

    @isTest
    public static void shouldThrowExceptionBecauseIncorrectParameters(){      
        EngagementServiceImp engagementService = new EngagementServiceImp();

        Boolean exceptionThrown = false;
        Exception thrownException;
        try{
            engagementService.updateEngagementCaseStatus(null, null);
        }catch(Exceptions.InvalidServiceActionParametersException ex){
            thrownException = ex;
        }

        System.assertNotEquals(null, thrownException);
        
    }

    @isTest
    public static void shouldThrowExceptionBecauseInvalidStatus(){      
        EngagementServiceImp engagementService = new EngagementServiceImp();
        
        ID caseID = fflib_IDGenerator.generate(Case.getSObjectType());
        String status = 'Invalid status';

        Boolean exceptionThrown = false;
        Exception thrownException;
        
        try{
            engagementService.updateEngagementCaseStatus(caseID, status);
        }catch(Exceptions.InvalidServiceActionParametersException ex){
            thrownException = ex;
        }

        System.assertNotEquals(null, thrownException);        
    }

    @isTest
    public static void shouldThrowExceptionBecauseCaseServiceThrownExceptionWhenUpdateCase(){      
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CaseService mockedCaseService = (CaseService) MocksUtils.mockServiceAndReturn(CaseService.class, mocks);

        ID caseID = fflib_IDGenerator.generate(Case.getSObjectType());
        String status = 'To Do';

        mocks.startStubbing();
        ((CaseService) mocks.doThrowWhen(new Exceptions.UnableToSaveDataException('Test exception'),mockedCaseService))
            .changeCaseStatus(caseID,status);     
        mocks.stopStubbing();

        EngagementServiceImp engagementService = new EngagementServiceImp();        

        Boolean exceptionThrown = false;
        Exception thrownException;
        
        try{
            engagementService.updateEngagementCaseStatus(caseID, status);
        }catch(Exceptions.UnableToSaveDataException ex){
            thrownException = ex;
        }

        System.assertNotEquals(null, thrownException);        
    }

}
