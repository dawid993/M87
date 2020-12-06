public with sharing class ServiceModules extends Modular {
    
    private final SelectorModules selectorModules;

    private final RepositoryModules repositoryModules;

    public ServiceModules(SelectorModules selectorModules,RepositoryModules repositoryModules){
        super();
        this.selectorModules = selectorModules;
        this.repositoryModules = repositoryModules;

        addModule(UsernameOrEmailSearchService.class, UserOrEmailSearchModule.class);     
        addModule(EngagementCaseService.class, EngagementCaseServiceModule.class);
        addModule(UserService.class, UserServiceModule.class);
        addModule(EngagementLeadService.class, EngagementLeadServiceModule.class);
    }

    public override Object createModule(Type moduleType){
        ConstructServiceModule constructedModule = (ConstructServiceModule) super.getModuleConstruct(moduleType);
        constructedModule.setSelectorModule(selectorModules);
        constructedModule.setServiceModule(this);
        constructedModule.setRepositoryModule(repositoryModules);
        return ( (ConstructModule) constructedModule).construct();
    }

    private abstract class ConstructServiceModule implements ConstructModule {
        private SelectorModules selectorModule;
        private ServiceModules serviceModule;
        private RepositoryModules repositoryModules;

        private void setSelectorModule(SelectorModules selectorModule){
            this.selectorModule = selectorModule;
        }

        private void setServiceModule(ServiceModules serviceModule){
            this.serviceModule = serviceModule;
        }

        private void setRepositoryModule(RepositoryModules repositoryModules){
            this.repositoryModules = repositoryModules;
        }

        protected SelectorModules getSelectorModules(){
            return selectorModule;
        }   
        
        protected ServiceModules getServiceModules(){
            return serviceModule;
        } 

        protected RepositoryModules getRepositoryModules(){
            return repositoryModules;
        }
    }

    /*
    * Create modules implementation.
    */

    private class UserOrEmailSearchModule extends ConstructServiceModule {
        public Object construct(){            
            return new UsernameOrEmailSearchService(
                (UserSelectorImp) getSelectorModules().createModule(UserSelectorImp.class)
            );
        }
    }   

    private class EngagementCaseServiceModule extends ConstructServiceModule {
        public Object construct(){ 
            return new EngagementCaseService(
                (CaseRepository) getRepositoryModules().createModule(CaseRepository.class)
            );
        }
    }

    private class UserServiceModule extends ConstructServiceModule {
        public Object construct(){                    
            return new UserService(
                (UserRepository) getRepositoryModules().createModule(UserRepository.class)
            );
        }
    }

    private class EngagementLeadServiceModule extends ConstructServiceModule {
        public Object construct(){  
            return new EngagementLeadService(
                (LeadRepository) getRepositoryModules().createModule(LeadRepository.class),
                (CommunityUserRepository) getRepositoryModules().createModule(CommunityUserRepository.class)
            );
        }
    }
}
