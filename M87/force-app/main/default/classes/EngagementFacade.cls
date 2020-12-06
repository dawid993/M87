public with sharing class EngagementFacade {
    private final EngagementCaseService caseService;
    private final EngagementLeadService leadService;

    public EngagementFacade(final EngagementCaseService caseService, final EngagementLeadService leadService){
        this.caseService = caseService;
        this.leadService = leadService;
    }

    public List<Case> retrieveEngagementCasesByOwnerId(final ID ownerId){
        return caseService.retrieveEngagementCasesByOwnerId(ownerId);
    }

    public List<Case> retrieveEngagementCases(final SearchEngagementCaseOptions searchOptions){
        return caseService.retrieveEngagementCases(searchOptions);
    }

    public void updateEngagementCaseStatus(final ID caseId,final String status){
        caseService.updateEngagementCaseStatus(caseId,status);
    }

    public Lead createLead(final EngagementLeadDTO leadDto){
        return leadService.createLead(leadDto);
    }

    public Lead getEngagementLead(final Id leadId){
        return leadService.getEngagementLead(leadId);
    }

    public List<CommunityUser__c> getCommunityUsersForEngagementLead(final Lead lead){
        return leadService.getCommunityUsersForEngagementLead(lead);
    }

}
