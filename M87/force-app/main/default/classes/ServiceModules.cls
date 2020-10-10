public with sharing class ServiceModules extends Modular {
    
    private SelectorModules selectorModules;

    public ServiceModules(SelectorModules selectorModules){
        super();
        this.selectorModules = selectorModules;
        addModule(UsernameOrEmailSearchService.class, new UserOrEmailSearchModule(this.selectorModules));
    }

    private abstract class ConstructServiceModule implements ConstructModule {
        private SelectorModules selectorModule;

        public ConstructServiceModule(SelectorModules selectorModule){
            this.selectorModule = selectorModule;
        }

        protected SelectorModules getSelectorModules(){
            return selectorModule;
        }
    }

    private class UserOrEmailSearchModule extends ConstructServiceModule {
        private UserOrEmailSearchModule(SelectorModules selectorModule){
            super(selectorModule);
        }

        public Object construct(){
            UserSelectorImp userSelector = (UserSelectorImp) getSelectorModules().createModule(UserSelectorImp.class);
            return new UsernameOrEmailSearchService(userSelector);
        }
    }
}
