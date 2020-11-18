/*Rest resource for Single Job Application */
@RestResource(urlMapping='/JobApplicationService/*')
global class JobApplicationService {
	@HttpPost
    global static String createNewJobApplication() {
        String response = '';
        try{
            RestRequest     restRqst = RestContext.request;
            JobApplicationRequest applicationDetails = (JobApplicationRequest) System.JSON.deserialize(restRqst.requestBody.toString(), JobApplicationRequest.class);
            if(applicationDetails.JobPostingId == null || applicationDetails.LastName == null){
                response = 'JobpostingId and LastName are mandatory to process the Application';
            }else{
                Contact applicant = JobApplicationServiceUtility.formContactRecord(applicationDetails);
                insert applicant; 
                
                List<Job_Posting__c> jobPostings = [SELECT Id,Name,Department__r.Name
                                                FROM Job_Posting__c
                                                WHERE Name =:applicationDetails.JobPostingId];
                
                Job_Application__c jobApplication = JobApplicationServiceUtility.formJobApplicationRecord(applicant.Id,jobPostings[0].Id);
                insert jobApplication;
                response = 'Job Application Successfully created with id'+jobApplication.Id;
            }
        }catch(Exception e){
            response = e.getMessage();
        }
        return response;
    }
    
}