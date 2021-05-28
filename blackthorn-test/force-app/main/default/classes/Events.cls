public class Events extends fflib_SObjectDomain {
    public Events(List<Event> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Events(sObjectList);
        }
    }
    public Id addEventRelation(Id contactId, Id eventId, Boolean inviteAccepted)
	{
        EventRelation eventRelation = new EventRelation();
        eventRelation.EventId = eventId;
        eventRelation.IsInvitee = true;
        eventRelation.IsWhat = false;
        eventRelation.RelationId = contactId;
        eventRelation.IsParent = inviteAccepted;
        insert eventRelation;
        return eventRelation.Id;
	}
    public Id updateEventRelation(EventRelation eventRelation, Boolean inviteAccepted)
	{
        eventRelation.IsInvitee = true;
        eventRelation.IsParent = inviteAccepted;
        update eventRelation;
        return eventRelation.Id;
	}
  
}