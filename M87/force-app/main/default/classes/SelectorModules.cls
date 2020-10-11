public class SelectorModules extends Modular {
    
    public SelectorModules(){
        super();
        addModule(UserSelectorImp.class , UserSelectorModule.class);
        addModule(CaseSelectorImp.class , CaseSelectorModule.class);
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
}
