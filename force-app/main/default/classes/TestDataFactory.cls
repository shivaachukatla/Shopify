@isTest
public class TestDataFactory {
    public static list<Account> createDepartments(Integer numDepts){
        List<Account> departments = new List<Account>();
        for(Integer i=0;i<numDepts;i++) {
            Account a = new Account(Name='TestDepartment' + i);
            departments.add(a);
        }
        insert departments;
        return departments;
    }
    public static list<Job__c> createJobs(Integer numJobs){
        List<Job__c> jobs = new List<Job__c>();
        for(Integer i=0;i<numJobs;i++) {
            Job__c job = new Job__c(Title__c='Testtitle' + i,Status__c='Active',
                                    Job_Description__c='TestDescription' +i ,Salary__c=10000+i);
            jobs.add(job);
        }
        insert jobs;
        return jobs;
    }
    public static List<Contact> createApplicants(Integer numApplicants){
        List<Contact> applicants = new List<Contact>();
        for(Integer i=0;i<numApplicants;i++) {
            Contact con = new Contact(FirstName='test'+i,LastName='testlast'+i,Email='test'+i+'@gmail.com',
                                     MailingStreet='testStreet'+i,MailingCity='testCIty'+i,MailingState='testState'+i,
                                     MailingCountry='USA',MailingPostalCode='27513');
            applicants.add(con);
        }
        insert applicants;
        return applicants;
    }
    public static List<Job_Posting__c> createJobPostings(list<Job__c> jobs,list<Account> departments ){
        List<Job_Posting__c> jobPostings = new List<Job_Posting__c>();
        for(Job__c j: jobs){
            for(Account a:departments){
                jobPostings.add(new Job_Posting__c(Department__c=a.Id,Job__c=j.Id));
            } 
        }
        insert jobPostings;
        return jobPostings;
    }
    public static List<Job_Application__c> createJobApplications(List<Job_Posting__c> postings,List<Contact> Applicants){
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();
        for(Job_Posting__c pos:postings){
            for(Contact con:Applicants){
                jobApplications.add(new Job_Application__c(Applicant__c=con.Id,Application_Status__c='Review',Job_Posting__c=pos.Id));
            } 
        }
        insert jobApplications;
        return jobApplications;
    }
}