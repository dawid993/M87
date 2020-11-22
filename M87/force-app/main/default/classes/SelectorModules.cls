public class SelectorModules extends Modular {
    
    public SelectorModules(){
        super();
        addModule(UserSelectorImp.class , UserSelectorModule.class);       
        addModule(EngagementCaseSelector.class, EngagementCaseSelectorModule.class);
    }

    private class UserSelectorModule implements ConstructModule {
        public Object construct(){
            return new UserSelectorImp();
        }
    }   

    private class EngagementCaseSelectorModule implements ConstructModule {
        public Object construct(){
            return new EngagementCaseSelector();
        }
    }
}
