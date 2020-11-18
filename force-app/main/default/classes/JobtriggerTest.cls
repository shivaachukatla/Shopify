@isTest
public class JobtriggerTest {
    @isTest static void testDeActivateJob_To_VerifyApplicationsAlsoDeActivated(){
        List<Account> departments = TestDataFactory.createDepartments(1);
        List<Job__c> jobs = TestDataFactory.createJobs(1);
        List<Job_Posting__c> jobPostings = TestDataFactory.createJobPostings(jobs, departments);
        List<Contact> applicants = TestDataFactory.createApplicants(1);
        List<Job_Application__c> jobApplications = TestDataFactory.createJobApplications(jobPostings, applicants); 
        Test.startTest();
            jobs[0].Status__c = 'Inactive';
            update jobs; 
        Test.stopTest();
        
        List<Job_Application__c> applications = [select Id,Application_Status__c from Job_Application__c
                                                WHERE Application_Status__c = 'Inactive'];
        System.assertEquals(1, applications.size());
    }
}