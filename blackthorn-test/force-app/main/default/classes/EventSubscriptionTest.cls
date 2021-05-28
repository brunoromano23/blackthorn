@isTest
private class EventSubscriptionTest {
	@testSetup
    public static void testSetup(){
        Account account = new Account();
        account.Name = 'test';
        insert account;
        Contact contact = new Contact();
        contact.FirstName = 'test';
        contact.LastName = 'blackthorn';
        contact.Email = 'test@blackthorn.com';
        contact.AccountId = account.Id;
        insert contact;
        
        Event event = new Event(
		OwnerId = UserInfo.getUserId(),
		StartDateTime = DateTime.now(),
		EndDateTime = DateTime.now().addHours(1),
		Subject = 'Event blackthorn'
		);
		insert event;
    }
    @isTest 
    static void inviteeAcceptedNewInviteeTest(){
        Event evt = [Select id from Event limit 1];
        String jsonRequest = '{"firstNameContact": "contact","lastNameContact": "3333","emailContact": "contact3@contact.com","eventId": "'+ evt.Id +'","inviteAccepted" : true}';
        RestRequest req = new RestRequest();   
        RestResponse res = new RestResponse();
 		test.startTest();         
        req.addHeader('Content-Type', 'application/json');  
        req.requestBody = Blob.valueOf(jsonRequest);
        req.requestURI = system.URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/EventSubscription/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        String response = EventSubscription.doPost();
		test.stopTest();         
        List<Contact> contacts = [Select Id, Email From Contact where Email = 'contact3@contact.com'];
        List<EventRelation> lstEvtRelation = [SELECT Id, RelationId, Relation.Email from EventRelation Where RelationId =: contacts[0].Id];
        system.assert(contacts.size() > 0);
        system.assert(lstEvtRelation.size() > 0);

    }
}