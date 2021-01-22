@isTest
public with sharing class LogStorageSaveResultMock implements System.StubProvider {   
    private final Boolean isSuccess;
    
    public LogStorageSaveResultMock(final Boolean isSuccess){
        this.isSuccess = isSuccess;
    }

    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName, 
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames, 
        List<Object> listOfArgs
    ) {
        if(isSuccess){
            return new List<Database.SaveResult> {
                (Database.SaveResult) JSON.deserialize(
                    '{"success":true}', Database.SaveResult.class)
            };
        } else {
            return new List<Database.SaveResult> {
                (Database.SaveResult) JSON.deserialize(
                    '{"success":false}', Database.SaveResult.class)
            };
        }
    }
}
