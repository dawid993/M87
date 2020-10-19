public with sharing class CaseBuilder {
    private Case currentCase;

    public CaseBuilder(){
        this.currentCase = new Case();
    }

    public CaseBuilder setId(Id id){
        currentCase.Id = id;
        return this;
    }

    public CaseBuilder setStatus(String status){
        currentCase.Status = status;
        return this;
    }

    public CaseBuilder setSubject(String subject){
        currentCase.Subject = subject;
        return this;
    }

    public CaseBuilder setPriority(String priority){
        currentCase.Priority = priority;
        return this;
    }

    public CaseBuilder setRecordTypeId(Id recordTypeId){
        currentCase.RecordTypeId = recordTypeId;
        return this;
    }

    public Case build(){
        Case tempCase = currentCase;
        currentCase = new Case();
        return tempCase;
    }

}
