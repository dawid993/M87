public with sharing class CaseConverter {
    
    public static List<EngagementCaseDTO> convertToCaseDTO(List<Case> cases){
        List<EngagementCaseDTO> dtos = new List<EngagementCaseDTO>();
        for(Case c : cases){
            dtos.add(convertToCaseDTO(c));
        }

        return dtos;
    }

    public static EngagementCaseDTO convertToCaseDTO(Case record){
        EngagementCaseDTO dto = new EngagementCaseDTO();
        dto.CreatedDate = record.CreatedDate;
        dto.Description = record.Description;
        dto.id = record.Id;
        dto.Priority = record.Priority;
        dto.Status = record.Status;
        dto.Subject = record.Subject;
        dto.ownerName = record.Owner.Name;

        return dto;
    }
}
