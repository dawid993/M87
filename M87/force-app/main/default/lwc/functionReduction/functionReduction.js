const reducers = {
    reducer : (parameter, currentFunction) => {            
        let returnValue = currentFunction(parameter)
        return returnValue
    }
}

function reduceFunctions(acc, currentFunction){
    return acc && currentFunction();
}

export default reducers
