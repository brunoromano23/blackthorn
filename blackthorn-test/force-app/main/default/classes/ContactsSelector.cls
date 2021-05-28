public class ContactsSelector extends fflib_SObjectSelector {
   public Schema.SObjectType getSObjectType(){
      return Contact.sObjectType;
   }
 
   public List<Schema.SObjectField> getSObjectFieldList(){
      return new List<Schema.SObjectField> {
         Contact.Id,
         Contact.FirstName,
         Contact.LastName,
         Contact.Email,
         Contact.AccountId
      };
   }
    public List<Contact> selectByEmails(Set<String> emails){
        fflib_QueryFactory query = newQueryFactory();
         
        query.setCondition('Email IN :emails');
      	return (List<Contact>) Database.query( query.toSOQL() );
    }
}