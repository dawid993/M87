public with sharing class AddressParserImp implements AddressParser {
    public List<AddressStructure> parseAddresses(String addressesJSON){
        List<AddressStructure> addressStructure = new List<AddressStructure>();
        for(AddressResponseParser.Records record : AddressResponseParser.parse(addressesJSON).records){
            addressStructure.add(new AddressStructure(
                record.Id,
                record.Street,
                record.City,
                record.Province,
                record.PostCode,
                record.House_number));
        } 

        return addressStructure;
    }
}
