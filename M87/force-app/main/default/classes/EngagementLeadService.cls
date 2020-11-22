public with sharing class EngagementLeadService {

    private final LeadRepository leadRepository;
    private final CommunityUserRepository commUserRepository;

    public EngagementLeadService(LeadRepository leadRepository, CommunityUserRepository commUserRepository){
        this.leadRepository = leadRepository;
        this.commUserRepository = commUserRepository;
    }

    public Lead createLead(EngagementLeadDTO leadDto){
        if(leadDto == null || leadDto.leadDetails == null){
            throw new IllegalArgumentException('Invalid dto object has been passed.');
        }

        Lead lead = createEngagementLead(leadDto.leadDetails);
        leadRepository.saveEngagementLead(lead);

        if(leadDto.communityUserDetails != null){
            CommunityUser__c commUser = createCommunityUser(leadDto.communityUserDetails);
            commUser.lead__c = lead.Id;
            commUserRepository.saveCommunityUser(commUser);
        }

        if(String.isNotBlank(leadDto.fileAsBase64Blob)){
            Attachment att = new AttachmentCreator('Registration file',leadDto.fileAsBase64Blob).getAttachment();
            att.ParentId = lead.Id;

            insert att;
        }

        return lead;
    }

    public Lead getEngagementLead(Id leadId){
        return leadRepository.getEngagementLeadById(leadId);
    }

    public List<CommunityUser__c> getCommunityUsersForEngagementLead(Lead lead){
        return commUserRepository.getCommunityUsersForEngagementLead(lead);
    }

    private Lead createEngagementLead(EngagementLeadDTO.LeadDetails leadDetails){
        final Lead lead = new Lead();        
        lead.firstName = leadDetails.leadName.split(' ')[0];
        lead.lastName = leadDetails.leadName.split(' ')[1];
        lead.Title = leadDetails.leadTitle;
        lead.Email = leadDetails.email;
        lead.Phone = leadDetails.phone;
        lead.Company = leadDetails.companyName;
        lead.Industry = leadDetails.industry;
        lead.NumberOfEmployees = leadDetails.numberOfEmployees;
        lead.AnnualRevenue = leadDetails.annualRevenue;
        lead.DoNotCall = leadDetails.doNotCall;
        lead.Status = leadDetails.status;
        lead.Rating = leadDetails.rating;

        return lead;
    }

    private CommunityUser__c createCommunityUser(EngagementLeadDTO.CommunityUserDetails user){
        final CommunityUser__c communityUser = new CommunityUser__c();
        communityUser.FirstName__c = user.firstName;
        communityUser.LastName__c = user.lastName;
        communityUser.Email__c = user.email;
        communityUser.Username__c = user.userName;        

        return communityUser;
    }
}