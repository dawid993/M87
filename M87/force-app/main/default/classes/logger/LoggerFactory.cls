public with sharing class LoggerFactory {
    private static final Boolean ALL_OR_NONE = true;

    public static Logger getLogger(){
        return new LoggerImp(getEventBusService(ALL_OR_NONE));
    }

    public static Logger getLogger(Type classType){
        return new LoggerImp(classType, getEventBusService(ALL_OR_NONE));
    }

    public static Logger getLogger(Boolean allOrNone){
        return new LoggerImp(getEventBusService(allOrNone));
    }

    public static Logger getLogger(Type classType, Boolean allOrNone){
        return new LoggerImp(classType, getEventBusService(allOrNone));
    }

    private static LogEventBusService getEventBusService(Boolean allOrNone){
        return new LogEventBusService(
            new LogValidator(),
            allOrNone ? LogPublishMode.AVOID_PUBLISH_WHEN_ANY_INVALID : LogPublishMode.PARTIAL_PUBLISH
        );
    }
}
