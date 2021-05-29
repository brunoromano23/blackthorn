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
    public List<Contact> addContact(fflib_SObjectUnitOfWork uow, String firstName, String lastName, String email, List<Account> accounts)
	{
        for(Contact ct : (List<Contact>) Records) {
            ct.FirstName = firstName;
			ct.LastName = lastName;
            ct.Email = email;
			ct.AccountId = accounts[0].Id;
            uow.registerNew(ct, Contact.AccountId, accounts[0]);
        } 

        return Records;
    }

}