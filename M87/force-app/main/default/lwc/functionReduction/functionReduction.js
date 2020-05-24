const reducers = {
    reducer : (parameter, currentFunction) => {            
        let returnValue = currentFunction(parameter)
        return returnValue
    }
}

export default reducers
