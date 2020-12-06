public with sharing virtual class Modules {
    private static Modules modulesHandle;

    private ServiceModules serviceModules;

    private SelectorModules selectorModules;

    private RepositoryModules repositoryModules;

    private FacadeModules facadeModules;

    public static Modules instance(){
        if(modulesHandle == null){
            final SelectorModules selectorModules = new SelectorModules();
            final RepositoryModules repositoryModules = new RepositoryModules();
            final ServiceModules serviceModules = new ServiceModules(selectorModules,repositoryModules);
            final FacadeModules facadeModules = new FacadeModules(serviceModules);
            
            modulesHandle = new Modules(
                new ServiceModules(selectorModules,repositoryModules),
                selectorModules,
                repositoryModules,
                facadeModules
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

    private Modules(
        ServiceModules serviceModules,
        SelectorModules selectorModules,
        RepositoryModules repositoryModules,
        FacadeModules facadeModules
    ){
        this.selectorModules = selectorModules;
        this.serviceModules = serviceModules;   
        this.repositoryModules = repositoryModules;  
        this.facadeModules = facadeModules;   
    }
    
    public virtual UsernameOrEmailSearchService service_getUsernameOrEmailSearch(){
        return (UsernameOrEmailSearchService) serviceModules.createModule(UsernameOrEmailSearchService.class);
    }   

    public virtual EngagementCaseService service_getEngagementCaseService(){
        return (EngagementCaseService) serviceModules.createModule(EngagementCaseService.class);
    }

    public virtual UserService service_getUserService(){
        return (UserService) serviceModules.createModule(UserService.class);
    }

    public virtual EngagementLeadService service_getEngagementLeadService(){
        return (EngagementLeadService) serviceModules.createModule(EngagementLeadService.class);
    } 
    
    public virtual EngagementFacade facade_getEngagementFacade(){
        return (EngagementFacade) facadeModules.createModule(EngagementFacade.class);
    } 

    public virtual EngagementFacade facade_getAddressSearchFacade(){
        return (EngagementFacade) facadeModules.createModule(AddressSearchFacade.class);
    }
}
