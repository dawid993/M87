function flushPromises(){
    return new Promise(resolve => setImmediate(resolve));
}

export {flushPromises}