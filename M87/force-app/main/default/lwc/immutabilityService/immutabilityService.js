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

export default LwcImmutabilityService