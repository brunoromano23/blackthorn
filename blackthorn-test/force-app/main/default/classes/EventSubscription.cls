@RestResource(urlMapping='/EventSubscription/*')
global with sharing class EventSubscription {
  @HttpPost
    global static String doPost() {
        RestRequest request = RestContext.request;
        ResponseService response = new ResponseService();
        try{
			fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(new Schema.SObjectType[] { Account.SObjectType, Contact.SObjectType, EventRelation.SObjectType });
			String jSONRequestBody = request.requestBody.toString();
			RequestEventSubscription eventRequest = (RequestEventSubscription)JSON.deserializeStrict(jSONRequestBody, RequestEventSubscription.class);

            Contact contact = RegisterAccountContact(uow, eventRequest);
			Id eventRelationId = RegisterContactInEvent(uow, eventRequest, contact);
			uow.commitWork();
   			response.eventId = eventRelationId;
            response.returnedMessage = 'Event subscription succeed!';
            
        }
        catch(Exception ex){
            response.returnedMessage = 'Error on service - ' + ex.getMessage();
        }
        return System.JSON.serialize(response);
        
    }
    private static Contact RegisterAccountContact(fflib_SObjectUnitOfWork uow, RequestEventSubscription eventRequest){
        List<Contact> contacts = new ContactsSelector().selectByEmails(new Set<String> { eventRequest.emailContact });
        if(contacts.size() == 0){
            Accounts domainAccounts = new Accounts(new List<Account>{new Account()});
            List<Account> accounts = domainAccounts.addAccount(uow, eventRequest.firstNameContact);
            Contacts domainContacts = new Contacts(new List<Contact>{new Contact()});
            List<Contact> contactsInserted = domainContacts.addContact(uow, eventRequest.firstNameContact, eventRequest.firstNameContact, 
                                                                       eventRequest.emailContact, accounts);
            
            return contactsInserted[0];
        }
        else
            return contacts.get(0);
    }
    
    private static Id RegisterContactInEvent(fflib_SObjectUnitOfWork uow, RequestEventSubscription eventRequest, Contact contact){
        List<EventRelation> eventsRelations = new EventsSelector().selectEventRelationsByEventAndContactId(eventRequest.eventId, contact.Id);
        List<EventRelation> eventsRelationsSubscription = new List<EventRelation>();
        if(eventsRelations.size() == 0){
            EventRelations domainEventRelation = new EventRelations(new List<EventRelation>{new EventRelation()});
            eventsRelationsSubscription = domainEventRelation.addEventRelation(uow, contact, eventRequest.eventId, eventRequest.inviteAccepted);
        }
        else{
            EventRelations domainEventRelation = new EventRelations(eventsRelations);
            eventsRelationsSubscription = domainEventRelation.updateEventRelation(uow, eventRequest.inviteAccepted);
        }
        return eventsRelationsSubscription[0].Id;
    }
    
    global class RequestEventSubscription{
        global String firstNameContact {get;set;}
        global String lastNameContact {get;set;}
        global String emailContact {get;set;}
        global String eventId {get;set;}
        global Boolean inviteAccepted {get;set;}
    }
    global class ResponseService{ 
        global String eventId {get;set;}
        global String returnedMessage {get;set;}
    }
}