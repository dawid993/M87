public interface EngagementService {
    List<Case> retrieveEngagementCases(ID ownerId);
    void updateEngagementCaseStatus(ID caseId,String status);
}
