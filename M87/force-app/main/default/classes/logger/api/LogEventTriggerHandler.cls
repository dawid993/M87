public interface LogEventTriggerHandler {
    void afterInsert(final List<Log__e> logs);
}