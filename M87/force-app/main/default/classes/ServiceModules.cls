public with sharing class ServiceModules extends Modular {
    
    private SelectorModules selectorModules;

    public ServiceModules(SelectorModules selectorModules){
        super();
        this.selectorModules = selectorModules;
        addModule(UsernameOrEmailSearchService.class, UserOrEmailSearchModule.class);
        addModule(CaseServiceImp.class, CaseServiceModule.class);
        addModule(EngagementServiceImp.class, EngagementServiceModule.class);
        addModule(UserServiceImp.class, UserServiceModule.class);
        addModule(EngagementLeadService.class, ConstructServiceModule.class);
    }

    public override Object createModule(Type moduleType){
        ConstructServiceModule constructedModule = (ConstructServiceModule) super.getModuleConstruct(moduleType);
        constructedModule.setSelectorModule(selectorModules);
        constructedModule.setServiceModule(this);
        return ( (ConstructModule) constructedModule).construct();
    }

    private abstract class ConstructServiceModule implements ConstructModule {
        private SelectorModules selectorModule;
        private ServiceModules serviceModule;

        private void setSelectorModule(SelectorModules selectorModule){
            this.selectorModule = selectorModule;
        }

        private void setServiceModule(ServiceModules serviceModule){
            this.serviceModule = serviceModule;
        }

        protected SelectorModules getSelectorModules(){
            return selectorModule;
        }   
        
        protected ServiceModules getServiceModules(){
            return serviceModule;
        } 
    }

    /*
    * Create modules implementation.
    */

    private class UserOrEmailSearchModule extends ConstructServiceModule {
        public Object construct(){
            UserSelectorImp userSelector = (UserSelectorImp) getSelectorModules().createModule(UserSelectorImp.class);
            return new UsernameOrEmailSearchService(userSelector);
        }
    }

    private class CaseServiceModule extends ConstructServiceModule {
        public Object construct(){
            CaseSelectorImp caseSelector = (CaseSelectorImp) getSelectorModules().createModule(CaseSelectorImp.class);
            return new CaseServiceImp(caseSelector);
        }
    }

    private class EngagementServiceModule extends ConstructServiceModule {
        public Object construct(){
            EngagementCaseSelector caseSelector = 
                (EngagementCaseSelector) getSelectorModules().createModule(EngagementCaseSelector.class);            
            return new EngagementServiceImp(caseSelector);
        }
    }

    private class UserServiceModule extends ConstructServiceModule {
        public Object construct(){                    
            return new UserServiceImp();
        }
    }

    private class EngagementLeadServiceModule extends ConstructServiceModule {
        public Object construct(){                    
            return new EngagementLeadService();
        }
    }
}
