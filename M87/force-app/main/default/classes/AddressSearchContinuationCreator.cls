public interface AddressSearchContinuationCreator {
    Continuation createContinuation(AddressSearchParametersStorage parameterStorage,AddressSearchStrategy strategy);
}
