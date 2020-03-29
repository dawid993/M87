public interface CaseService {
    void changeCaseStatus(ID caseId,String newStatus);
    List<Case> retieveEngagementCases(ID ownerId);
}
