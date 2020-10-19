public class SelectorModules extends Modular {
    
    public SelectorModules(){
        super();
        addModule(UserSelectorImp.class , UserSelectorModule.class);
        addModule(CaseSelectorImp.class , CaseSelectorModule.class);
        addModule(EngagementCaseSelector.class, EngagementCaseSelectorModule.class);
    }

    private class UserSelectorModule implements ConstructModule {
        public Object construct(){
            return new UserSelectorImp();
        }
    }

    private class CaseSelectorModule implements ConstructModule {
        public Object construct(){
            return new CaseSelectorImp();
        }
    }

    private class EngagementCaseSelectorModule implements ConstructModule {
        public Object construct(){
            return new EngagementCaseSelector();
        }
    }
}
