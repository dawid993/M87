public with sharing class AddressSearchStrategyFactoryImp implements AddressSearchStrategyFactory {
    public AddressSearchStrategy getAddressSearchStrategy(AddressSearchStrategyType strategyType){
        AddressSearchStrategy strategy;

        switch on strategyType {
            when POST_CODE {
                strategy = new AddressSearchByPostCode();
            }

            when POST_CODE_OR_STREET {
                strategy = new AddressSearchByPostCodeAndCityOrStreet();
            }

            when POST_CODE_AND_CITY_AND_STREET {
                strategy = new AddressSearchByPostCodeAndCityAndStreet();
            }

            when FULL_SEARCH {
                strategy = new AddressSearchByFullParametersSearch();
            }

            when else{
                throw new Exceptions.NoAddressSearchStrategyImplementationException(strategyType);
            }
        }

        return strategy;
    }
}
