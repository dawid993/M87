public with sharing class CaseRepository extends Repository {
    private final List<Schema.SObjectField> ownerFields = new List<Schema.SObjectField> {
        User.Id,
        User.Name
    };

    public override List<Schema.SObjectField> getFields(){
        return new List<Schema.SObjectField> {
            Case.CreatedDate, 
            Case.Description,
            Case.ID, 
            Case.Priority,
            Case.Status,              
            Case.Subject           
        };
    }
    
    public override String getSObjectName(){
        return 'Case';
    }

    protected override List<String> mapFields(){
        final List<String> fieldNames = super.mapFields();
        fieldNames.addAll(mapToStringFields(ownerFields,'Owner'));
        return fieldNames;
    }
    
    public List<Case> retrieveEngagementCases(ID ownerId){
        return Database.query(createBaseQuery() + ' AND OwnerId = :ownerId');
    }

    public List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions){  
        return String.isBlank(searchOptions.phrase) ? 
            retriveEngagementCasesWithoutPhrase(searchOptions) : retriveEngagementCasesWithPhrase(searchOptions); 
    }    

    private List<Case> retriveEngagementCasesWithoutPhrase(SearchEngagementCaseOptions searchOptions){
        final List<String> statuses = searchOptions.selectedStatuses;
        final List<String> priorities = searchOptions.selectedPriorities;
        final List<String> owners = searchOptions.selectedOwners;
        
        String conditionString = String.format(
            'WHERE RecordTypeId = {0} AND Status IN :statuses AND Priority IN :priorities',
            new List<Object>{ '\''+RecordTypeRepository.CASE_ENGAGEMENT_RT_ID+'\''}
        );

        if(searchOptions.selectedOwners.size() > 1 || 
            searchOptions.selectedOwners[0] != SearchEngagementCaseOptions.ALL_OWNER_OPTION_ID
        ){
            conditionString+=' AND OwnerId IN :owners';
        }
        System.debug(createBaseQuery()+' '+conditionString);
        return Database.query(createBaseQuery()+' '+conditionString);  
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

    public void save(Case caseRecord){
        upsert caseRecord;
    }

}
