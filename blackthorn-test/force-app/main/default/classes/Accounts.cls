public class Accounts extends fflib_SObjectDomain {
	public static IAccounts newInstance(List<Account> recordList)
	{
		return (IAccounts) Application.Domain.newInstance(recordList);
	}
	
	public static IAccounts newInstance(Set<Id> recordIdSet)
	{
		return (IAccounts) Application.Domain.newInstance(recordIdSet);
	}
    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public List<Account> getAccounts()
	{
		return (List<Account>) getRecords();
	}

    public Contact addContact(String firstName, String lastName, String email)
	{
        Account account = new Account();
        account.Name = firstName;
        insert account;
        Contact contact = new Contact();
        contact.FirstName = firstName;
        contact.LastName = lastName;
        contact.Email = email;
        contact.AccountId = account.Id;
        insert contact;
        return contact;
	}

}