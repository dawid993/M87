public with sharing class LeadRepository {
    
    public void saveEngagementLead(EngagementLead lead){
        Lead sfdcLead = lead.getLead();
        upsert sfdcLead;
    }
}
