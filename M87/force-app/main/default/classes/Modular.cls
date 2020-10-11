public abstract class Modular {

    private Map<Type,Type> modules;

    public Modular(){
        modules = new Map<Type,Type>();
    }

    protected void addModule(Type moduleType, Type construct){
        if(!ConstructModule.class.isAssignableFrom(construct)){
            throw new IllegalArgumentException(moduleType +' is not subtype of ConstructModule.');
        }

        modules.put(moduleType,construct);
    }

    protected ConstructModule getModuleConstruct(Type moduleType){
        if(!modules.containsKey(moduleType)){
            throw new IllegalArgumentException(moduleType +' is not available as a module.');
        }

        return (ConstructModule) modules.get(moduleType).newInstance();
    }

    public virtual Object createModule(Type moduleType){        
        ConstructModule module = getModuleConstruct(moduleType);
        return module.construct();
    }         

}
