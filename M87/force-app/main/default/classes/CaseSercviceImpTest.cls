@isTest
public class CaseSercviceImpTest {
    
    // @isTest
    // public static void shouldPerformCaseUpdate(){
    //     fflib_ApexMocks mocks = new fflib_ApexMocks();  
    //     fflib_ISObjectUnitOfWork uowMock = MocksUtils.mockUnitOfWork(mocks); 
    //     String status = 'To Do';
    //     CaseServiceImp caseSrvMock = new CaseServiceImp();        
    //     ID caseId = fflib_IDGenerator.generate(Case.sObjectType);

    //     caseSrvMock.changeCaseStatus(caseId, status);
        
    //     ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1)).commitWork();
    //     ((fflib_ISObjectUnitOfWork) mocks.verify(uowMock, 1)).registerDirty(
    //         fflib_Match.sObjectWith(
    //             new Map<Schema.SObjectField, Object> {
    //                 Case.ID.getDescribe().getSOBjectField() => caseId,
    //                 Case.Status.getDescribe().getSOBjectField() => status
    //             }
    //     ));

    // }

    // @isTest
    // public static void shouldRetrieveEngagementCases(){
    //     fflib_ApexMocks mocks = new fflib_ApexMocks();
    //     CaseSelector selector = (CaseSelector) MocksUtils.mockSelectorAndReturn(CaseSelector.class,Case.sObjectType,mocks);
    //     ID ownerId = fflib_IDGenerator.generate(User.sObjectType);

    //     List<Case> engagementCases = new List<Case> {
    //         new Case(ID = fflib_IDGenerator.generate(Case.sObjectType))
    //     };

    //     CaseServiceImp caseSrvMock = new CaseServiceImp(); 

    //     mocks.startStubbing(); 
    //     mocks.when(selector.retrieveEngagementCases(ownerId)).thenReturn(engagementCases);
    //     mocks.stopStubbing();

    //     List<Case> retrievedCases = caseSrvMock.retrieveEngagementCases(ownerId);
    //     System.assertEquals(1,retrievedCases.size());
    //     ((CaseSelector) mocks.verify(selector,1)).retrieveEngagementCases(ownerId);
    // }
}
