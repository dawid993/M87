public interface EmailTemplateRepository {    
    EmailTemplate retrieveExceptionDuringLogSaveTemplate();
    EmailTemplate retrieveInvalidSaveAttemptTemplate();
}
