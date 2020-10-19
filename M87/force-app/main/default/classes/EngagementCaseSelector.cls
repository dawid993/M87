public with sharing class EngagementCaseSelector {  
    private final List<Schema.SObjectField> engagementCaseFields = new List<Schema.SObjectField>{
        Case.ID,
        Case.Status,
        Case.Description,           
        Case.CreatedDate, 
        Case.OwnerId,   
        Case.Subject,
        Case.Priority 
    };

    private final List<Schema.SObjectField> ownerFields = new List<Schema.SObjectField>{
        User.Id,
        User.Name
    };

    public List<Case> retrieveEngagementCases(ID ownerId){
        return Database.query(createQueryBase() + ' AND OwnerId = :ownerId');
    }

    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){  
        return String.isBlank(searchOptions.phrase) ? 
            retriveEngagementCasesWithoutPhrase(searchOptions) : retriveEngagementCasesWithPhrase(searchOptions);
    }    

    private List<Case> retriveEngagementCasesWithoutPhrase(SearchEngagementCaseOptions searchOptions){
        final List<String> statuses = searchOptions.selectedStatuses;
        final List<String> priorities = searchOptions.selectedPriorities;
        final List<String> owners = searchOptions.selectedOwners;
        
        String conditionString = ' AND Status IN :statuses AND Priority IN :priorities';
        if(searchOptions.selectedOwners.size() > 1 || 
            searchOptions.selectedOwners[0] != SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
        ){
            conditionString+=' AND OwnerId IN :owners';
        }

        return Database.query(createQueryBase()+' '+conditionString);  
    }

    private List<Case> retriveEngagementCasesWithPhrase(SearchEngagementCaseOptions searchOptions){
        final String engagementRecordType = RecordTypeRepository.CASE_ENGAGEMENT_RT_ID;
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

    private String createQueryBase(){
        return 'SELECT ' + getFieldsAsString() +
            ' FROM '+Schema.SObjectType.Case.getName() +
            ' WHERE RecordTypeId = \''+ RecordTypeRepository.CASE_ENGAGEMENT_RT_ID + '\'';
    }

    private String getFieldsAsString(){
        return String.join(mapToFieldNames(),',');
    }

    private List<String> mapToFieldNames(){
        List<String> fieldNames = new List<String>();
        fieldNames.addAll(mapCaseFields());
        fieldNames.addAll(mapOwnerFields());

        return fieldNames;
    }

    private List<String> mapCaseFields(){
        List<String> fieldNames = new List<String>();
        for(Schema.SObjectField currentField : engagementCaseFields){
            fieldNames.add(currentField.getDescribe().getName());
        }

        return fieldNames;
    }

    private List<String> mapOwnerFields(){
        List<String> fieldNames = new List<String>();
        for(Schema.SObjectField currentField : ownerFields){
            fieldNames.add('Owner.'+currentField.getDescribe().getName());
        }

        return fieldNames;
    }
}
