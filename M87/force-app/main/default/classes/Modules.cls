public with sharing virtual class Modules {
    private static Modules modulesHandle;

    private ServiceModules serviceModules;

    private SelectorModules selectorModules;

    public static Modules instance(){
        if(modulesHandle == null){
            SelectorModules selectorModules = new SelectorModules();
            modulesHandle = new Modules(new ServiceModules(selectorModules),selectorModules);
        }

        return modulesHandle;
    }   

    @testVisible
    private static void stubModule(Modules stub){
        modulesHandle = stub;
    }

    @testVisible
    private Modules(){}

    private Modules(ServiceModules serviceModules,SelectorModules selectorModules){
        this.selectorModules = selectorModules;
        this.serviceModules = serviceModules;        
    }
    
    public virtual UsernameOrEmailSearchService service_getUsernameOrEmailSearch(){
        return (UsernameOrEmailSearchService) serviceModules.createModule(UsernameOrEmailSearchService.class);
    }

    public virtual CaseServiceImp service_getCaseService(){
        return (CaseServiceImp) serviceModules.createModule(CaseServiceImp.class);
    }

    public virtual EngagementServiceImp service_getEngagementService(){
        return (EngagementServiceImp) serviceModules.createModule(EngagementServiceImp.class);
    }

    public virtual UserServiceImp service_getUserService(){
        return (UserServiceImp) serviceModules.createModule(UserServiceImp.class);
    }

    /*
    * Selectors start here.
    */

    public virtual UserSelectorImp selector_getUserSelector(){
        return (UserSelectorImp) selectorModules.createModule(UserSelectorImp.class);
    }

    public virtual CaseSelectorImp selector_getCaseSelector(){
        return (CaseSelectorImp) selectorModules.createModule(CaseSelectorImp.class);
    }
   
}
