public abstract class Modular {

    private Map<Type,ConstructModule> modules;

    public Modular(){
        modules = new Map<Type,ConstructModule>();
    }

    public void addModule(Type moduleType, ConstructModule construct){
        modules.put(moduleType,construct);
    }

    public Object createModule(Type moduleType){
        if(!modules.containsKey(moduleType)){
            throw new IllegalArgumentException(moduleType +' is not available as a module.');
        }

        ConstructModule module = modules.get(moduleType);
        return module.construct();
    }

}
