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
}
