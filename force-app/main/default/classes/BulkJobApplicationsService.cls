/*rest resource for Bulk Job Application Creation*/
@RestResource(urlMapping='/BulkJobApplicationsService/*')
global class BulkJobApplicationsService {
	@HttpPost
    global static void createNewJobApplications() {
        try{
            /******************************variable Section*********************************************/
            RestRequest     restRqst = RestContext.request;
            list<JobApplicationRequest> applications = (list<JobApplicationRequest>) System.JSON.deserialize(restRqst.requestBody.toString(), list<JobApplicationRequest>.class);
            //applicantNameJobPostingsIds is a map to store applicantName+Email as key and JobPosting Ids as a values
            Map<String,List<String>> applicantNameJobPostingsIds =  new Map<String,List<String>>(); 
            //this helps us get Job Posting Record id using Job Id(Auto Number)
            Map<String,String> jobPostingIdToRecordId = new Map<String,String>();
            //Below list will be used to query JobPosting Records
            List<String> jobPostingIds = new List<String>();
            //Applicants to Be Created
            List<Contact> applicants = new List<Contact>();
            //Job Applications to be created
            List<Job_Application__c> jobApplications = new List<Job_Application__c>();
            
            /******************************End of variable Section*********************************************/
            //Below logic forms JobPostingIds
            for(JobApplicationRequest application:applications){
               if(application.JobPostingId!=null)
               jobPostingIds.add(application.JobPostingId); 
            }
            if(!jobPostingIds.isEmpty()){
                //Query Job Postings
                List<Job_Posting__c> jobPostings = [SELECT Id,Name,Department__r.Name
                                                    FROM Job_Posting__c
                                                    WHERE Name IN:jobPostingIds];
                //Prepare jobPostingIdToRecordId map which stores AUto Number name as Key and record Id as Value
                for(Job_Posting__c jobPos:jobPostings){
                    jobPostingIdToRecordId.put(jobPos.Name,jobPos.Id); 
                }
                
                for(JobApplicationRequest application:applications){
                    if(application.JobPostingId != null && application.LastName != null && application.Email!=null){
                        //Forming a Unique key to identify unique application per application
                        //this unique key is a combination of LastName, EmailId
                        //Assuming all Lastnames+EmailCombination are Unique
                        String uniqueNameKey = application.LastName+'-'+application.Email;
                        if(!applicantNameJobPostingsIds.containsKey(uniqueNameKey)){
                           applicantNameJobPostingsIds.put(uniqueNameKey,new List<String>());  
                        }
                        applicantNameJobPostingsIds.get(uniqueNameKey).add(application.JobPostingId);
                        //Form Contact Record using Utility Method in JobApplicationServiceUtility class
                        Contact applicant = JobApplicationServiceUtility.formContactRecord(application);
                        applicants.add(applicant);
                    }
                }
                if(!applicants.isEmpty()){
                    //Insert Applicants
                    insert applicants;
                    //Once Applicants are Inserted, we need to insert related Job Application Records
                    //Below Logic takes care of forming jobApplications records to be inserted
                    for(Contact con:applicants){
                        String uniqueKey = con.LastName+con.Email;
                        for(String JobPostingId:applicantNameJobPostingsIds.get(uniqueKey)){
                            Job_Application__c jobApplication = JobApplicationServiceUtility.formJobApplicationRecord(con.Id,jobPostingIdToRecordId.get(JobPostingId));
                            jobApplications.add(jobApplication);
                        }
                    }
                    if(!jobApplications.isEmpty()){
                        //Insert JobApplications as Bulk
                        insert jobApplications;
                    }
                }
            }
        }Catch(Exception e){
            //Handle Errors if any and send response to Website again
        }
    }
}