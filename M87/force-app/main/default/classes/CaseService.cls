public interface CaseService {
    void changeCaseStatus(ID caseId,String newStatus);
    List<Case> retrieveEngagementCases(ID ownerId);
    List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions);
}
