@isTest
public with sharing class UsernameOrEmailSearchServiceStub implements System.StubProvider {
    public Object handleMethodCall(
            Object stubbedObject,
            String stubbedMethodName, 
            Type returnType, 
            List<Type> listOfParamTypes, 
            List<String> listOfParamNames, 
            List<Object> listOfArgs) {
            
        throw new IllegalArgumentException('Test exception');
        
    }

    public static UsernameOrEmailSearchService createStub(){
        return (UsernameOrEmailSearchService) Test.createStub(UsernameOrEmailSearchService.class, new UsernameOrEmailSearchServiceStub());
    }
}
