@IsTest
private class ContactsSelectorTest 
{
	@testSetup
	private static void setupDataContact()
	{
		// Test data
		Account acc = new Account();
		acc.Name = 'Person cool';
        insert acc;
        Contact contact = new Contact();
		contact.FirstName = 'Contact Person';
		contact.LastName = 'Cool';
        contact.Email = 'contactcool@cool.com';
		contact.AccountId = acc.Id;
		insert contact;
    }
    @isTest
    public static void getContactsByEmailTest(){
		// Query
		List<Contact> contactsQuery = [Select Id, Email from Contact];
		ContactsSelector contactSelector = new ContactsSelector();
		List<Contact> contacts = contactSelector.selectByEmails(new Set<String> { contactsQuery[0].Email });
	
		System.assertEquals(true, contacts.size() > 0);
		System.assertEquals('contactcool@cool.com', contacts[0].Email);		
	
	}
}