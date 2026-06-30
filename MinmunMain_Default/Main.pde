import java.nio.file.Files;
import java.nio.file.Path;

class Particle{
	float x;
	float y;
	float vx;
	float vy;
	float r;
	String type;
	int cor;
	boolean shined = false,selected = false;
	//
	Particle(String type,float x, float y) {
		this.type = type;
		this.x = x;
		this.y = y;
		r = 10;
		cor = color(255,0,0);
	}
	void update() {
		this.x += this.vx;
		this.y += this.vy;
	}
	void show() {
		noStroke();
		fill(cor);
		ellipse(x,y,r,r);
	}
}

// Variables
// mapa onde as coisas acontecem
int mapX = 1000,mapY = mapX,loop;
// movimentação atual da tela, em curso
float movX,movY;
// movimentação real da tela
float transX = width / 2,transY = height / 2,zoom = 1;
// Game variables
ArrayList<Particle> particles = new ArrayList<Particle>();
Particle selectedParticle = null,overParticle = null; 
// Definition variables
String arquivo = "teste.txt";
boolean running = true;


// float sliderValues[] = {potAttracktion,potRepulsionStrong,deltaTime,regionConnection};
// float sliderValue = 0;


void setup() {
	size(800, 800);
	// Lê arquivo
	try{
		// red = Files.readString(Path.of(arquivo));
	} catch(Exception e) {
	}
	// Define mov inicial
	movX = (mapX - width) / 2;
	movY = (mapY - height) / 2;
	
	// read(red,typesParticles);
	particles.add(new Particle("A",width/2,height/2));
}

void readDefinedForces(String red) {
	//Divide a leitura
	// String splited[] = red.split("_");
	for (int i = 0; i < 10; i++) {
		// String key = splited[i].split(",")[0];
		// String forceValue = splited[i].split(",")[1];
		// Parse
		// float f = Float.parseFloat(forceValue);
	}
}

void draw() {
	// inicial
	translate(transX,transY);
	scale(zoom);
	background(0);
	//
	//
	// codigo normal
	for (Particle p : particles) {
		if (running) p.update();
		p.show();
	}
	//
	//
	// clique do mouse
	mouseAutomatic();
	// volta zoom e translate pra colocar no lugar na tela
	scale(1 / zoom);
	translate( -transX, -transY);
	//
	//
	// codigo sem translate e zoom
	//
	//
	// textSize(16);
	// fill(255);
	// text(10 + " " + 10, 20, 20);
	// if (showConfigs) {
	// 	configs();
	// }
	// loop
	loop += 1;
}
void configs() {
	// float tamCircle = 30,gapWall = gapWall_configs;
	// fill(128,128,128,64);
	// if (inConfigs) {
	// 	fill(0,128,0,128);
	// 	stroke(10);
	// }
	// rect(gapWall,gapWall,areaConfigsX,areaConfigsY);stroke(0);
	/* GRID OF BUTTONS */
	{
	// // grid geral
	// for (int i = 0; i < typesParticles.length(); i++) {
	// 	fill(models.get(i).cor);
	// 	circle(gapWall + tamCircle * (i + 2), gapWall + tamCircle, tamCircle); // linha
	// 	circle(gapWall + tamCircle, gapWall + tamCircle * (i + 2), tamCircle); // coluna
	// 	//grid
	// 	for (int j = 0; j < typesParticles.length(); j++) {
	// 		String localForce = String.valueOf(typesParticles.charAt(i)) + String.valueOf(typesParticles.charAt(j));
	// 		float k = geralMapForces.get(localForce);
	// 		fill(255 * k,0, -255 * k,255);
	// 		float px = gapWall + tamCircle * (i + 1.5), py = gapWall + tamCircle + (j +.5) * tamCircle;
	// 		rect(px, py, tamCircle,tamCircle); // linha
	// 		// aciona
	// 		if (mouseX > px - 5 && mouseX < px + tamCircle + 5 && mouseY > py - 5 && mouseY < py + tamCircle + 5) {
	// 			selectTypeForce = localForce;
	// 			if (mouseButton == RIGHT && mousePressed) geralMapForces.put(selectTypeForce, 0f);  // zera a força
	// 		}
	// 		// valor
	// 		textSize(10);
	// 		fill(255);
	// 		text(nf(k,1,2), px + 5, py + tamCircle / 2 + 5);
	// 	}
	// }
}
	/* SLIDERS */
	{
		// // variables particles
		// String names[] = {"Attraction","Repulsion","deltaTime","Region"};
		// float realValues[] = {potAttracktion,potRepulsionStrong,deltaTime,regionConnection};
		// // calc
		// float initX = gapWall + tamCircle * 1, initY = gapWall + tamCircle + (typesParticles.length() + 2) * tamCircle;
		// boolean catchSlider = false;
		// for (int i = 0; i < names.length; i++) {
		// 	float gapY = 36 * i,espY = 10;
		// 	float tamSlide = 150,diam = 15;
		// 	// slide
		// 	noStroke();
		// 	fill(200);
		// 	circle(initX,initY + gapY + espY,diam);
		// 	rect(initX,initY + gapY + espY - diam / 2,tamSlide,diam);
		// 	circle(initX + tamSlide,initY + gapY + espY,diam);
		// 	// knob
		// 	float knobX = initX + sliderValues[i] * tamSlide;
		// 	fill(50);
		// 	// cacth knob
		// 	if (mouseX > initX - diam / 2 && mouseX < initX + tamSlide + diam / 2 && mouseY > initY + gapY + espY - diam / 2 && mouseY < initY + gapY + espY + diam / 2) {
		// 		if (mouseButton == LEFT && mousePressed) {
		// 			sliderValue = (mouseX - initX) / tamSlide;
		// 			if (sliderValue > 1) sliderValue = 1f;
		// 			if (sliderValue < 0) sliderValue = 0f;
		// 			sliderValues[i] = sliderValue;
		// 			// referencer
		// 			switch(i) {
		// 				case 0:
		// 					potAttracktion = int(sliderValue * max_potAtt);
		// 					break;
		// 				case 1:
		// 					potRepulsionStrong = int(sliderValue * max_potRep);
		// 					break;
		// 				case 2:
		// 					deltaTime = sliderValue * max_deltaTime;
		// 					break;
		// 				case 3:
		// 					regionConnection = int(sliderValue * max_regionConnection);
		// 					break;
		// 			}
		// 			//
		// 			catchSlider = true;
		// 			fill(0,255,0);
		// 		}
		// 	}
		// 	circle(knobX, initY + gapY + espY, diam * 1.3);
		// 	// text
		// 	fill(255);
		// 	textSize(18);
		// 	text(names[i] + " " + realValues[i],initX,initY + gapY);
		// }
		// if (!catchSlider) {
		// 	sliderPosition = -1;
		// }
	}
}

void mouseWheel(MouseEvent event) {
	float e = event.getCount();
	if (true) {
		zoom -= e * 0.1;
		if (zoom > 10) zoom = 10;
		if (zoom < 0.1) zoom = 0.1;
	}
}

void mouseAutomatic() {
	boolean overed = false;
	for (Particle p : particles) {
		float pax,pbx,px,pay,pby,py;
		px = (mouseX - transX) / zoom;
		py = (mouseY - transY) / zoom;
		pax = p.x - p.r;
		pbx = p.x + p.r;
		pay = p.y - p.r;
		pby = p.y + p.r;
		if (pax <=  px &&  px <=  pbx &&  pay <=  py &&  py <=  pby) {
			overParticle = p;
			p.shined = true;
			overed = true;
		} else p.shined = false;
	}
	if (!overed) overParticle = null;
}

void mousePressed() {
	// // scroll do mouse tbm
	// float scroll = mouseWheel;
	// configs
	// inConfigs = false;
	// if (showConfigs) {
	// 	if (mouseX > gapWall_configs && mouseX < gapWall_configs + areaConfigsX && mouseY > gapWall_configs && mouseY < gapWall_configs + areaConfigsY) {
	// 		inConfigs = true;
	// 	}
	// }
	//
	// if ((mouseButton == LEFT)) { // qnd pressiona o but direito 2 vzs
	// particles.add(new Particle(selectType,(mouseX - transX) / zoom,(mouseY - transY) / zoom));
	// selectTypeForce = "--";
	// } else 
	if (mouseButton == LEFT) { // move a telaf
		movX = mouseX;
		movY = mouseY;
	} else if (mouseButton == RIGHT) {
		if (selectedParticle == overParticle && selectedParticle != null) {
			selectedParticle.selected = false;
			selectedParticle = null;
		}
		else if (selectedParticle != null && overParticle != null) {
			// selectedParticle.add(overParticle);
			// overParticle.add(selectedParticle);
			selectedParticle.selected = false;
			selectedParticle = overParticle;
			selectedParticle.selected = true;
		} else if (overParticle != null) {
			selectedParticle = overParticle;
			overParticle.selected = true;
		}
	}
}

void mouseDragged() {
	// move a tela
	if (mouseButton == LEFT) {
		
		transX += (mouseX - movX);
		transY += (mouseY - movY);
		movX = mouseX;
		movY = mouseY;
		
	}
	
}


void keyPressed() {
	/* KEYBOARD */
	{
	// if (key == '1') selectType = (selectType ==  "a") ? "none" : "a";
	// else if (key == '2') selectType = (selectType ==  "b") ? "none" : "b";
	// else if (key == '3') selectType = (selectType ==  "c") ? "none" : "c";
	// else if (key == '4') selectType = (selectType ==  "d") ? "none" : "d";
	// else if (key == '5') selectType = (selectType ==  "e") ? "none" : "e";
	// else if (key == ENTER) {
	// 	selectType = "none";
	// 	selectTypeForce = "--";
	// }
	// else if (key == 'z') { // zera as forças
	// 	for (String key : geralMapForces.keySet()) {
	// 		geralMapForces.put(key, 0.0);
	// 	}
	// }
	// else if (key == ' ') running = !running;
	// else if (key == 'c') {
	// 	showConfigs = !showConfigs;
	// }
	// else if (key == 's') { // shadow
	// 	showShadows = !showShadows;
	// }
	// else if (key == 'f') {
	// 	geralMapForces.clear();
	// 	defineForces(typesParticles);
	// } // reset forces
	// else if (key == 'r') {
	// 	particles.clear();
	// 	bigbang(0,"c");
	// }
	// else if (key == '0') {
	// 	movX = 0;
	// 	movY = 0;
	// } else if (key == 'p') { // print forces
}
// Write on a file
	String text = "";
	// for (String key : geralMapForces.keySet()) {
	// text += key + "," + geralMapForces.get(key) + "_";
	
	try{
		Files.writeString(Path.of(arquivo), text);
		println(text);
	} catch(Exception e) {}
	
	
}