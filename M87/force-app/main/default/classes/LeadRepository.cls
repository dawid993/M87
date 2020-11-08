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

    public void saveEngagementLead(EngagementLead lead){
        Lead sfdcLead = lead.getRecord();
        upsert sfdcLead;
    }

    public EngagementLead getEngagementLeadById(Id leadId){
        String query = createBaseQuery();
        query += 'WHERE ID = :leadId LIMIT 1';

        return new EngagementLead(Database.query(query));
    }   

}
