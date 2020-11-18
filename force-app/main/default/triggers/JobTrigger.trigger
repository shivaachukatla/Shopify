trigger JobTrigger on Job__c (after update) {
    //call Helper class
	JobTriggerHandler.processJobRecords(trigger.oldmap,trigger.new);
}