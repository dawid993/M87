public class Exceptions {    
    public class UndefinedOwnerException extends Exception {}
    public class UnableToReadDataException extends Exception {}
    public class InvalidServiceActionParametersException extends Exception {}
    public class UnableToSaveDataException extends Exception {}
    public class CreateContinuationException extends Exception {}

    public class NoAddressSearchStrategyImplementationException extends Exception {
        public NoAddressSearchStrategyImplementationException(AddressSearchStrategyType strategyType){
            this('Cannot find implementation for: '+strategyType);
        }
    }
}
