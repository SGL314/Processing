abstract class Component {
	String name;
	String type;
	String cor;
	int level;
	float wid, hei;
	float px,py;
	Component(String name,String type,int level,float px, float py){
		this.name = name;
		this.type = type;
		this.level = level;
		this.px = px;
		this.py = py;
	}

	abstract boolean show();
}