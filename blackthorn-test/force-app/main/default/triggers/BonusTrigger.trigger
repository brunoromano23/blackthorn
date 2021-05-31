trigger BonusTrigger on Bonus__c (after insert) {
	new Bonus().run();
}