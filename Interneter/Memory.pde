class Memory extends Component{
	
	Memory(String name,String type,int level,float px,float py) {
		super(name,type,level,px,py);
		//
		switch(this.type) {
			case "1":
				this.cor = "#00a2ff";
				this.wid = 10;
				this.hei = 10;
				break;
		}
	}
	
	boolean show() {
		fill(unhex("FF" + this.cor.substring(1)));
		switch(this.type) {
			case "1":
				rect(this.px,this.py,this.wid,this.hei);
				break;
		}
		return true;
	}
}