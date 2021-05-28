@RestResource(urlMapping='/EventSubscription/*')
global with sharing class EventSubscription {
  @HttpPost
    global static String doPost() {
        RestRequest request = RestContext.request;
        ResponseService response = new ResponseService();
        try{
        	String jSONRequestBody = request.requestBody.toString();
            Id contactId;
            Id eventRelationId;
            RequestEventSubscription eventRequest = (RequestEventSubscription)JSON.deserializeStrict(jSONRequestBody, RequestEventSubscription.class);
           	List<Contact> contacts = new ContactsSelector().selectByEmails(new Set<String> { eventRequest.emailContact });
            if(contacts.size() == 0){
                Accounts domain = new Accounts(new List<Account>{new Account()});
				Contact contact = domain.addContact(eventRequest.firstNameContact, eventRequest.lastNameContact, eventRequest.emailContact);
                contactId = contact.Id;
            }
            else
                contactId = contacts.get(0).Id;
            
            Events domainEvent = new Events(new List<Event>{new Event()});
            List<EventRelation> eventsRelations = new EventsSelector().selectEventRelationsByEventAndContactId(eventRequest.eventId, contactId);
            if(eventsRelations.size() == 0){
                eventRelationId = domainEvent.addEventRelation(eventRequest.eventId, contactId, eventRequest.inviteAccepted);
            }
            else{
                eventRelationId = domainEvent.updateEventRelation(eventsRelations[0], eventRequest.inviteAccepted);
            }
   			response.eventId = eventRelationId;
            response.returnedMessage = 'Event subscription succeed!';
            
        }
        catch(Exception ex){
            response.returnedMessage = 'Error on service - ' + ex.getMessage();
        }
        return System.JSON.serialize(response);
        
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