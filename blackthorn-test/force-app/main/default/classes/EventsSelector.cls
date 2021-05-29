public class EventsSelector extends fflib_SObjectSelector
{
    public Schema.SObjectType getSObjectType(){
        return Event.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Event.Id
                };
    }

    public List<Event> selectById(Set<Id> idSet)
    {
        return (List<Event>) selectSObjectsById(idSet);
    }
   
    public List<EventRelation> selectEventRelationsByEventAndContactId(Id eventID, Id contactId){
        List<EventRelation> whoRelations = [SELECT Id, Relation.Name, isParent, isinvitee, iswhat 
                                            FROM EventRelation Where EventId =: eventID AND isParent = true AND isWhat = false
                                           	AND RelationId =: contactId];
        return whoRelations;
    }
}