public with sharing abstract class Repository {
    
    public abstract List<Schema.SObjectField> getFields();

    public abstract String getSObjectName();

    public String createBaseQuery(){
        String query = 'SELECT ' + getFieldsAsString() + ' ';
        query += 'FROM ' + getSObjectName()+' ';
        return query;
    } 

    private List<String> mapFields(){
        List<String> fieldNames = new List<String>();
        for(Schema.SObjectField currentField : getFields()){
            fieldNames.add(currentField.getDescribe().getName());
        }

        return fieldNames;
    }

    private String getFieldsAsString(){
        return String.join(mapFields(), ',');
    }
}
