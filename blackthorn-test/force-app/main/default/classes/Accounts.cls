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

    public List<Account> addAccount(fflib_SObjectUnitOfWork uow, String firstName)
	{
        for(Account acc : (List<Account>) Records) {
            acc.Name = firstName;
            uow.registerNew(acc);

        }
        return Records;
       
	}

}