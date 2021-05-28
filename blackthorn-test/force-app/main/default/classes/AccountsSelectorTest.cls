@IsTest
private class AccountsSelectorTest 
{
	@testSetup
	private static void setupDataAccount()
	{
		// Test data
		Account acc = new Account();
		acc.Name = 'Person cool';
        insert acc;

    }
    @isTest
    public static void getAccountsByIdTest(){
		// Query
		List<Account> accsQuery = [Select Id, Name from Account];
	
		List<Account> accs = new AccountsSelector().selectById(new Set<Id> { accsQuery[0].Id });
	
		System.assertEquals(true, accs.size() > 0);
	
	}
}