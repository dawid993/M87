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
  
    public void saveCommunityUser(CommunityUser__c comunityUser){       
        upsert comunityUser;
    }

    public CommunityUser__c getCommunityUserById(Id comUserId){
        String query = createBaseQuery();
        query += 'WHERE ID = :comUserId LIMIT 1';

        return Database.query(query);
    }

    public List<CommunityUser__c> getCommunityUsersForEngagementLead(Lead lead){
        String query = createBaseQuery();
        final Id leadId = lead.Id;
        query += 'WHERE Lead__c = :leadId LIMIT 1';

        return Database.query(query);
    }
}
