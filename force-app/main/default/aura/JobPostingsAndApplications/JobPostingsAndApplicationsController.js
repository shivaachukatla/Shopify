({
    doInit: function (cmp, event, helper) {
        cmp.set('v.gridColumns', [
            {label: 'JobPosting Id', fieldName: 'Name', type: 'text'},
            {label: 'JobId', fieldName: 'Job_Id__c', type: 'text'},
            {label: 'ApplicantName', fieldName: 'Applicant_Name__c', type: 'text'},
            {label: 'ApplicantStatus', fieldName: 'Application_Status__c', type: 'text'}
            ]);
        helper.getJobPostingsWithApps(cmp);
    }
})