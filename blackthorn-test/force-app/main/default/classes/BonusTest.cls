@isTest
public class BonusTest {
	@isTest
    public static void TestLoadBonusAndBonusPayouts() {
    	Bonus__c bonus = new Bonus__c();
        bonus.Start__c = Date.newInstance(2021, 1, 15);
		bonus.End__c = Date.newInstance(2021, 6, 10);
	    insert bonus;
        

        List<BonusPayout__c> datesPayouts = [Select Date__c from BonusPayout__c Where Bonus__c =: bonus.Id Order by Date__c];
		date minDate = datesPayouts.get(0).Date__c;
		date maxDate = datesPayouts.get(datesPayouts.size()-1).Date__c;

		system.assert(bonus.Start__c.month() == minDate.month());
        system.assert(bonus.End__c.month() == maxDate.month());
    }
    @isTest
    public static void TestLoadBonusAndBonusPayouts2() {
    	Bonus__c bonus = new Bonus__c();
        bonus.Start__c = Date.newInstance(2021, 1, 15);
		bonus.End__c = Date.newInstance(2021, 6, 1);
	    insert bonus;
        

        List<BonusPayout__c> datesPayouts = [Select Date__c from BonusPayout__c Where Bonus__c =: bonus.Id Order by Date__c];
		date minDate = datesPayouts.get(0).Date__c;
		date maxDate = datesPayouts.get(datesPayouts.size()-1).Date__c;

		system.assert(bonus.Start__c.month() == minDate.month());
        system.assert(bonus.End__c.month()-1 == maxDate.month());
    }
}