trigger OpportunityTrigger on Opportunity (before insert, before update) {
    Id recordTypeRenewalID = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
    List<Id> listIds = new List<Id>();
    for(Opportunity p : Trigger.New){
		listIds.add(p.AccountId);
    }
	Map<id,Account> mapAccounts=new Map<id,Account>([select id, CustomField__c from Account where id=:listIds]);

    for(Opportunity p : Trigger.New){
		Account acc = mapAccounts.get(p.AccountId);
        system.debug(acc.CustomField__c);
        if(p.CloseDate < System.Today()){
            p.StageName='Closed';
            p.RecordTypeId = recordTypeRenewalID;                      
		}
        p.CustomField__c = acc.CustomField__c;
    }
}