class Memory extends Component {

  Memory(String type, int level, float px, float py) {
    super("memory", type, level, "xxx", px, py);
    //
    switch(this.type) {
    case "1":
      this.cor = "#00a2ff";
      this.wid = 10;
      this.hei = 10;
      this.format = "square";
      this.tam = this.wid;
      break;
    }
  }
	
	boolean show(String typeOfCrown,boolean canPut) {
		pre_showAsComponent(typeOfCrown,canPut);
		switch(this.type) {
			case "1":
				rect(this.px-this.wid/2,this.py-this.hei/2,this.wid,this.hei);
				break;
		}
		pos_showAsComponent(typeOfCrown);
		return true;
	}

	Component copy() {
		return new Memory(this.type,this.level,this.px,this.py);
	}
	String toString(){
		return this.id+";"+this.defaultToString();
	}
	
}
