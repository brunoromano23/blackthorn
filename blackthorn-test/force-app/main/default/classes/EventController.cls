public inherited sharing class EventController {    
    @AuraEnabled(cacheable=true)
    public static list<AcceptedEventRelation> retrieveEventsAcceptedContact(Id accountId) {
        List<Contact> contact = [Select Id From Contact Where AccountId =: accountId];
        return [SELECT Id, RelationId, Event.StartDateTime, Event.EndDateTime, Event.Subject 
                FROM AcceptedEventRelation Where RelationId =: contact[0].Id];
    }
}