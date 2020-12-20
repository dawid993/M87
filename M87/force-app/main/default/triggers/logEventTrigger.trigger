trigger logEventTrigger on Log__e (after insert) {
    LogEventTriggerHandler handler = LogEventTriggerHandlerFactory.newHandler();    
    handler.afterInsert(Trigger.New, Trigger.newMap);
}