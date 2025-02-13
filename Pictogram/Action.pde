class Action{
    boolean threw = false,repeat=false; // ,done = false

    String name;
    Action(String name){
        this.name = name;
    }

    void throwAction(boolean repeat){
        this.threw = true;
        this.repeat = repeat;
    }
}