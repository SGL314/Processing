class Wire extends Component {
	Wire(String type, float wid,int level, float px, float py) {
		super("wire", type, level, "xxx", px, py);
		//
		this.cor = "#000000";
		this.format = "polygon";
		this.wid = wid;
		this.tam = 2;
	}
	boolean show(String typeOfCrown,boolean canPut) {
		pre_showAsComponent(typeOfCrown,canPut);
		switch(this.type) {
			case "energy":
				rect(this.px-this.wid/2,this.py-this.hei/2,this.wid,this.tam);
				break;
			default:
				println("Level nao reconhecido de Wire: '" + this.level + "'");
		}
		pos_showAsComponent(typeOfCrown);
		return true;
	}

	Component copy() {
		return new Wire(this.type, this.wid,this.level, this.px, this.py);
	}
	String toString(){
		return this.id +";"+this.defaultToString();
	}
}