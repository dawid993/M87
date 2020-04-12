public interface EngagementService {
    List<Case> retrieveEngagementCases(ID ownerId);
    List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions);
    void updateEngagementCaseStatus(ID caseId,String status);
}
