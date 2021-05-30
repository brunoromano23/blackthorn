@isTest
public class PreventDuplicateLeadTest {
    @testSetup
    public static void testSetup(){
        Lead lead = new Lead();
        lead.Email = 'test@blackthorn.io';
        lead.LastName = 'test';
        lead.Company = 'blackthorn';
        insert lead;
        
        Lead lead2 = new Lead();
        lead2.Email = 'test2@blackthorn.io';
        lead2.LastName = 'test2';
        lead2.Company = 'blackthorn';
        insert lead2;
          
    }
	@isTest
    public static void TestDuplicateLead() {
        List<Lead> leads = [Select Id, Email from Lead];
        leads[0].Email = 'test2@blackthorn.io';
        Database.SaveResult result = Database.update(leads[0], false);
        System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('Duplicate Lead!',
                             result.getErrors()[0].getMessage());
    }
    @isTest
    public static void TestNewEmailLead() {
        List<Lead> leads = [Select Id, Email from Lead];
        leads[0].Email = 'test3@blackthorn.io';
        Database.SaveResult result = Database.update(leads[0], false);
        Lead l = [Select Id, Email From Lead Limit 1];
        system.assert(l.Email == 'test3@blackthorn.io');
        System.assert(result.isSuccess());
    }
}