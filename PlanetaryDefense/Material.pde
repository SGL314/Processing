class Material {
	String name,id;
	float tam,px,py;
	color cor;
	Material(String name,String id,color cor) {
		this.name = name;
		this.tam = 8;
		this.id = id;
		this.cor = cor;
	}
	
	void show() {
		noStroke();
		fill(cor);
		switch(id) {
			case "metal":
				// quadradinho no centro
				rect(px + tam / 4 - tam / 2,py + tam / 4 - tam / 2,tam / 2,tam / 2);
				break;
			case "aluminium":
				// quadradinho no centro + bordas-borda de baixo
				rect(px - tam / 2,py - tam / 4,tam,tam / 2);
				rect(px - tam / 4,py - tam / 2,tam / 2,3 * tam / 4);
				break;
			// case "titanium":
			// 	println("Titanium");
			// 	break;
			default:
			println("ERRO ao processar material:\n   id nao reconhecido: '" + id + "'");
		}
	}
	
	Material copy() {
		return new Material(this.name,this.id,this.cor);
	}
}