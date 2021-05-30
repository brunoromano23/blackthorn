@isTest
public class OpportunityUpdateTest {
	@isTest static void TestUpdateOpportunityHasClosedWithAccount() {
            Id recordTypeRenewalID = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Renewal').getRecordTypeId();

        Account acct = new Account(Name='Test Account');
        acct.CustomField__c = 'CFAccount';
        insert acct;
        Test.startTest();
        Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                       StageName='New',
                                       CloseDate=System.today().addDays(-1),
                                       AccountId=acct.Id);
        insert opp;
        
        Test.stopTest();
        Opportunity oppt = [Select Id, CustomField__c, RecordTypeId, StageName From Opportunity Limit 1];
        System.assert(oppt.CustomField__c == 'CFAccount');
        System.assert(oppt.RecordTypeId == recordTypeRenewalID);
        System.assert(oppt.StageName == 'Closed');
      
    }
    @isTest static void TestUpdateOpportunityHasNotClosedWithAccount() {
            Id recordTypeRenewalID = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('New').getRecordTypeId();

        Account acct = new Account(Name='Test Account');
        acct.CustomField__c = 'CFAccount';
        insert acct;
        Test.startTest();
        Opportunity opp = new Opportunity(Name=acct.Name + ' Opportunity',
                                       StageName='New',
                                       CloseDate=System.today().addDays(1),
                                       AccountId=acct.Id);
        insert opp;
        
        Test.stopTest();
        Opportunity oppt = [Select Id, CustomField__c, RecordTypeId, StageName From Opportunity Limit 1];
        System.assert(oppt.CustomField__c == 'CFAccount');
        System.assert(oppt.RecordTypeId == recordTypeRenewalID);
        System.assert(oppt.StageName == 'New');
      
    }
}