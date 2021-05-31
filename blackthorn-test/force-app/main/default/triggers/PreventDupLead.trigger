Trigger PreventDupLead on Lead(before update) {
    Set <String> emailSet = new Set<String>();
    for (Lead newLead: trigger.new) {
    	emailSet.add(newLead.email);
    }
    List <Lead> leadList = new List<Lead>();
	leadList = [SELECT Id, Email FROM Lead WHERE Email IN :emailSet];

    for (Lead lead:trigger.new) {
        If (leadList.size() > 0) {
        	lead.email.adderror( 'Duplicate Lead!' );
        }
    }
}