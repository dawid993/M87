public with sharing class RepositoryModules extends Modular {
    public RepositoryModules(){
        super();
        addModule(LeadRepository.class, LeadRepositoryModule.class);
        addModule(CommunityUserRepository.class, CommunityUserRepositoryModule.class);        
    }

    private class LeadRepositoryModule implements ConstructModule {
        public Object construct(){
            return new LeadRepository();
        }
    }

    private class CommunityUserRepositoryModule implements ConstructModule {
        public Object construct(){
            return new CommunityUserRepository();
        }
    }
}
