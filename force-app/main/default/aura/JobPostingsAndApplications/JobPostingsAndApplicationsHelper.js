({
    getJobPostingsWithApps : function (cmp) {
        var recordId = cmp.get("v.recordId");
        var action = cmp.get("c.getJobPostingsAlongWithApplicationDetails");
        action.setParams({ departmentId : recordId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                //Change "Applications" key to "_children"
                for(var i=0; i<data.length; i++) {
                    data[i]._children = data[i]['Job_Applications__r'];
                    delete data[i].Job_Applications__r;
                }
                cmp.set('v.gridData', data);
            }
            // error handling when state is "INCOMPLETE" or "ERROR"
         });
         $A.enqueueAction(action);
    }
})