export default class ImmutableUtils  {

    static deepClone(currentObject){
        if(currentObject){
            const clonedObject = {};
            for(let [key, value] of Object.entries(currentObject)){
                if(currentObject.hasOwnProperty(key)){
                    clonedObject[key] = typeof value === 'object' ? this.deepClone(value) : value;                   
                }
            }
            return clonedObject;
        }
        return currentObject;
    }

    static deepFreeze(currentObject){
        if (currentObject) {
            for (let [key, value] of Object.entries(currentObject)) {
                if (currentObject.hasOwnProperty(key) && typeof value == "object") {
                    this.deepFreeze(value);
                }
            }
    
            Object.freeze(currentObject);
            return currentObject;       
        }    
        return null;            
    }

    static deepCloneAndFreeze(currentObject){
        if(currentObject){
            return this.deepFreeze(this.deepClone(currentObject));
        }
    }
}
