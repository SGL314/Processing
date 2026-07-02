import java.nio.file.Files;
import java.nio.file.Path;


// Variables
// mapa onde as coisas acontecem
int mapX = 1000,mapY = mapX,loop;
// movimentação atual da tela, em curso
float movX,movY;
// movimentação real da tela
float transX = 0,transY = 0,zoom = 1;
// Constantes
float PI = 3.1415926535897932384626433832795f;
final int initialTamSquare = 32;
String[] typeOfPipes = {"pipe"};
String[] typeOfConnectors = {"connector"};
// Game variables
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Construction> constructions = new ArrayList<Construction>();
ArrayList<Menu> menus = new ArrayList<Menu>();
Configuration Cfg = new Configuration();
Inventory Inv = new Inventory();
Particle selectedParticle = null,overParticle = null;
Construction onHandConstruction = null,selectedConstruction = null,overConstruction = null;
float tamSquare = initialTamSquare;
// Definition variables
String idRunning = "idr." + hour() + ":" + minute() + ":" + second() + "*" + day() + ":" + month() + ":" + year();
int tamGrid = initialTamSquare * 20;

// float sliderValues[] = {potAttracktion,potRepulsionStrong,deltaTime,;};
// float sliderValue = 0;

void setup() {
	size(800, 800);
	// Define mov inicial
	movX = (mapX - width) / 2;
	movY = (mapY - height) / 2;
	
	// read(red,typesParticles);
	particles.add(new Particle("metal",width / 2,height / 2));
	defineMenus();
	modusMenu("Geral",true);
	modusMenu("Inventory",true);
	Cfg.loadAll();
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
	formGrid();
	for (Particle p : particles) {
		if (Cfg.running) p.update();
		p.show();
	}
	//
	//
	// clique do mouse
	updateAndDrawAll();
	mouseAutomatic();
	// volta zoom e translate pra colocar no lugar na tela
	scale(1 / zoom);
	translate( -transX, -transY);
	// mouse position
	if (Cfg.showPosition) {
		textSize(16);
		fill(128,64,64);
		text(mouseX + "," + mouseY, mouseX,mouseY);
		textSize(16);
		fill(128,64,64);
		text(transX + "," + transY, 10,150);
	}
	
	processPutting(false);
	showMenus();
	//
	//
	// codigo sem translate e zoom
	//
	//
	// textSize(16);
	// fill(255);
	// text(10 + " " + 10, 20, 20);
	
	// if (showConfigs) {
	//   configs();
	// }
	// loop
	loop += 1;
}

void formGrid() {
	// grid geral
	fill(255,255,255);
	float center = 0;
	// if (tamGrid/2*tamSquare < width/2)
	center = width / 2 - tamGrid / initialTamSquare / 2 * tamSquare;
	for (int i = 0; i < tamGrid / initialTamSquare; i++) {
		stroke(1);
		for (int j = 0; j < tamGrid / initialTamSquare; j++) {
			rect(tamSquare * i + center,tamSquare * j + center,tamSquare,tamSquare);
		}
	}
}

void configs() {
	// float tamCircle = 30,gapWall = gapWall_configs;
	// fill(128,128,128,64);
	
	// if (inConfigs) {
	//   fill(0,128,0,128);
	//   stroke(10);
	// }
	// rect(gapWall,gapWall,areaConfigsX,areaConfigsY);
	// stroke(0);
	/* GRID OF BUTTONS */
	// // grid geral
	// for(int i = 0;
	// i < typesParticles.length(); i++) {
	//   fill(models.get(i).cor);
	//   circle(gapWall + tamCircle *(i + 2), gapWall + tamCircle, tamCircle); // linha
	//   circle(gapWall + tamCircle, gapWall + tamCircle *(i + 2), tamCircle); // coluna
	//   //grid
	//   for(int j = 0;
	// j < typesParticles.length(); j++) {
	//     String localForce = String.valueOf(typesParticles.charAt(i)) + String.valueOf(typesParticles.charAt(j));
	//     float k = geralMapForces.get(localForce);
	//     fill(255 * k,0, -255 * k,255);
	//     float px = gapWall + tamCircle *(i + 1.5), py = gapWall + tamCircle +(j +.5) * tamCircle;
	//     rect(px, py, tamCircle,tamCircle); // linha
	//     // aciona
	//     if (mouseX > px - 5 && mouseX < px + tamCircle + 5 && mouseY > py - 5 && mouseY < py + tamCircle + 5) {
	//       selectTypeForce = localForce;
	//       if (mouseButton == RIGHT && mousePressed) geralMapForces.put(selectTypeForce, 0f);  // zera a força
	//     }
	//     // valor
	//     textSize(10);
	//     fill(255);
	//     text(nf(k,1,2), px + 5, py + tamCircle / 2 + 5);
	//   }
	// }
	/* SLIDERS */ 
	{
		// // variables particles
		// String names[] = {
		// "Attraction","Repulsion","deltaTime","Region"}
		// ;
		// // float realValues[] = {
		//   potAttracktion,potRepulsionStrong,deltaTime,;
		// }
		// ;
		// // calc
		// float initX = gapWall + tamCircle * 1, initY = gapWall + tamCircle +(typesParticles.length() + 2) * tamCircle;
		// boolean catchSlider = false;
		// for(int i = 0;
		// i < names.length; i++) {
		//   float gapY = 36 * i,espY = 10;
		//   float tamSlide = 150,diam = 15;
		//   // slide
		//   noStroke();
		//   fill(200);
		//   circle(initX,initY + gapY + espY,diam);
		//   rect(initX,initY + gapY + espY - diam / 2,tamSlide,diam);
		//   circle(initX + tamSlide,initY + gapY + espY,diam);
		//   // knob
		//   float knobX = initX + sliderValues[i] * tamSlide;
		//   fill(50);
		//   // cacth knob
		//   if (mouseX > initX - diam / 2 && mouseX < initX + tamSlide + diam / 2 && mouseY > initY + gapY + espY - diam / 2 && mouseY < initY + gapY + espY + diam / 2) {
		//     if (mouseButton == LEFT && mousePressed) {
		//       sliderValue =(mouseX - initX) / tamSlide;
		//       if (sliderValue > 1) sliderValue = 1f;
		//       if (sliderValue < 0) sliderValue = 0f;
		//       sliderValues[i] = sliderValue;
		//       // referencer
		
		//       switch(i) {
		//         case 0:
		//           potAttracktion = int(sliderValue * max_potAtt);
		//           break;
		//         case 1:
		//           potRepulsionStrong = int(sliderValue * max_potRep);
		//           break;
		//         case 2:
		//           deltaTime = sliderValue * max_deltaTime;
		//           break;
		//         case 3:
		//           regionConnection = int(sliderValue * max_regionConnection);
		//           break;
		//       }
		//       //
		//       catchSlider = true;
		//       fill(0,255,0);
		//     }
		//   }
		//   circle(knobX, initY + gapY + espY, diam * 1.3);
		//   // text
		//   fill(255);
		//   textSize(18);
		//   text(names[i] + " " + realValues[i],initX,initY + gapY);
		// }
		// if (!catchSlider) {
		//   sliderPosition = -1;
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
	float pax,pbx,px,pay,pby,py;
	px = (mouseX - transX) / zoom;
	py = (mouseY - transY) / zoom;
	for (Construction c : constructions) {
		if (overed) {c.shined = false;continue;}
		if (!c.isTypeOfPipe) {
			// pax = c.px - c.r;
			// pbx = c.px + c.r;
			// pay = c.py - c.r;
			// pby = c.py + c.r;
			if (pow(pow(c.px - px,2) + pow(c.py - py,2),.5) <= c.r) {
				overConstruction = c;
				c.shined = true;
				overed = true;
			}
			else c.shined = false;
		} else if (c.isTypeOfPipe) {
			if (c.pointInsidePolygon(px,py)) {
				overConstruction = c;
				c.shined = true;
				overed = true;
			}
			else c.shined = false;
		}
	}
	if (!overed) overConstruction = null;
	//
	if (onHandConstruction!= null) {
		// onHandConstruction.px = px;
		// onHandConstruction.py = py;
		// onHandConstruction.px += transX;
		// onHandConstruction.py += transY;
	}
}

void mousePressed() {
	// coloca só se n tiver processado nd
	boolean left = mouseButton == LEFT,right = mouseButton == RIGHT;
	Cfg.diferenceTimeClick = millis() - Cfg.diferenceTimeClick;
	// println(Cfg.diferenceTimeClick+" "+(Cfg.lastButton==RIGHT));
	int gapDoubleClick = 200;
	if (!updateMenus(left,right)) {
		boolean hasPutting = processPutting(left);
		if (right && Cfg.lastButton ==  RIGHT && Cfg.diferenceTimeClick < gapDoubleClick) onHandConstruction = null;
		if (!hasPutting &&  overConstruction!= null && left) {
			if (selectedConstruction ==  null) {
				selectedConstruction = overConstruction;
				selectedConstruction.selected = true;
			}
			else if (selectedConstruction == overConstruction) selectedConstruction.selected = false;
			else if (selectedConstruction != overConstruction) {
				selectedConstruction.selected = false;
				selectedConstruction = overConstruction;
				selectedConstruction.selected = true;
			}
		}
	}
	if (left  && onHandConstruction ==  null || right && onHandConstruction!= null) {
		// move a telaf
		movX = mouseX;
		movY = mouseY;
	}
	Cfg.lastButton = mouseButton;
	Cfg.diferenceTimeClick = millis();
}

void mouseDragged() {
	// move a tela
	if (mouseButton == LEFT  && onHandConstruction ==  null || mouseButton == RIGHT && onHandConstruction!= null) {
		transX += (mouseX - movX);
		transY += (mouseY - movY);
		movX = mouseX;
		movY = mouseY;
	}
}

void keyPressed() {
	boolean ret;
	Menu menuS = null;
	String name,id;
	
	switch(key) {
		case 'p' : // show position
			Cfg.showPosition = !Cfg.showPosition;
			break;
		case 'c' : // construction mode
			toggleMenu("Construction");
			break;
		case 'f' : // redefine prefabs
			// Cfg.redefinePreFabs();
			break;
		case 's' : // save
			Cfg.saveAll();break;
		case 'x' : // remove
			if (overConstruction!= null) Cfg.preProcessSaving("removeFromConstructions",overConstruction);
			break;
		case '0' : // coloca no centro
			transX = 0;
			transY = 0;
			zoom = 1;
			break;
		// LEVELS
		case '1' : // level 1
			name = "Level 1";id = "lvl1";
			for (Menu menu : menus) {
				if (menu.name.equals("Construction")) {
					menuS = menu;
					break;
				}
			}
			menuS.deactiveAllLess(id);
			ret = toggleMenu(name);
			menuS.active = ret;
			if (menuS.active == false) menuS.deactiveAll(); 
			break;
		case '2' : // level 2
			name = "Level 2"; id = "lvl2";
			for (Menu menu : menus) {
				if (menu.name.equals("Construction")) {
					menuS = menu;
					break;
				}
			}
			menuS.deactiveAllLess(id);
			ret = toggleMenu(name);
			menuS.active = ret;
			if (menuS.active == false) menuS.deactiveAll(); 
			break;
		case ' ' : // pause
			Cfg.running = !Cfg.running;
			break;
	}
	// Write on a file
	String text = "";
	// for(String key : geralMapForces.keySet()) {
	// text += key + "," + geralMapForces.get(key) + "_";
	
	// }
}
// GAME
void updateAndDrawAll() {
	Cfg.usingConstructions = true;
	// show whats is a pipe
	for (Construction cons : constructions) {
		if (Cfg.running) cons.update();
		if (cons.isTypeOfPipe()) cons.show();
	}
	// show what is not a pipe
	for (Construction cons : constructions) {
		if (!cons.isTypeOfPipe()) cons.show();
	}
	Cfg.usingConstructions = false;
}
boolean processPutting(boolean put) {
	boolean hasPutting = false;
	if (onHandConstruction != null) {
		
		if (onHandConstruction.isTypeOfPipe) {
			onHandConstruction.px = ((mouseX - onHandConstruction.tam / 2 - transX) / zoom - ((mouseX - onHandConstruction.tam / 2 - transX) / zoom) % (tamSquare / 2));
			onHandConstruction.py = ((mouseY - onHandConstruction.tam / 2 - transY) / zoom - ((mouseY - onHandConstruction.tam / 2 - transY) / zoom) % (tamSquare / 2));
		} else{
			onHandConstruction.px = ((mouseX - transX) / zoom - ((mouseX - transX) / zoom) % (tamSquare / 2));
			onHandConstruction.py = ((mouseY - transY) / zoom - ((mouseY - transY) / zoom) % (tamSquare / 2));
		}
		if (onHandConstruction.modusLinearis) {
			onHandConstruction.modusLinearis(
				(mouseX  - transX) / zoom - ((mouseX  - transX) / zoom) % (tamSquare / 2),
				(mouseY  - transY) / zoom - ((mouseY  - transY) / zoom) % (tamSquare / 2));
		}
		
		// verify is can put
		boolean canPut = true,breakar = false;
		float pa,pb,pc,pd;
		Construction connectConstruction = null;
		{
			Construction consO = overConstruction;
			// float relx = (onHandConstruction.px - transX) / zoom,rely = (onHandConstruction.py - transY) / zoom;
			float relx = (onHandConstruction.px),rely = (onHandConstruction.py);
			for (Construction cons : constructions) {
				cons.negativeShined = false;
				switch(cons.id) {
					// R
					case "pipe":
						pa = cons.px;pb = cons.px + cons.tam;pc = cons.py;pd = cons.py + cons.tam;
						switch(onHandConstruction.id) {
							// RR
							case "pipe":
							if (
								relx > pa && relx < pb && rely > pc && rely < pd || 
								relx + onHandConstruction.tam > pa && relx + onHandConstruction.tam < pb && rely > pc && rely < pd || 
								relx + onHandConstruction.tam > pa && relx + onHandConstruction.tam < pb && rely + onHandConstruction.tam > pc && rely + onHandConstruction.tam < pd || 
								relx > pa && relx < pb && rely + onHandConstruction.tam > pc && rely + onHandConstruction.tam < pd || 
								pow(pow(relx + onHandConstruction.tam / 2 - pa - cons.tam / 2,2) + pow(rely + onHandConstruction.tam / 2 - pc - cons.tam / 2,2),.5) < onHandConstruction.tam) {
								canPut = false;
								breakar = true;
							}
						break;
						// RC
						case "connector":
							if (pow(pow(relx - pa,2) + pow(rely - pc,2),.5) < onHandConstruction.r || 
								pow(pow(relx - pb,2) + pow(rely - pc,2),.5) < onHandConstruction.r || 
								pow(pow(relx - pb,2) + pow(rely - pd,2),.5) < onHandConstruction.r || 
								pow(pow(relx - pa,2) + pow(rely - pd,2),.5) < onHandConstruction.r || 
								pow(pow(relx - pa - cons.tam / 2,2) + pow(rely - pc - cons.tam / 2,2),.5) < onHandConstruction.r) {
								canPut = false;
								breakar = true;
							}
							break;
						default:
						println("ERRO ao processar collison:\n   type nao reconhecido: '" + onHandConstruction.id + "'");
					}
					break;
					// C
					case "connector":
						pa = relx;pb = relx + onHandConstruction.tam;pc = rely;pd = rely + onHandConstruction.tam;
						switch(onHandConstruction.id) {
							// CR
							case "pipe":
							if (
								pow(pow(cons.px - pa,2) + pow(cons.py - pc,2),.5) < cons.r || 
								pow(pow(cons.px - pb,2) + pow(cons.py - pc,2),.5) < cons.r || 
								pow(pow(cons.px - pb,2) + pow(cons.py - pd,2),.5) < cons.r || 
								pow(pow(cons.px - pa,2) + pow(cons.py - pd,2),.5) < cons.r || 
								pow(pow(cons.px - pa - onHandConstruction.tam / 2,2) + pow(cons.py - pc - onHandConstruction.tam / 2,2),.5) < onHandConstruction.tam / 2 + cons.r) {
								canPut = false;
								cons.negativeShined = true; // coloca pra n ficar neg.shined
								breakar = true;
							}
						break;
						// CC
						case "connector":
							if (pow(pow(relx - cons.px,2) + pow(rely - cons.py,2),.5) < onHandConstruction.r + cons.r) {
								canPut = false;
								breakar = true;
							}
							break;
						default:
						println("ERRO ao processar collison:\n   type nao reconhecido: '" + onHandConstruction.id + "'");
					}
					break;
					default:
					println("ERRO ao processar collison:\n   type nao reconhecido: '" + cons.id + "'");
				}
				
				if (breakar) {
					cons.negativeShined = !cons.negativeShined; // coloca pra ficar neg.shined
					break;
				}
			}
			
			
			
			
			//a pipe just can be put on a connector
			for (String typeOfPipe : typeOfPipes) {
				if (onHandConstruction.id.equals(typeOfPipe)) {
					canPut = false;
					if (consO ==  null) break;
					for (String typeOfConnector : typeOfConnectors) { 
						if (consO.id.equals(typeOfConnector)) {
							canPut = true;
							connectConstruction = consO;
							break;
							// if (pow(pow(consO.px - onHandConstruction.px - onHandConstruction.tam / 2,2) + pow(consO.py - onHandConstruction.py - onHandConstruction.tam / 2,2),.5) == 0) {
							// }
						}
					}
					break;
				}
			}
			
		}
		//	show
		translate(transX, transY);
		scale(zoom);
		onHandConstruction.show("canPut",canPut);
		scale(1 / zoom);
		translate( -transX, -transY);
		//
		if	(put	 && canPut) { // effective putting
			boolean	isTypeOfPipe = false;
			for	(String typeOfPipe : typeOfPipes) {
				if	(onHandConstruction.id.equals(typeOfPipe)) {
					if	(!onHandConstruction.modusLinearis) {
						//	println("modusLinearis");
						//	será	?
						// onHandConstruction.px = (mouseX - transX - (mouseX - transX) % (tamSquare / 2)) / zoom;
						// onHandConstruction.py = (mouseY - transY - (mouseY - transY) % (tamSquare / 2)) / zoom;
						onHandConstruction.connections.add(connectConstruction);
						onHandConstruction.modusLinearis(onHandConstruction.px,onHandConstruction.py);
					} 	else{
						//	if	(onHandConstruction.connections.get(0) == connectConstruction) {
						//	 onHandConstruction.connections.clear();
						//	}	else{
						//	println("effectiveModusLinearis");
						onHandConstruction.connections.add(connectConstruction);
						Construction cons = onHandConstruction;
						onHandConstruction = onHandConstruction.copy();
						cons.effectiveModusLinearis();
						Cfg.preProcessSaving("addInConstructions",cons);
						//	}
					}
					hasPutting	 = true;
					isTypeOfPipe = true;
					break;
				}
			}
			if	(!isTypeOfPipe) {
				Construction	cons = onHandConstruction;
				onHandConstruction = onHandConstruction.copy();
				// cons.px	 = 	(mouseX - transX - (mouseX - transX) % (tamSquare / 2)) / zoom;
				// cons.py	 = 	(mouseY - transY - (mouseY - transY) % (tamSquare / 2)) / zoom;
				Cfg.preProcessSaving("addInConstructions",cons);hasPutting = true;
			}
		}
	}
	return	hasPutting;
}

//	LAYER	MENU
void	defineMenus() {
	float	px	 = 	0,py	 = 0,w = 0,h = 0;
	int	i,j;
	float	step,hBtUp,wBtUp;
	int	localX	 = 	0,localY = 0;
	Menu[]	menusA	 = 	{
		new	Menu("Geral",color(#DBDBDB,64)),
			new	Menu("Inventory",color(#DBDBDB,64)),
			new	Menu("Construction",color(#A8FCCF)),
			new	Menu("Level 1",color(#FF7040)),
			new	Menu("Level 2",color(#FFD640)),
			new	Menu("Putting",color(#A8FCCF,64))
		};
	//0	left,	1	right,	2 both
	for	(int	pm	 = 	0;pm	 < menusA.length;pm++) {
		Menu	menu	 = 	menusA[pm];
		menus.add(menu);
		localX	 = 	0;
		//	depois	de	cor	=tamtext
		
		switch(menu.name)	{
			case	"Geral":
			px	 = 	0;
			h = 	100;
			py	 = 	width	 - 	100;
			w = 	50;
			step	 = 	5;
			hBtUp	 = 	20;
			wBtUp	 = 	20;
			//	up
			menu.addButton(new Button("CONS.","rect","Construction",color(#FF7040),px + step + localX * (step + wBtUp),py + step,wBtUp,hBtUp,0));
			//	localX++;
			//	menu.addButton(new Button("Level 2","rect","lvl2",color(#FFD640),px + step + localX * (step + wBtUp),py - hBtUp,wBtUp,hBtUp,0));
			break;
			case	"Inventory":
				int	qtdColumns	 = 	3;
				step	 = 	5;
				wBtUp	 = 	50;
				w = 	(qtdColumns	 + 1) * step + qtdColumns * (wBtUp);
				h = 	height	 - 	100	 * 2;
				px	 = 	width	 - 	w;
				py	 = 	100;
				hBtUp	 = 	50;
				//	up
				i = 	0;j	 = 	0;
				for	(Material	material : Cfg.materials) {
					menu.addButton(new Button("invmat-" + material.name,
						"rect","invmat-"	 + material.id,color(#A0A0A0),10,
						px	 + 	step	 + 	i	 * 	(step + wBtUp),
						py	 + 	step	 + 	j	 * 	(step + hBtUp),wBtUp,hBtUp,0));
					i++;
					if	(i	 ==  	qtdColumns) {
						i = 	0;
						j++;
					}
				}
				break;
			case	"Construction":
			px	 = 	50;
			h = 	100;
			py	 = 	width	 - 	h;
			w = 	width	 - 	px	 * 	2;
			step	 = 	10;
			hBtUp	 = 	20;
			wBtUp	 = 	50;
			//	up
			menu.addButton(new Button("Level 1","rect","lvl1",color(#FF7040),px + step + localX * (step + wBtUp),py - hBtUp,wBtUp,hBtUp,0));
			localX++;
			menu.addButton(new Button("Level 2","rect","lvl2",color(#FFD640),px + step + localX * (step + wBtUp),py - hBtUp,wBtUp,hBtUp,0));
			break;
			case	"Level 1":
			px	 = 	52;
			h = 	80;
			py	 = 	width	 - 	10;
			w = 	5;
			step	 = 	10;
			hBtUp	 = 	70;
			wBtUp	 = 	50;
			//	up
			menu.addButton(new Button("Connector","rect","connector",menu.cor,11,px + step + localX * (step + wBtUp),py - hBtUp,wBtUp,hBtUp,0));
			localX++;
			menu.addButton(new Button("Pipe","rect","pipe",menu.cor,11,px + step + localX * (step + wBtUp),py - hBtUp,wBtUp,hBtUp,0));
			break;
			case	"Level 2":
			px	 = 	52;
			h = 	80;
			py	 = 	width	 - 	10;
			w = 	5;
			step	 = 	10;
			hBtUp	 = 	20;
			wBtUp	 = 	50;
			//	up
			//	menu.addButton(new Button("Level 1","rect","lvl1",color(#FF7040),px + step + localX * (step + wBtUp),py - hBtUp,wBtUp,hBtUp,0));
			localX++;
			//	menu.addButton(new Button("Level 2","rect","lvl2",color(#FFD640),px + step + localX * (step + wBtUp),py - hBtUp,wBtUp,hBtUp,0));
			break;
			case	"Putting":
			px	 = 	50;
				h = 	100;
				py	 = 	0;
				w = 	width	 - 	px	 * 	2;
				step	 = 	10;
				hBtUp	 = 	70;
				wBtUp	 = 	50;
				Cfg.menu_putting	 = menu;
				//	up
				menu.addButton(new Button("var-onHandConstruction","rect","var-onHand",color(#A8FCCF),10,px + step + localX * (step + wBtUp),py + step,wBtUp,hBtUp,0));
				localX++;
				Cfg.localMaterials = new Button("Materials","rect","lcl-putMaterials",color(#A8FCCF),10,px + step + localX * (step + wBtUp),py + step,wBtUp,hBtUp,0);
				menu.addButton(Cfg.localMaterials);
				
				break;
			
		}
		menu.defineConfigurations(px,py,w,h);
	}
}
boolean	toggleMenu(String menuName) {
	for	(Menu	menu	 : 	menus) {
		if	(menu.name.equals(menuName)) {
			menu.active	 = 	!menu.active;
			if	(menu.active	 ==  	false) menu.deactiveAll();
			return	menu.active;
		}
	}
	println("ERRO	ao	processar menu : \n   menu nao reconhecido : '" + menuName + "'");
	return	false;
}
void	modusMenu(String	menuName,boolean active) {
	for	(Menu	menu	 : 	menus)	{
		if	(menu.name.equals(menuName)) {
			menu.active	 = 	active;
			if	(menu.active	 ==  	false) menu.deactiveAll();
		}
	}
}
void	showMenus()	{
	if	(onHandConstruction!= null) {
		if	(Cfg.menu_putting.active ==  false) Cfg.menu_putting.active = true;
	}
	else	Cfg.menu_putting.active = false;
	for	(Menu	menu	 : 	menus) {
		if	(menu.active	 ==  	false) continue;
		menu.show();
		menu.update(mouseX,mouseY,false,false);
	}
}
boolean	updateMenus(boolean left, boolean right) {
	boolean	somethingActivated = false;
	for	(Menu	menu	 : 	menus) {
		if	(menu.active	 ==  	false) continue;
		String	ret	 = 	menu.update(mouseX,mouseY,left,right);
		if	(ret!= 	 "none")	{
			menu.deactiveAllLess(ret);
			somethingActivated	 = 	true;
		}
	}
	return	somethingActivated;
}

//	LAYER	BUTTON
void	modusButton(Button bt,boolean active) {
	_identifyButtonFunction(bt,active,"m");
}
void	toggleButton(Button bt) {
	_identifyButtonFunction(bt,true,"t");
}
void	_identifyButtonFunction(Button bt,boolean active,String mode) {
	//	println(">>"	+	bt.id);
	switch(bt.id)	{
		//	menus
		case	"Construction"	 : 	// cons
		if	(mode	 ==  	  "m")	modusMenu(bt.id,active);
		else	toggleMenu(bt.id);
		break;
		//	sub	menus
		case	"lvl1":
		case	"lvl2":
		if	(mode	 ==  	  "m")	modusMenu(bt.name,active);
		else	toggleMenu(bt.name);
		break;
		//	pieces
		case	"pipe":
		case	"connector":
		if	(active)putOnHand(bt.id);
		break;
	}
}

//	LAYER	PIECES
void	putOnHand(String	id) {
	//	print(">"	+	id+":");
	//	if	(onHandConstruction != null) println(onHandConstruction.id.equals(id));
	//	else	println("");
	for	(Construction	cons	 : Cfg.prefabs) {
		if	(!cons.id.equals(id)) continue;
		//	println("..."+cons.id);
		if	(onHandConstruction	 == null || !onHandConstruction.id.equals(id)) {
			//	if	(onHandConstruction != null) println("..."+onHandConstruction.id.equals(cons.id));
			onHandConstruction	 = 	cons.copy();
		}
		else	onHandConstruction = null;
		//	println(onHandConstruction);
		break;
	}
}
