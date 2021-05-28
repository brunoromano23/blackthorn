public class Application {
public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
		new fflib_Application.UnitOfWorkFactory(
				new List<SObjectType> {
					Account.SObjectType,
					Contact.SObjectType,
					Event.SObjectType});	


	// Configure and create the SelectorFactory for this Application
	public static final fflib_Application.SelectorFactory Selector = 
		new fflib_Application.SelectorFactory(
			new Map<SObjectType, Type> {
					Account.SObjectType => AccountsSelector.class,
					Contact.SObjectType => ContactsSelector.class });

	// Configure and create the DomainFactory for this Application
	public static final fflib_Application.DomainFactory Domain = 
		new fflib_Application.DomainFactory(
			Application.Selector,
			new Map<SObjectType, Type> {
					Account.SObjectType => Accounts.Constructor.class,
					Event.SObjectType => Events.Constructor.class });
}