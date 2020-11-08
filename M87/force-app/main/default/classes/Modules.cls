public with sharing virtual class Modules {
    private static Modules modulesHandle;

    private ServiceModules serviceModules;

    private SelectorModules selectorModules;

    private RepositoryModules repositoryModules;

    public static Modules instance(){
        if(modulesHandle == null){
            SelectorModules selectorModules = new SelectorModules();
            RepositoryModules repositoryModules = new RepositoryModules();
            modulesHandle = new Modules(
                new ServiceModules(selectorModules,repositoryModules),
                selectorModules,
                repositoryModules
            );
        }

        return modulesHandle;
    }   

    @testVisible
    private static void stubModule(Modules stub){
        modulesHandle = stub;
    }

    @testVisible
    private Modules(){}

    private Modules(ServiceModules serviceModules,SelectorModules selectorModules,RepositoryModules repositoryModules){
        this.selectorModules = selectorModules;
        this.serviceModules = serviceModules;   
        this.repositoryModules = repositoryModules;     
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

    public virtual EngagementLeadService service_getEngagementLeadService(){
        return (EngagementLeadService) serviceModules.createModule(EngagementLeadService.class);
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
