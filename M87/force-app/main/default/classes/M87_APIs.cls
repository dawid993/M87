public with sharing class M87_APIs {
    
    public static EngagementFacade getEngagementAPI(){
        return Modules.instance().facade_getEngagementFacade();
    }

    public static UserService getUserService(){
        return Modules.instance().service_getUserService();
    }
}
