public with sharing class CaseSelectorImp extends fflib_SObjectSelector implements CaseSelector{
    private static final String engagementRecordTypeName = 'Engagement';
    public Schema.SObjectType getSObjectType() {
        return Case.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Case.ID,
            Case.Status,
            Case.Description,           
            Case.CreatedDate, 
            Case.OwnerId,   
            Case.Subject         
        };
    }

    public List<Case> retieveEngagementCases(ID ownerId){
        String conditionString = 'RecordTypeId = {0} AND OwnerId = {1}';
        conditionString = String.format(conditionString,new List<Object>{
                '\''+retrieveEngagementRecordType()+'\'',
               '\''+ ownerId+'\''
            }
        );

        fflib_QueryFactory queryFactoy = newQueryFactory();
        new UserSelectorImp().configureQueryFactoryFields(queryFactoy,'Owner');
        System.debug(conditionString);
        return Database.query(
            queryFactoy
            .setCondition(conditionString)
            .toSOQL()
        );
    }

    private Id retrieveEngagementRecordType(){
        return Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(engagementRecordTypeName).getRecordTypeId();
    }
}
