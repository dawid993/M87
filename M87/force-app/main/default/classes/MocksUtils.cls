@isTest
public class MocksUtils {
    public static Object mockServiceAndReturn(Type serviceToMock,fflib_ApexMocks mocks){
        Object mockedService =	mocks.mock(serviceToMock);
		Application.service.setMock(serviceToMock,mockedService);
		return mockedService;
    }

    public static Object mockSelectorAndReturn(Type selectorToMock,SObjectType sObjectForMock,fflib_ApexMocks mocks){
        fflib_ISObjectSelector mockedSelector = (fflib_ISObjectSelector) mocks.mock(selectorToMock);

        /*
        * Need to mock behaviour here beacause after stubing selector in sObjectType returns null.
        * This value(from sObjectType()) is used in setMock method to set proper mock type.
        */
        mocks.startStubbing();
        mocks.when(mockedSelector.sObjectType()).thenReturn(sObjectForMock);
        mocks.stopStubbing();

		Application.selector.setMock(mockedSelector);
		return mockedSelector;
    }

    public static Object mockUowAndReturn(Type uowType,fflib_ApexMocks mocks){
        fflib_ISObjectUnitOfWork uowMock = (fflib_ISObjectUnitOfWork) mocks.mock(uowType);
        Application.unitOfWork.setMock(uowMock);
        return uowMock;
    }

    public static fflib_ISObjectUnitOfWork mockUnitOfWork(fflib_ApexMocks mocks){
        fflib_ISObjectUnitOfWork uowMock = (fflib_SObjectUnitOfWork) mocks.mock(fflib_SObjectUnitOfWork.class);
        Application.UnitOfWork.setMock(uowMock);
        return uowMock;
    }
}
