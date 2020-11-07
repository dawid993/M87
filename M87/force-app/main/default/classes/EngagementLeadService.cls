public with sharing class EngagementLeadService {
    public void createLead(EngagementLeadDTO leadDto){
        if(leadDto == null || leadDto.leadDetails == null){
            throw new IllegalArgumentException('Invalid dto object has been passed.');
        }

        EngagementLead lead = createEngagementLead(leadDto.leadDetails);
        new LeadRepository().saveEngagementLead(lead);
    }

    private EngagementLead createEngagementLead(EngagementLeadDTO.LeadDetails leadDetails){
        final EngagementLead lead = new EngagementLead();
        lead.setName(leadDetails.leadName);
        lead.setTitle(leadDetails.leadTitle);
        lead.setEmail(leadDetails.email);
        lead.setPhone(leadDetails.phone);
        lead.setCompany(leadDetails.companyName);
        lead.setIndustry(leadDetails.industry);
        lead.setEmployeesNumber(leadDetails.numberOfEmployees);
        lead.setAnnualRevenue(leadDetails.annualRevenue);
        lead.setDoNotCall(leadDetails.doNotCall);
        lead.setStatus(leadDetails.status);
        lead.setRating(leadDetails.rating);

        return lead;
    }

    private CommunityUser createCommunityUser(EngagementLeadDTO.CommunityUserDetails user){
        final CommunityUser communityUser = new CommunityUser();
        communityUser.setFirstName(user.firstName);
        communityUser.setLastName(user.lastName);
        communityUser.setEmail(user.email);
        communityUser.setUsername(user.userName);

        return communityUser;
    }
}