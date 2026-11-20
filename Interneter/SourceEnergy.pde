
class SourceEnergy extends Component {
	float sourceWatts= 0;
	SourceEnergy(String type, int level, float px, float py){
		super("source-energy", type, level, "xxx", px, py);
		//
		this.cor = "#00ffaa";
		this.wid = 20;
		this.hei = 20;
		this.format = "square";
		this.tam = this.wid;
		
		switch (this.level){
			case 1:
				this.sourceWatts = 100;
				break;
			default:
				println("Level nao reconhecido de SourceEnergy: '" + this.level + "'");
		}
		if (!dtbs.formingClasss) {
			Connector con = new Connector("energy",2,1,px,py);
			componentsToAdd.add(con);
			this.energysConnections.add(con);
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
		return new SourceEnergy(this.type, this.level, this.px, this.py);
	}

	String toString(){
		return this.id +";"+this.defaultToString();
	}

}