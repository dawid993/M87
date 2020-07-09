const LwcImmutabilityService = Object.freeze({
    deepFreeze: Object.freeze(deepFreeze)
})

function deepFreeze(currentObject){
    if (currentObject) {
        for (let [key, value] of Object.entries(currentObject)) {
            if (currentObject.hasOwnProperty(key) && typeof value == "object") {
                deepFreeze(value);
            }
        }

        Object.freeze(currentObject);
        return currentObject        
    }    
    return null  
}

class ImmutableUtils {
    deepClone(currentObject){
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

    deepFreeze(currentObject){
        if (currentObject) {
            for (let [key, value] of Object.entries(currentObject)) {
                if (currentObject.hasOwnProperty(key) && typeof value == "object") {
                    deepFreeze(value);
                }
            }
    
            Object.freeze(currentObject);
            return currentObject;       
        }    
        return null;            
    }
}

export default LwcImmutabilityService