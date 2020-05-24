public interface CaseSelector extends fflib_ISObjectSelector{
    List<Case> retrieveEngagementCases(ID ownerId);
    List<Case> retrieveEngagementCases(SearchEngagementCaseOptions searchOptions);
}
