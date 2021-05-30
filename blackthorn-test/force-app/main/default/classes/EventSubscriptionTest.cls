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
        
        EventRelation evtRelation = new EventRelation();
        evtRelation.EventId = event.Id;
        evtRelation.IsInvitee = true;
        evtRelation.IsWhat = false;
       	evtRelation.RelationId = contact.Id;
        evtRelation.IsParent = false;
        evtRelation.Status = 'New';
        insert evtRelation;
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
        List<AcceptedEventRelation > lstEvtRelationAccepted = [SELECT Id, RelationId, Relation.Email from AcceptedEventRelation  Where RelationId =: contacts[0].Id];
        system.assert(contacts.size() > 0);
        system.assert(lstEvtRelationAccepted.size() > 0);

    }
        @isTest 
    static void inviteeDeclinedNewInviteeTest(){
        Event evt = [Select id from Event limit 1];
        String jsonRequest = '{"firstNameContact": "contact","lastNameContact": "3333","emailContact": "contact3@contact.com","eventId": "'+ evt.Id +'","inviteAccepted" : false}';
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
        List<DeclinedEventRelation> lstEvtRelationDeclined = [SELECT Id, RelationId, Relation.Email from DeclinedEventRelation Where RelationId =: contacts[0].Id];
        system.assert(contacts.size() > 0);
        system.assert(lstEvtRelationDeclined.size() > 0);

    }
    @isTest 
    static void inviteeAcceptedExistingInviteeTest(){
        Event evt = [Select id from Event limit 1];
        String jsonRequest = '{"firstNameContact": "blackthorncontact","lastNameContact": "One","emailContact": "test@blackthorn.com","eventId": "'+ evt.Id +'","inviteAccepted" : true}';
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
        List<Contact> contacts = [Select Id, Email From Contact where Email = 'test@blackthorn.com'];
        List<AcceptedEventRelation > lstEvtRelationAccepted = [SELECT Id, RelationId, Relation.Email from AcceptedEventRelation Where RelationId =: contacts[0].Id];
        system.assert(contacts.size() > 0);
        system.assert(lstEvtRelationAccepted.size() > 0);

    }
        @isTest 
    static void inviteeDeclinedExistingInviteeTest(){
        Event evt = [Select id from Event limit 1];
        String jsonRequest = '{"firstNameContact": "blackthorncontact","lastNameContact": "One","emailContact": "test@blackthorn.com","eventId": "'+ evt.Id +'","inviteAccepted" : false}';
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
        List<Contact> contacts = [Select Id, Email From Contact where Email = 'test@blackthorn.com'];
        List<DeclinedEventRelation> lstEvtRelationDeclined = [SELECT Id, RelationId, Relation.Email from DeclinedEventRelation Where RelationId =: contacts[0].Id];
        system.assert(contacts.size() > 0);
        system.assert(lstEvtRelationDeclined.size() > 0);

    }
}