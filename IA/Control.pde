class Control{
    boolean runningDownPersons,runningLiving,runThreads = true;
    Control(){

    }
    boolean runningAnyThreads(){
        return this.runningDownPersons || this.runningLiving;
    }
    void re_runThreads(){  
        thread("downPersons");
        thread("living");
    }
    boolean runningAllThreads(){
        return this.runningDownPersons && this.runningLiving;
    }
}