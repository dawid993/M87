public with sharing class LogProblemAdministratorNotifier {
    
    private static final String EXCEPTION_DETAILS_PLACEHOLDER = '[EXCEPTION_DETAILS]';
    private static final String AFFECTED_LOGS_PLACEHOLDER = '[AFFECTED_LOGS]';
    private static final String ERRORS_PLACEHOLDER = '[Errors]';
    
    private final EmailTemplate exceptionThrownTemplate;
    private final EmailTemplate invalidSaveAttemptTemplate;
    private final List<String> notifyUserEmails;

    public LogProblemAdministratorNotifier(       
        final GroupUserService groupUserService,
        final EmailTemplateRepository templateRepository
    ){                
        exceptionThrownTemplate = templateRepository.retrieveExceptionDuringLogSaveTemplate();
        invalidSaveAttemptTemplate = templateRepository.retrieveInvalidSaveAttemptTemplate();
        notifyUserEmails = extractUserEmails(groupUserService.retrieveUsersFromErrorNotifyGroup());
    }

    private List<String> extractUserEmails(List<User> users){
        List<String> emails = new List<String>();
        for(User usr : users){
            emails.add(usr.Email);
        }

        return emails;
    }

    public void notifyAdministrators(final Exception ex){
        if(!notifyUserEmails.isEmpty()){            
            final Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject(exceptionThrownTemplate.Subject);
            message.setHtmlBody(exceptionThrownTemplate.Body.replace(EXCEPTION_DETAILS_PLACEHOLDER,
                buildExceptionDetails(ex)));
            message.setToAddresses(notifyUserEmails);

            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});
        }        
    }

    private String buildExceptionDetails(final Exception ex){
        return ex.getCause() + ' '+ ex.getMessage() + ' '+ ex.getStackTraceString();
    }

    public void notifyAdministrators(final List<Log__e> logs, final List<Database.SaveResult> failedSaveResults){
        if(!notifyUserEmails.isEmpty()){
            final LogErrorDetailsGenerator generator = new LogErrorDetailsGenerator();
            final Map<Id,Log__e> logsGroupedById = groupById(logs);
            final Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject(invalidSaveAttemptTemplate.Subject);
            message.setHtmlBody(invalidSaveAttemptTemplate.Body.replace(AFFECTED_LOGS_PLACEHOLDER,
                generator.generateAffectedLogText(logsGroupedById)));
            message.setHtmlBody(invalidSaveAttemptTemplate.Body.replace(ERRORS_PLACEHOLDER,
                generator.generateErrorList(failedSaveResults)));
            message.setToAddresses(notifyUserEmails);

            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {message});
        }
        
    }

    private Map<Id, Log__e> groupById(final List<Log__e> logs){
        final Map<Id,Log__e> groupedById = new Map<Id,Log__e>();
        for(Log__e log : logs){
            groupedById.put(log.Id,log);
        }

        return groupedById;
    }
}
