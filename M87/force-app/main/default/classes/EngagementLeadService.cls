public with sharing class EngagementLeadService {

    private LeadRepository leadRepository;
    private CommunityUserRepository commUserRepository;

    public EngagementLeadService(LeadRepository leadRepository, CommunityUserRepository commUserRepository){
        this.leadRepository = leadRepository;
        this.commUserRepository = commUserRepository;
    }

    public EngagementLead createLead(EngagementLeadDTO leadDto){
        if(leadDto == null || leadDto.leadDetails == null){
            throw new IllegalArgumentException('Invalid dto object has been passed.');
        }

        EngagementLead lead = createEngagementLead(leadDto.leadDetails);
        leadRepository.saveEngagementLead(lead);

        if(leadDto.communityUserDetails != null){
            CommunityUser commUser = createCommunityUser(leadDto.communityUserDetails);
            commUser.setEngagementLead(lead);
            commUserRepository.saveCommunityUser(commUser);
        }

        if(String.isNotBlank(leadDto.fileAsBase64Blob)){
            Attachment att = new AttachmentCreator('Registration file',leadDto.fileAsBase64Blob).getAttachment();
            att.ParentId = lead.getRecordId();

            insert att;
        }

        return lead;
    }

    public EngagementLead getEngagementLead(Id leadId){
        return leadRepository.getEngagementLeadById(leadId);
    }

    public List<CommunityUser> getCommunityUsersForEngagementLead(EngagementLead lead){
        return commUserRepository.getCommunityUsersForEngagementLead(lead);
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