@isTest
public class JobApplicationServiceTest {
    @isTest static void testJobApplicationServiceWhichCreatesSingleApplicationInSF(){
        List<Account> departments = TestDataFactory.createDepartments(1);
        List<Job__c> jobs = TestDataFactory.createJobs(1);
        List<Job_Posting__c> jobPostings = TestDataFactory.createJobPostings(jobs, departments);
        jobPostings = [select Id,Name from Job_Posting__c];
        JobApplicationRequest appReq = new JobApplicationRequest();
        appReq.FirstName = 'Amrutha';
        appReq.LastName = 'Achukatla';
        appReq.Email = 'AMrutha474@gmail.com';
        appReq.MobilePhone = '9897652341';
        appReq.JobPostingId = jobPostings[0].Name;
        appReq.MailingStreet = 'testStreet';
        appReq.MailingCity = 'testCity';
        appreq.MailingCountry = 'USA';
        appReq.MailingState = 'NC';
        appReq.MailingPostalCode = '27513';
        
        String myJSON = JSON.serialize(appReq); 
        RestRequest request = new RestRequest(); 
        request.requestUri ='https://bandwidth-dev-ed.my.salesforce.com//services/apexrest/JobApplicationService/';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        Test.startTest();
        	JobApplicationService.createNewJobApplication();
        Test.stopTest();
        List<Job_Application__c> JobApps = [select Id from Job_Application__c];
        System.assertEquals(1, JobApps.size());
        
    }
}