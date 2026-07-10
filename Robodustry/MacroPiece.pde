class MacroPiece extends Piece {
	Piece piecePivot;
	Float angle = 0f,stepAngle = 90f;
	public ArrayList<Piece> pieces = new ArrayList<Piece>();
	public float[][] points_construit = new float[0][0];
	
	
	MacroPiece(String name,String id,float tam,Material material,float px,float py,LinkedHashMap<Material,Float> mats,ArrayList<Piece> pieces) {
		super(name,id,tam,material,px,py,mats);
		super.type = "Mp";
		this.piecePivot = pieces.get(0);
		piecePivot.px = px;
		piecePivot.py = py;
		println("Mp criado varias vezes ... MacroPiece()");
		this.pieces = pieces;
		defineInitialDefinitions();
		definePointsConstruit();
	}
	void defineInitialDefinitions() {
		switch(id) {
			case "collector" : // Collector
				// rect(px,py,tam,tam);
				angle = 0f;
				stepAngle = 45f;
				scaleShow = 0.5f;
				break;
			default:
			println("ERRO ao definir macro piece:\n   type '" + id + "' is not a type of piece MacroPiece.defineInitialDefinitions()");
		}
	}
	void definePointsConstruit() {
		switch(id) {
			case "collector" : // Collector
				// rect(px,py,tam,tam);
				float[][] p1 = {
					{0,0,0+tam*3/2,0-tam*3/2,0+tam*3/2,0+tam*3/2}, // triangle
					{0,0-tam / 2,
					tam / 2,-tam/2,
					tam/2,tam/2,
					0,tam/2}, // rect
					{0 + tam*7/2, 0} // arc
				};
				float[][] p2 = new float[p1.length][8];
				float rad = angle/180*PI;
				// transform by angle
				for (int i = 0; i < p1.length; i++) {
					for (int j = 0; j < p1[i].length; j+=2) {
						p2[i][j] = p1[i][j]*cos(rad) + p1[i][j+1]*sin(rad);
						p2[i][j+1] = -p1[i][j]*sin(rad) + p1[i][j+1]*cos(rad);
					}
				}
				points_construit = p2;
				// define points to detect collision
				super.points = new float[6][2];
				float[][] pts ={
					{0,-tam/2},
					{0+tam/2,-tam/2},
					{0+tam/2+tam,-tam/2-tam},
					{0+tam/2+tam,+tam/2+tam},
					{0+tam/2,+tam/2},
					{0,+tam/2}
					};
					for (int i = 0; i < pts.length; i++) {
						super.points[i][0] = px+pts[i][0]*cos(rad) + pts[i][1]*sin(rad);
						super.points[i][1] = py-pts[i][0]*sin(rad) + pts[i][1]*cos(rad);
					}
				break;
			default:
			println("ERRO ao definir macro piece:\n   type '" + id + "' is not a type of piece MacroPiece.definePointsConstruit()");
		}
	}
	void rotate(){
		angle += stepAngle;
		if (angle >= 360) angle -= 360;
		definePointsConstruit();
	}
	void show(String modus,boolean what) {
		switch(modus) {
			case "canPut":
				_show(what);
				break;
		}
	}
	void show() {
		_show(true);
	}
	protected void _show(boolean canPut) {
		px = piecePivot.px;py = piecePivot.py;
		// refat by pieces
		for (Piece piece : pieces) {
			this.selected |= piece.selected;
			this.shined |= piece.shined;
			this.negativeShined |= piece.negativeShined;
		}
		//
		color corNow = material.cor;
		if (onHandConstruction ==  this) _showMaterials();
		if (!canPut || this.negativeShined) {
			corNow = colorCannotPut;
		}
		else if (selected && shined) {
			corNow = color(128,255,0,192);
		}
		else if (selected) {
			corNow = color(255,255,0,128);
		}
		else if (shined) {
			corNow = color(0,255,0,128);
		}
		stroke(1); // stroke here
		if (hide) {
			noStroke();
			corNow = color(corNow,32);
		}
		fill(corNow);
		switch(id) {
			case "collector" : // Collector
				// rect(px,py,tam,tam);
				float angAberturaS2 = 36.86989765/ 180 * PI; // abertura sobre 2
				triangle(px+points_construit[0][0],py+points_construit[0][1],
				px+points_construit[0][2],py+points_construit[0][3],
				px+points_construit[0][4],py+points_construit[0][5]);
				beginShape();
				// vertex(px+points_construit[1][0],py+points_construit[1][1],points_construit[1][2],points_construit[1][3]);
				for (int i = 0; i < points_construit[1].length; i+=2) {
					vertex(px+points_construit[1][i],py+points_construit[1][i+1]);
				}
				endShape(CLOSE);
				// last
				float initAng = -angle/180f*PI+PI;
				if (initAng >= 2*PI) initAng -= 2*PI;
				// println("initAng: " + initAng*180/PI);
				fill(getMaterialFromMaterialsByIndex(1).cor);
				// println(points_construit[2][0] + " " + points_construit[2][1]);
				arc(px+points_construit[2][0],py+points_construit[2][1],tam*5,tam*5, initAng - angAberturaS2, initAng + angAberturaS2, CHORD);
				//
				showPieces(canPut);
				break;
			default:
			println("ERRO ao mostrar macro piece:\n   type '" + id + "' is not a type of piece MacroPiece._show()");
		}
		if (Cfg.showIds) {
			fill(0);
			textSize(20);
			String idShow = specificId.split("-")[0] + "-" + specificId.split("-")[1];
			text(idShow,px + 5,py + 5);
		}
		hide = false;
	}
	void showPieces(boolean canPut) {
		for (Piece piece : pieces) {
			piece.selected = this.selected;
			piece.shined = this.shined;
			piece.negativeShined = this.negativeShined;
			piece.show("canPut",canPut);
		}
	}
	// COPY
	String getFormatter() {
		String pcs = "";
		for (int i = 0;i < pieces.size();i++) {
			pcs += pieces.get(i).specificId;
			if (i < pieces.size() - 1) pcs += "_";
		}
		// println("Copied macro piece: " + type);
		return super.getFormatter() + ";" + pcs + ";"+angle;
	}
}