import java.nio.file.Files;
import java.nio.file.Path;

String defaultForces = "";


//
HashMap<String,Float> geralMapForces = new HashMap<String,Float>();
ArrayList<Particle> particles = new ArrayList<Particle>();
String typesParticles = "abcde";
ArrayList<Particle> models = new ArrayList<Particle>();
String selectType = "none",selectTypeForce = "--";
boolean running = true,showConfigs = true,showShadows = false,firstIteraion_Dragged = true;
int loop = 0;
float gapWall_configs = 30,areaConfigsX = 200,areaConfigsY = 400,zoom = 1,
transX = 0,transY = 0,movX = 0,movY = 0,initialPositionX_Dragged = 0,initialPositionY_Dragged = 0;
// map
int mapX = 1000,mapY = mapX;
// local mouse 
boolean inConfigs = true;
// particles
float potAttracktion = 45,regionConnection = 30,potRepulsionStrong = 9,attraction = 0.1f,deltaTime = 1f;
float max_potAtt = 400,max_regionConnection = 100,max_potRep = 100,max_deltaTime = 10f;
float sliderValues[] = {potAttracktion / max_potAtt,potRepulsionStrong / max_potRep,deltaTime / max_deltaTime,regionConnection / max_regionConnection} ,sliderValue = 0f;
int sliderPosition = 0;
Particle selectedParticle = null,overParticle = null;

void setup() {
	try{
		defaultForces = Files.readString(Path.of("forces.txt"));
		// println(defaultForces);
	} catch(Exception e) {
		
	}
	//
	size(800, 800);
	// redefine mov
	movX = (mapX - width) / 2;
	movY = (mapY - height) / 2;
	//
	for (int i = 0; i < typesParticles.length(); i++) {
		char type = typesParticles.charAt(i);
		models.add(new Particle(String.valueOf(type), 0, 0)); // Part
	}
	//
	readDefinedForces(defaultForces,typesParticles);
	defineForces(typesParticles);
	bigbang(2000,typesParticles);
}

void defineForces(String types) {
	for (char type1 : types.toCharArray()) {
		for (char type2 : types.toCharArray()) {
			String key = String.valueOf(type1) + String.valueOf(type2);
			if (!geralMapForces.containsKey(key)) {
				float forceValue = random( -1, 1); // Random force value for demonstration
				geralMapForces.put(key, forceValue);
			}
		}
	}
}
void readDefinedForces(String red,String types) {
	// if (red.equals("")) return;
		// println(red);
	String splited[] = red.split("_");
	for (int i = 0; i < splited.length; i++) {
		String key = splited[i].split(",")[0];
		String forceValue = splited[i].split(",")[1];
		float f = Float.parseFloat(forceValue);
		// println(key,f);
		geralMapForces.put(key,f); 
	}
}

void bigbang(int n,String types) {
	for (char type : types.toCharArray()) {
		for (int i = 0; i < n / types.length(); i++) {
			float x = random(width);
			float y = random(height);
			particles.add(new Particle(String.valueOf(type), x, y));
		}
	}
}

void draw() {
	translate(transX,transY);
	scale(zoom);
	background(0);
	float barrier = 10;
	// map
	fill(16);
	rect(barrier,barrier,mapX,mapY);
	
	
	//
	noStroke();
	for (Particle p : particles) {
		if (running) p.update();
		p.show();
		// barreer map
		
		if (p.x - p.r < barrier) p.x += 1;
		if (p.x + p.r > mapX + barrier) p.x -= 1;
		if (p.y - p.r < barrier) p.y += 1;
		if (p.y + p.r > mapY + barrier) p.y -= 1;
	}
	if (!inConfigs) mouseAutomatic();
	stroke(1);
	// println("--- "+loop);
	scale(1 / zoom);
	translate( -transX, -transY);
	// sem zoom e translate
	textSize(16);
	fill(255);
	text(selectType + " " + particles.size(), 20, 20);
	// text(transX + ", " + transY, 120, 20);
	if (showConfigs) {
		configs();
	} 
	// else{selectType = "none";selectTypeForce = "--";}
	//
	loop += 1;
}

void configs() {
	float tamCircle = 30,gapWall = gapWall_configs;
	fill(128,128,128,64);
	if (inConfigs) {
		fill(0,128,0,128);
		stroke(10);
	}
	rect(gapWall,gapWall,areaConfigsX,areaConfigsY);stroke(0);
	// grid geral
	for (int i = 0; i < typesParticles.length(); i++) {
		fill(models.get(i).cor);
		circle(gapWall + tamCircle * (i + 2), gapWall + tamCircle, tamCircle); // linha
		circle(gapWall + tamCircle, gapWall + tamCircle * (i + 2), tamCircle); // coluna
		//grid
		for (int j = 0; j < typesParticles.length(); j++) {
			String localForce = String.valueOf(typesParticles.charAt(i)) + String.valueOf(typesParticles.charAt(j));
			float k = geralMapForces.get(localForce);
			fill(255 * k,0, -255 * k,255);
			float px = gapWall + tamCircle * (i + 1.5), py = gapWall + tamCircle + (j +.5) * tamCircle;
			rect(px, py, tamCircle,tamCircle); // linha
			// aciona
			if (mouseX > px - 5 && mouseX < px + tamCircle + 5 && mouseY > py - 5 && mouseY < py + tamCircle + 5) {
				selectTypeForce = localForce;
				if (mouseButton == RIGHT && mousePressed) geralMapForces.put(selectTypeForce, 0f);  // zera a força
			}
			// valor
			textSize(10);
			fill(255);
			text(nf(k,1,2), px + 5, py + tamCircle / 2 + 5);
		}
	}
	// variables particles
	String names[] = {"Attraction","Repulsion","deltaTime","Region"};
	float realValues[] = {potAttracktion,potRepulsionStrong,deltaTime,regionConnection};
	// calc
	float initX = gapWall + tamCircle * 1, initY = gapWall + tamCircle + (typesParticles.length() + 2) * tamCircle;
	boolean catchSlider = false;
	for (int i = 0; i < names.length; i++) {
		float gapY = 36 * i,espY = 10;
		float tamSlide = 150,diam = 15;
		// slide
		noStroke();
		fill(200);
		circle(initX,initY + gapY + espY,diam);
		rect(initX,initY + gapY + espY - diam / 2,tamSlide,diam);
		circle(initX + tamSlide,initY + gapY + espY,diam);
		// knob
		float knobX = initX + sliderValues[i] * tamSlide;
		fill(50);
		// cacth knob
		if (mouseX > initX - diam / 2 && mouseX < initX + tamSlide + diam / 2 && mouseY > initY + gapY + espY - diam / 2 && mouseY < initY + gapY + espY + diam / 2) {
			if (mouseButton == LEFT && mousePressed) {
				sliderValue = (mouseX - initX) / tamSlide;
				if (sliderValue > 1) sliderValue = 1f;
				if (sliderValue < 0) sliderValue = 0f;
				sliderValues[i] = sliderValue;
				// referencer
				switch(i) {
					case 0:
						potAttracktion = int(sliderValue * max_potAtt);
						break;
					case 1:
						potRepulsionStrong = int(sliderValue * max_potRep);
						break;
					case 2:
						deltaTime = sliderValue * max_deltaTime;
						break;
					case 3:
						regionConnection = int(sliderValue * max_regionConnection);
						break;
				}
				//
				catchSlider = true;
				fill(0,255,0);
			}
		}
		circle(knobX, initY + gapY + espY, diam * 1.3);
		// text
		fill(255);
		textSize(18);
		text(names[i] + " " + realValues[i],initX,initY + gapY);
	}
	if (!catchSlider) {
		sliderPosition = -1;
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

void mouseWheel(MouseEvent event) {
	float e = event.getCount();
	if (selectTypeForce != "--" && inConfigs) {
		geralMapForces.put(selectTypeForce, geralMapForces.get(selectTypeForce) - e * 0.01);
		if (geralMapForces.get(selectTypeForce) > 1) geralMapForces.put(selectTypeForce, 1f);
		if (geralMapForces.get(selectTypeForce) < - 1) geralMapForces.put(selectTypeForce, -1f);
	}
	else if (selectType != "none" && e != 0) {
		particles.add(new Particle(selectType, (mouseX - transX) / zoom, (mouseY - transY) / zoom));
	} else{
		zoom -= e * 0.1;
		if (zoom > 10) zoom = 10;
		if (zoom < 0.1) zoom = 0.1;
	}
}

void mouseReleased() {
	// trans
}

void mousePressed() {
	// // scroll do mouse tbm
	// float scroll = mouseWheel;
	inConfigs = false;
	if (showConfigs) {
		if (mouseX > gapWall_configs && mouseX < gapWall_configs + areaConfigsX && mouseY > gapWall_configs && mouseY < gapWall_configs + areaConfigsY) {
			inConfigs = true;
		}
	}
	//
	if (selectType != "none" && (mouseButton == LEFT) && !inConfigs) { // qnd pressiona o but direito 2 vzs
		particles.add(new Particle(selectType, (mouseX - transX) / zoom, (mouseY - transY) / zoom));
		selectTypeForce = "--";
	} else if (mouseButton == LEFT) { // move a telaf
		movX = mouseX;
		movY = mouseY;
	} else if (mouseButton == RIGHT) {
		if (selectedParticle == overParticle && selectedParticle != null) {
			selectedParticle.selected = false;
			selectedParticle = null;
		}
		else if (selectedParticle != null && overParticle != null) {
			selectedParticle.add(overParticle);
			overParticle.add(selectedParticle);
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
		if (inConfigs) {
			
		} else{
			transX += (mouseX - movX);
			transY += (mouseY - movY);
			movX = mouseX;
			movY = mouseY;
		}
	}
}

void keyPressed() {
	if (key == '1') selectType = (selectType=="a")? "none":"a";
	else if (key == '2') selectType = (selectType=="b")? "none":"b";
	else if (key == '3') selectType = (selectType=="c")? "none":"c";
	else if (key == '4') selectType = (selectType=="d")? "none":"d";
	else if (key == '5') selectType = (selectType=="e")? "none":"e";
	else if (key == ENTER) {
		selectType = "none";
		selectTypeForce = "--";
	}
	else if (key == 'z') { // zera as forças
		for (String key : geralMapForces.keySet()) {
			geralMapForces.put(key, 0.0);
		}
	}
	else if (key == ' ') running = !running;
	else if (key == 'c') {
		showConfigs = !showConfigs;
	}
	else if (key == 's') { // shadow
		showShadows = !showShadows;
	}
	else if (key == 'f') {
		geralMapForces.clear();
		defineForces(typesParticles);
	} // reset forces
	else if (key == 'r') {
		particles.clear();
		bigbang(0,"c");
	}
	else if (key == '0') {
		movX = 0;
		movY = 0;
	} else if (key == 'p') { // print forces
		String text = "";
		for (String key : geralMapForces.keySet()) {
			text += key + "," + geralMapForces.get(key) + "_";
		}
		try{
			Files.writeString(Path.of("forces.txt"), text);
			println(text);
		} catch(Exception e) {
		}
	}
	
}
