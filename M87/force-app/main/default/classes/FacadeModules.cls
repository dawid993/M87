public with sharing class FacadeModules extends Modular {

    private final ServiceModules serviceModules;

    public FacadeModules(final ServiceModules serviceModules) {
        super();
        this.serviceModules = serviceModules;

        addModule(EngagementFacade.class, EngagementFacadeModule.class);
        addModule(AddressSearchFacade.class, AddressSearchFacadeModule.class);
    }

    public override Object createModule(Type moduleType){
        ConstructFacadeModule constructedModule = (ConstructFacadeModule) super.getModuleConstruct(moduleType);
        constructedModule.setFacadeModules(this);    
        constructedModule.setServiceModules(serviceModules);     
        return ( (ConstructModule) constructedModule).construct();
    }

    private abstract class ConstructFacadeModule implements ConstructModule {
        private ServiceModules servicesModules;
        private FacadeModules facadeModules;

        private void setServiceModules(ServiceModules servicesModules){            
            this.servicesModules = servicesModules;            
        }

        private void setFacadeModules(FacadeModules facadeModules){
            this.facadeModules = facadeModules;
        }

        protected ServiceModules getServiceModules(){ 
            return servicesModules;
        }

        protected FacadeModules getFacadeModules(FacadeModules facadeModules){
            return facadeModules;
        }
    }    

    private class EngagementFacadeModule extends ConstructFacadeModule {
        public Object construct(){           
            return new EngagementFacade(
                (EngagementCaseService) getServiceModules().createModule(EngagementCaseService.class),
                (EngagementLeadService) getServiceModules().createModule(EngagementLeadService.class)
            );
        }
    }

    private class AddressSearchFacadeModule extends ConstructFacadeModule {
        public Object construct(){           
            return new AddressSearchFacade();
        }
    }
}
