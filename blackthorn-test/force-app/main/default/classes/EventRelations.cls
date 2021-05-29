public class EventRelations extends fflib_SObjectDomain {
    public EventRelations(List<EventRelation> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new EventRelations(sObjectList);
        }
    }
    public List<EventRelation> addEventRelation(fflib_SObjectUnitOfWork uow, Contact contact, Id eventId, Boolean inviteAccepted)
	{
        for(EventRelation evt : (List<EventRelation>) Records) {
            evt.EventId = eventId;
            evt.IsInvitee = true;
            evt.IsWhat = false;
            evt.RelationId = contact.Id;
            evt.IsParent = inviteAccepted;
            uow.registerNew(evt, EventRelation.RelationId, contact);
        }
        return Records;
	}
    public List<EventRelation> updateEventRelation(fflib_SObjectUnitOfWork uow, Boolean inviteAccepted)
	{
        for(EventRelation evt : (List<EventRelation>) Records) {
            evt.IsParent = inviteAccepted;
            uow.registerDirty(evt);
        }
        return Records;
	}
}