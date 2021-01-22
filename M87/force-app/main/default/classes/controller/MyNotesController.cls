public with sharing class MyNotesController {
    
    @AuraEnabled
    public static ApexActionResult saveSingleNote(MyNote newNote){
        try {
            return ApexActionResult.success();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class MyNote {
        @AuraEnabled       
        public String title {get; set;}

        @AuraEnabled       
        public DateTime dueDate {get; set;}

        @AuraEnabled       
        public String content {get; set;}
    }
}
