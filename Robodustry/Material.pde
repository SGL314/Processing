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
			case "silicon":
			case "water":
			// bola 4x4
				rect(px - 2 * tam / 8,py - 3 * tam / 8,4 * tam / 8,6 * tam / 8);
				rect(px - 3 * tam / 8,py - 2 * tam / 8,6 * tam / 8,4 * tam / 8);
				break;
			case "metal":
				// quadradinho no centro
				rect(px + tam / 4 - tam / 2,py + tam / 4 - tam / 2,tam / 2,tam / 2);
				break;
			case "glass":
				rect(px - 3 * tam / 8,py - tam / 2,6 * tam / 8,tam);
				rect(px - tam / 2,py - 3 * tam / 8,tam,6 * tam / 8);
				break;
			case "iron":
				case "bauxite":
				// minerio
				rect(px - 3 * tam / 8,py - 3 * tam / 8,tam / 4,tam / 4);
				rect(px - 2 * tam / 8,py - 2 * tam / 8,5 * tam / 8,tam / 4);
				rect(px - 3 * tam / 8,py,5 * tam / 8,3 * tam / 8);
				rect(px + tam / 4,py + 2 * tam / 8,1 * tam / 8,tam / 8);
				rect(px - tam / 8,py + 3 * tam / 8,3 * tam / 8,tam / 8);
				break;
			case "aluminium":
				// quadradinho no centro + bordas-borda de baixo
				rect(px - tam / 2,py - tam / 4,tam,tam / 2);
				rect(px - tam / 4,py - tam / 2,tam / 2,3 * tam / 4);
				break;
			case "coal":
				// redondo 3x3
				rect(px - 2 * tam / 8,py - 2 * tam / 8,3 * tam / 8,5 * tam / 8);
				rect(px - 3 * tam / 8,py - 1 * tam / 8,5 * tam / 8,3 * tam / 8);
				break;
			case "sand":
				// redondo 3x3
				rect(px - 1 * tam / 8,py - tam / 2,2 * tam / 8,7 * tam / 8);
				rect(px - 3 * tam / 8,py - 1 * tam / 8,6 * tam / 8,2 * tam / 8);
				rect(px - 2 * tam / 8,py + 1 * tam / 8,4 * tam / 8,1 * tam / 8);
				triangle(px - 3 * tam / 8,py - tam / 8,px - 1 * tam / 8,py - tam / 8,px - tam / 8,py - tam / 2);
				triangle(px + tam / 8,py - tam / 2,px + tam / 8,py - tam / 8,px + 3 * tam / 8,py - tam / 8);
				triangle(px - 3 * tam / 8,py + tam / 8,px - 2 * tam / 8,py + tam / 8,px - 2 * tam / 8,py + 3 * tam / 8);
				triangle(px + 2 * tam / 8,py + tam / 8,px + 3 * tam / 8,py + tam / 8,px + 2 * tam / 8,py + 3 * tam / 8);
				rect(px - 2 * tam / 8,py + 2 * tam / 8,4 * tam / 8,1 * tam / 8);
				break;
			case "uranium":
				case "thorium":
				// semi barra em pé
				// rect(px-tam/8,py-3*tam/8,2*tam/8,1*tam/8);
				rect(px - 2 * tam / 8,py - 2 * tam / 8,3 * tam / 8,6 * tam / 8);
				rect(px - 3 * tam / 8,py,5 * tam / 8,3 * tam / 8);
				break;
			case "copper":
			case "lead":
				triangle(px-tam/8,py-tam/2,px-tam/8,py+tam/8,px+tam/2,py+tam/8);
				triangle(px-tam/2,py-tam/8,px+tam/8,py-tam/8,px+tam/8,py+tam/2);
				rect(px-tam/4,py-tam/2,1*tam/8,3*tam/8);rect(px-tam/2,py-tam/4,3*tam/8,1*tam/8);
				rect(px+tam/8,py+tam/8,1*tam/8,3*tam/8);rect(px+tam/8,py+tam/8,3*tam/8,1*tam/8);
				break;
			case "titanium":
				// barra
				triangle(px - tam / 8,py - tam / 2,px - tam / 8,py + tam / 8,px + tam / 2,py + tam / 8);
				triangle(px - tam / 2,py - tam / 8,px + tam / 8,py - tam / 8,px + tam / 8,py + tam / 2);
				rect(px - tam / 4,py - tam / 2,1 * tam / 8,3 * tam / 8);rect(px - tam / 2,py - tam / 4,3 * tam / 8,1 * tam / 8);rect(px - 3 * tam / 8,py - 3 * tam / 8,1 * tam / 8,1 * tam / 8);
				rect(px + tam / 8,py + tam / 8,1 * tam / 8,3 * tam / 8);rect(px + tam / 8,py + tam / 8,3 * tam / 8,1 * tam / 8);rect(px + tam / 4,py + tam / 4,1 * tam / 8,1 * tam / 8);
				break;
			default:
			println("ERRO ao processar material:\n   id nao reconhecido: '" + id + "' in Material.show()");
		}
	}
	// water
	// iron
	// copper
	// lead
	// sand
	// coal
	// glass
	// silicon
	// thorium
	// uranium
	
	Material copy() {
		return new Material(this.name,this.id,this.cor);
	}
}