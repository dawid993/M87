public with sharing class EngagementLead {
    private Lead lead;

    public EngagementLead(Lead lead){
        this.lead = lead;
    }

    public EngagementLead(){
        this.lead = new Lead();        
    }

    public Lead getRecord(){
        return lead;
    }

    public Id getRecordId(){
        return lead.Id;
    }

    public void setName(String name){
        lead.firstName = name.split(' ')[0];
        lead.lastName = name.split(' ')[1];
    }

    public String getName(){
        return lead.Name;
    }

    public void setTitle(String title){
        lead.Title = title;
    }

    public String getTitle(){
        return lead.Title;
    }

    public void setEmail(String email){
        lead.email = email;
    }

    public String getEmail(){
        return lead.Email;
    }

    public void setPhone(String phone){
        lead.phone = phone;
    }

    public String getPhone(){
        return lead.phone;
    }

    public void setCompany(String company){
        lead.company = company;
    }

    public String getCompany(){
        return lead.company;
    }

    public void setIndustry(String industry){
        lead.industry = industry;
    }

    public String getIndustry(){
        return lead.industry;
    }

    public void setEmployeesNumber(Integer employeesNumber){
        lead.NumberOfEmployees = employeesNumber;
    }

    public Integer getEmployeesNumber(){
        return lead.NumberOfEmployees;
    }

    public void setAnnualRevenue(Decimal revenue){
        lead.AnnualRevenue = revenue;
    }

    public Decimal getAnnualRevenue(){
        return lead.AnnualRevenue;
    }

    public void setDoNotCall(Boolean doNotCall){
        lead.doNotCall = doNotCall;
    }

    public Boolean getDoNotCall(){
        return lead.doNotCall;
    }

    public void setStatus(String status){
        lead.Status = status;
    }

    public String getStatus(){
        return lead.status;
    }    

    public void setRating(String rating){
        lead.Rating = rating;
    }

    public String getRating(){
        return lead.rating;
    }

}
