public class SelectorModules extends Modular {
    
    public SelectorModules(){
        super();
        addModule(UserSelectorImp.class , new UserSelectorModule());
    }

    private class UserSelectorModule implements ConstructModule {
        public Object construct(){
            return new UserSelectorImp();
        }
    }
}
