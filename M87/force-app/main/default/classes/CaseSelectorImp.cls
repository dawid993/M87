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
            Case.Subject,
            Case.Priority        
        };
    }

    public List<Case> retrieveEngagementCases(ID ownerId){
        String conditionString = 'RecordTypeId = {0} AND OwnerId = {1}';
        conditionString = String.format(conditionString,new List<Object>{
                '\''+retrieveEngagementRecordType()+'\'',
               '\''+ ownerId+'\''
            }
        );

        fflib_QueryFactory queryFactory = newQueryFactory();
        new UserSelectorImp().configureQueryFactoryFields(queryFactory,'Owner');
        
        return Database.query(
            queryFactory
            .setCondition(conditionString)
            .toSOQL()
        );
    }

    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){  
        return String.isBlank(searchOptions.phrase) ? 
            retriveEngagementCasesWithoutPhrase(searchOptions) : retriveEngagementCasesWithPhrase(searchOptions);
    }


    private List<Case> retriveEngagementCasesWithoutPhrase(SearchEngagementCaseOptions searchOptions){
        final List<String> statuses = searchOptions.selectedStatuses;
        final List<String> priorities = searchOptions.selectedPriorities;
        final List<String> owners = searchOptions.selectedOwners;
        
        String conditionString = 'RecordTypeId = {0} AND Status IN :statuses AND Priority IN :priorities';
        if(searchOptions.selectedOwners.size() > 1 || 
            searchOptions.selectedOwners[0] != SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
        ){
            conditionString+=' AND OwnerId IN :owners';
        }

        conditionString = String.format(conditionString,new List<Object>{
                '\''+retrieveEngagementRecordType()+'\''
            }
        );

        fflib_QueryFactory queryFactory = newQueryFactory();
        new UserSelectorImp().configureQueryFactoryFields(queryFactory,'Owner');
        
        return Database.query(
            queryFactory
            .setCondition(conditionString)
            .toSOQL()
        );
    }

    private List<Case> retriveEngagementCasesWithPhrase(SearchEngagementCaseOptions searchOptions){
        final String engagementRecordType = retrieveEngagementRecordType();
        final String phrase = searchOptions.phrase;
        final List<String> statuses = searchOptions.selectedStatuses;
        final List<String> priorities = searchOptions.selectedPriorities;
        final List<String> owners = searchOptions.selectedOwners;

        String searchQuery = 'FIND :phrase IN ALL FIELDS RETURNING Case(ID,Status,Description '+
        ',CreatedDate,Owner.Name,Subject,Priority WHERE RecordTypeId = :engagementRecordType '+
        'AND Status IN :statuses AND Priority IN :priorities '
        + (searchOptions.selectedOwners.size() > 1 || 
            searchOptions.selectedOwners[0] != SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID 
            ? ' AND OwnerID IN :owners)' : ')');        
        
        List<List<sObject>> searchResults = Search.query(searchQuery);        
        return (Case[]) searchResults[0];
    }

    private Id retrieveEngagementRecordType(){
        return Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(engagementRecordTypeName).getRecordTypeId();
    }
}
