public class JobApplicationServiceUtility {
    public static Contact formContactRecord(JobApplicationRequest application){
        Contact applicant = new Contact(
                                       FirstName = application.FirstName,
                                       LastName = application.LastName,
                                       Email = application.Email,
                                       MailingStreet = application.MailingStreet,
                                       MailingCity = application.MailingCity,
                                       MailingState = application.MailingState,
                                       MailingCountry = application.MailingCountry,
                                       MailingPostalCode = application.MailingPostalCode,
                                       MobilePhone = application.MobilePhone
                                    );
        return applicant;
    }
    public static Job_Application__c formJobApplicationRecord(Id ApplicantId,Id JobPostingId){
     	Job_Application__c jobApplication = new Job_Application__c(
                                                        Applicant__c = ApplicantId,
                                                        Application_Status__c = 'Review',
                                                        Job_Posting__c = JobPostingId
                                                    );   
        return jobApplication;
    }
}