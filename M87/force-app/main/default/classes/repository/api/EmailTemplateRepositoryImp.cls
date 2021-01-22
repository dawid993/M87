public with sharing class EmailTemplateRepositoryImp implements EmailTemplateRepository {
    private static final String EXCEPTION_DURING_LOG_SAVE_TEMP_DEV_NAME = 'ExceptionDuringLogSave';
    private static final String EXCEPTION_INVALID_LOG_SAVE_TEMP_DEV_NAME = 'InvalidLogSave';

    public EmailTemplate retrieveExceptionDuringLogSaveTemplate(){
        return [
            SELECT Id, Subject, Body 
            FROM EmailTemplate 
            WHERE DeveloperName = :EXCEPTION_DURING_LOG_SAVE_TEMP_DEV_NAME
            LIMIT 1
        ];
    }

    public EmailTemplate retrieveInvalidSaveAttemptTemplate(){
        return [
            SELECT Id, Subject, Body 
            FROM EmailTemplate 
            WHERE DeveloperName = :EXCEPTION_INVALID_LOG_SAVE_TEMP_DEV_NAME
            LIMIT 1
        ];
    }
}
