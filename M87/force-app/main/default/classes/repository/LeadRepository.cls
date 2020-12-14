public with sharing class LeadRepository extends Repository {
    public override List<Schema.SObjectField> getFields(){
        return new List<Schema.SObjectField> {
            Lead.ID,   
            Lead.Name,
            Lead.Status,
            Lead.Rating,
            Lead.Email,
            Lead.Industry     
        };
    } 

    public override String getSObjectName(){
        return 'Lead';
    }

    public void saveEngagementLead(Lead lead){        
        upsert lead;
    }

    public Lead getEngagementLeadById(Id leadId){
        String query = createBaseQuery();
        query += 'WHERE ID = :leadId LIMIT 1';

        return Database.query(query);
    }   

}
