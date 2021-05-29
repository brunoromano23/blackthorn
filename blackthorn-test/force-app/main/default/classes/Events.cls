public class Events extends fflib_SObjectDomain {
    public Events(List<Event> sObjectList) {
        super(sObjectList);
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Events(sObjectList);
        }
    }
    public List<Event> getEvents()
	{
		return (List<Event>) getRecords();
	}
}