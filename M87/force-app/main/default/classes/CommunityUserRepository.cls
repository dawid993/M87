public with sharing class CommunityUserRepository extends Repository{

    public override List<Schema.SObjectField> getFields() {
        return new List<Schema.SObjectField> {
            CommunityUser__c.ID,   
            CommunityUser__c.Name,
            CommunityUser__c.FirstName__c,
            CommunityUser__c.LastName__c,
            CommunityUser__c.Email__c,
            CommunityUser__c.Username__c,
            CommunityUser__c.Lead__c     
        };
    }

    public override String getSObjectName(){
        return 'CommunityUser__c';
    }
  
    public void saveCommunityUser(CommunityUser comunityUser){
        System.debug(comunityUser);
        upsert comunityUser.getRecord();
    }

    public CommunityUser getCommunityUserById(Id comUserId){
        String query = createBaseQuery();
        query += 'WHERE ID = :comUserId LIMIT 1';

        return new CommunityUser(Database.query(query));
    }

    public List<CommunityUser> getCommunityUsersForEngagementLead(EngagementLead lead){
        String query = createBaseQuery();
        final Id leadId = lead.getRecordId();
        query += 'WHERE Lead__c = :leadId LIMIT 1';

        return CommunityUser.convert(Database.query(query));
    }
}
