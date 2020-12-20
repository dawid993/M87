public interface LogEventTriggerHandler {
    void afterInsert(final List<Log__e> logs, final Map<Id,Log__e> logsById);
}
