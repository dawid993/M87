@isTest
public with sharing class LogStorageThrowExceptionMock implements System.StubProvider {
    
    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName, 
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames, 
        List<Object> listOfArgs
    ) {
        throw new IllegalArgumentException('LogStorageThrowExceptionMock test exception');
    }
}
