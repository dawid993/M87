public with sharing abstract class Repository {
    
    public abstract List<Schema.SObjectField> getFields();

    public abstract String getSObjectName();

    protected String createBaseQuery(){
        String query = 'SELECT ' + getFieldsAsString() + ' ';
        query += 'FROM ' + getSObjectName()+' ';
        return query;
    } 

    protected virtual List<String> mapFields(){
        return mapToStringFields(getFields());
    }

    protected List<String> mapToStringFields(List<Schema.SObjectField> fields){
        List<String> fieldNames = new List<String>();
        for(Schema.SObjectField currentField : fields){
            fieldNames.add(currentField.getDescribe().getName());
        }

        return fieldNames;
    }

    protected List<String> mapToStringFields(List<Schema.SObjectField> fields,String parentLookup){
        List<String> fieldNames = new List<String>();
        for(Schema.SObjectField currentField : fields){
            fieldNames.add(parentLookup + '.'+ currentField.getDescribe().getName());
        }

        return fieldNames;
    }

    private String getFieldsAsString(){
        return String.join(mapFields(), ',');
    }
}
