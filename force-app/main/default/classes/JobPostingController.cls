public class JobPostingController {
    @AuraEnabled
    public static List<Job_Posting__c> getJobPostingsAlongWithApplicationDetails(Id departmentId){
        List<Job_Posting__c> jobPostings = [SELECT Id,Name,Job__c,Job_Id__c,
                                             (SELECT Applicant__c,Applicant_Name__c,Application_Status__c
                                              FROM Job_Applications__r)
                                            FROM Job_Posting__c
                                            WHERE Department__c =:departmentId AND Status__c='Active'];
        return jobPostings;
    }
}