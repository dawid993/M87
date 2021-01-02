public without sharing class LogStorageEntryResolver {
    private static final String SETUP_NAME = 'SETUP';
    private static final String BIG_OBJECT_STORAGE = 'BIG_OBJECT';
    private static final String CUSTOM_OBJECT_STORAGE = 'CUSTOM_OBJECT';

    public LogStorageEntry getLogStorageEntry(){
        if(Test.isRunningTest()){
            return new CustomObjectLogStorageEntry();
        }
        
        if(retrieveSetup().Storage__c == BIG_OBJECT_STORAGE){
            return new BigObjectLogStorageEntry();
        } 
            
        return new CustomObjectLogStorageEntry();
    }

    private LoggerConfiguration__mdt retrieveSetup(){
        return [SELECT Storage__c FROM LoggerConfiguration__mdt WHERE DeveloperName = :SETUP_NAME];
    }
}
