public virtual class TriggerHandler {
    // static map of handlername, times run() was invoked
    private static Map<String, LoopCount> loopCountMap;
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private TriggerContext context;
    
    // the current context of the trigger, overridable in tests
    @TestVisible
    private Boolean isTriggerExecuting;
    
    // constructor
    public TriggerHandler() {
        this.setTriggerContext();
    }
    
    public static Integer getLoopCount (String handlerName) {
        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
            return TriggerHandler.loopCountMap.get(handlerName).getCount();
        }
        return 0;
    }
    
    // main method that will be called during execution
    public void run () {
        
        if (!validateRun()) return;
        
        addToLoopCount();
        
        // dispatch to the correct handler method - only before update needs
        if (this.context == TriggerContext.BEFORE_UPDATE) {
            this.beforeUpdate();
        }
        if (this.context == TriggerContext.AFTER_INSERT) {
            this.afterInsert();
        }
        if (this.context == TriggerContext.BEFORE_INSERT) {
            this.beforeInsert();
        }
    }
    
     // static initialization
    static {
        loopCountMap = new Map<String, LoopCount>();
    }
    // increment the loop count
    @TestVisible
    private void addToLoopCount () {
        String handlerName = getHandlerName();
        if (TriggerHandler.loopCountMap.containsKey(handlerName)) {
            Boolean exceeded = TriggerHandler.loopCountMap.get(handlerName).increment();
            if (exceeded) {
                Integer max = TriggerHandler.loopCountMap.get(handlerName).max;
                throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + handlerName);
            }
        }
    }
    
    @TestVisible
    private void setTriggerContext () {
        this.setTriggerContext(null, false);
    }
    
    @TestVisible
    private void setTriggerContext (String ctx, Boolean testMode) {
        if (!Trigger.isExecuting && !testMode) {
            this.isTriggerExecuting = false;
            return;
        } else {
            this.isTriggerExecuting = true;
        }
        if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) || (ctx != null && ctx == 'before update')){
                this.context = TriggerContext.BEFORE_UPDATE;
        }
    	if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) || (ctx != null && ctx == 'after insert')){
                this.context = TriggerContext.AFTER_INSERT;
        }
		if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) || (ctx != null && ctx == 'before insert')){
                this.context = TriggerContext.BEFORE_INSERT;
        }
    system.debug('this.context -> ' + this.context);
}
    
    
    @TestVisible
    private Boolean validateRun () {
        if (!this.isTriggerExecuting || this.context == null) {
            throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
        }
        return true;
    }
    
    @TestVisible
    private String getHandlerName () {
        return String.valueOf(this).substring(0, String.valueOf(this).indexOf(':'));
    }
    
    @TestVisible
    protected virtual void beforeUpdate () {}
    
     @TestVisible
    protected virtual void afterInsert () {}
    
    @TestVisible
    protected virtual void beforeInsert () {}
    
    // inner class for managing the loop count per handler
    @TestVisible
    private class LoopCount {
        private Integer max;
        private Integer count;
        
        public LoopCount() {
            this.max = 5;
            this.count = 0;
        }
        
        public LoopCount(Integer max) {
            this.max = max;
            this.count = 0;
        }
        
        public Boolean increment() {
            this.count++;
            return this.exceeded();
        }
        
        public Boolean exceeded() {
            if (this.max < 0) return false;
            if (this.count > this.max) {
                return true;
            }
            return false;
        }
        
        public Integer getMax() {
            return this.max;
        }
        
        public Integer getCount() {
            return this.count;
        }
        
        public void setMax(Integer max) {
            this.max = max;
        }
    }
    
    // possible trigger contexts
    @TestVisible
    private enum TriggerContext {
        BEFORE_UPDATE,
        AFTER_INSERT,
        BEFORE_INSERT
            }
    
    // exception class
    public class TriggerHandlerException extends Exception {}
}