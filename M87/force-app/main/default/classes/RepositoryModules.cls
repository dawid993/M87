public with sharing class RepositoryModules extends Modular {
    public RepositoryModules(){
        super();
        addModule(CaseRepository.class, CaseRepositoryModule.class);       
        addModule(CommunityUserRepository.class, CommunityUserRepositoryModule.class); 
        addModule(LeadRepository.class, LeadRepositoryModule.class);   
        addModule(UserRepository.class, UserRepositoryModule.class);
    }

    private class CaseRepositoryModule implements ConstructModule {
        public Object construct(){
            return new CaseRepository();
        }
    }

    private class CommunityUserRepositoryModule implements ConstructModule {
        public Object construct(){
            return new CommunityUserRepository();
        }
    }

    private class LeadRepositoryModule implements ConstructModule {
        public Object construct(){
            return new LeadRepository();
        }
    }    

    private class UserRepositoryModule implements ConstructModule {
        public Object construct(){
            return new UserRepository();
        }
    }    
}
