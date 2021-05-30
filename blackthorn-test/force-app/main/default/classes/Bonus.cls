public class Bonus extends TriggerHandler {
  	private static Bonus instance = null;
    public static Bonus getInstance(){
        
        if(instance == null) instance = new Bonus();
        return instance;
    }
    
    public override void afterInsert () {
        createBonusPayouts((Map<Id,Bonus__c>)Trigger.newMap);
    }
    
    private void createBonusPayouts(Map<Id,Bonus__c> mapBonus){
        List<BonusPayout__c> bonusPayouts = new List<BonusPayout__c>();
        
        for(Bonus__c bonus : mapBonus.values()){
            List<Date> dates = returnPayoutDates(bonus.Start__c, bonus.End__c);
            for(Date datePayout : dates){
                BonusPayout__c bonusPayout = new BonusPayout__c();
                bonusPayout.Bonus__c = bonus.Id;
                bonusPayout.Date__c = datePayout;
                bonusPayouts.add(bonusPayout);
            }
        }
        insert bonusPayouts;
    }
    private List<Date> returnPayoutDates(Date startDate, Date endDate){
        List<Date> dateRange = new List<Date>();

        while(startDate < endDate)
        {
           Date newDate = Date.newInstance(startDate.Year(), startDate.Month(), 1);
           dateRange.add(newDate);
           startDate = startDate.AddMonths(1);
        } 
        system.debug('startDate -> ' + startDate);
        if(startDate >= endDate){
            if(endDate.day() > 1){
               Date newDateFinal = Date.newInstance(endDate.Year(), endDate.Month(), 1);
               dateRange.add(newDateFinal);
            }
        }
        
        return dateRange;
    }
  
}