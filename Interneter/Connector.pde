class Connector extends Component {
	Connector(String type, float raw,int level, float px, float py) {
		super("connector", type, level, "xxx", px, py);
		//
		this.cor = "#00b4cc";
		this.format = "circle";
		this.raw = raw;
	}
	boolean show(String typeOfCrown,boolean canPut) {
		pre_showAsComponent(typeOfCrown,canPut);

		switch(this.type) {
			case "energy":
				circle(this.px,this.py,this.raw*2);
				break;
			default:
				println("Type nao reconhecido de Connector: '" + this.type + "'");
		}
		pos_showAsComponent(typeOfCrown);
		return true;
	}

	Component copy() {
		return new Connector(this.type, this.raw,this.level, this.px, this.py);
	}
	String toString(){
		return this.id + ";" + this.raw +";"+this.defaultToString();
	}
}