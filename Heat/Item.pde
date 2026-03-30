class Item{
	float px,py,tam;
	String type;
	
	float temp = 0;
	boolean selected = false;
	
	Item(String type,float px,float py,float tam) {
		this.type = type;
		this.tam = tam;
		this.px = px;
		this.py = py;
	}
	
	void show(int loop) {
		float[] temps = {0,this.temp,250};
		int[] cor = {0,0,0,0};
		switch(this.type) {
			case "air":
				int[] a = {175,198,255};
			int[] b = {255,91,36};
			cor = colorama(temps,a,b);
			break;
		}
		fill(cor[0],cor[1],cor[2],cor[3]);
		// selected
		int a = 100;
		if (this.selected) {
			if (loop % a < a / 3) {
				fill(#ff0000);
			} else if (loop % a < 2*a / 3) {
				fill(#00ff00);
			} else if (loop % a < a) {
				fill(#0000ff);
			}
		}
		
		//
		rect(px,py,tam,tam);
	}
	
	void log() {
		
	}
	//
	int[] colorama(float[] temps,int[] a,int[] b) {
		int alpha = 255;
		float vari = (temps[1] - temps[0]) / (temps[2] - temps[0]);
		int[] alphas = {255,255};
		if (a.length == 4) {
			alphas[0] = a[3];
		}
		if (b.length == 4) {
			alphas[1] = b[3];
		}
		int[]ret = {
			(int)(a[0] + (b[0] - a[0]) * vari),
				(int)(a[1] + (b[1] - a[1]) * vari),
				(int)(a[2] + (b[2] - a[2]) * vari),
				(int)(alphas[0] + (alphas[1] - alphas[0]) * vari)
			};
		return ret;
	}
	void flowHeat(Item neigh) {
		float temp = (neigh.temp - this.temp) / 2;
		neigh.temp -= temp / 2;
		this.temp += temp / 2;
	}
}