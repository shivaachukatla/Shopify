public class JobTriggerHandler {
    public static List<Id> processedJobIds;
    /* @methodName: processJobRecords
     * @description: 1. this method is responsbile for checking if a Job record has been inactivted
     *               2. if a job record is inactivated by recruiter, this method deactivates job applications
     * @parameters: none 
     * @returnType: Map<Id,Job__c> oldJobs (trigger.oldMap), List<Job__c> newJobs(trigger.new)
     */
    public static void processJobRecords(Map<Id,Job__c> oldJobs, List<Job__c> newJobs){
        try{
            List<Id> jobIds = new list<Id>();
            if(null == processedJobIds) processedJobIds = new List<Id>();
            for(Job__c job:newJobs){
                Job__c oldJob = oldJobs.get(job.Id);//get record from oldMap
                boolean hasJobStatusChanged = (job.Status__c != oldJob.Status__c) ? true : false;
                if( hasJobStatusChanged && job.Status__c == 'Inactive'){//check if a Job has been Inactivated
                    if(!processedJobIds.contains(job.Id)){//Logic to avoid recursion
                   		jobIds.add(job.Id); 
                        processedJobIds.add(job.Id);
                    }
                }
            }
            if(!jobIds.isEmpty()){
                //Call Method to Query Job Application Records
               List<Job_Application__c> jobApplications = queryJobApplications(jobIds);
               if(!jobApplications.isEmpty()){
                   for(Job_Application__c jobApp:jobApplications) {
                       jobApp.Application_Status__c = 'Inactive';//Deactivate Job Applications
                   }
                   //Call Method to update JobApplications
                   deactivateJobApplications(jobApplications);
               }
            }
        }catch(Exception e){
            //Error Handling mechanism can be implemented by creating a custom Object called Error Logger 
        }
    }
    /* @methodName: queryJobApplications
     * @description: 1. Query Job Application records 
     * @parameters: List<Id> jobIds 
     * @returnType: List<Job_Application__c>
     */
    public static List<Job_Application__c> queryJobApplications(List<Id> jobIds){
        List<Job_Application__c> jobApplications =  new List<Job_Application__c>();
        jobApplications = [SELECT Id,Application_Status__c,Job_Posting__r.Job__c
                           FROM Job_Application__c
                           WHERE Job_Posting__r.Job__c IN:jobIds AND 
                                 Application_Status__c !='Inactive'];
        return jobApplications; 
    }
    /* @methodName: deactivateJobApplications
     * @description: 1. Update Job Application records with Application Status value as 'Inactive'
     * @parameters: List<Job_Application__c> jobApplications
     * @returnType: none
     */
    public static void deactivateJobApplications(List<Job_Application__c> jobApplications){
        Database.SaveResult[] srList = Database.update(jobApplications, false); 
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully updated jobApplication. jobApplication ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('jobApplication fields that affected this error: ' + err.getFields());
                }
            }
	   }
    }
}