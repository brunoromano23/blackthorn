public class Contacts extends fflib_SObjectDomain {
    public Contacts(List<Contact> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Contacts(sObjectList);
        }
    }
    public List<Contact> getContacts()
	{
		return (List<Contact>) getRecords();
	}
    public Boolean checkIfContactExists(String email){
        for(Contact contact : getContacts()){
            if(contact.Email == email)
                return true;
        }
        return false;
    }
}