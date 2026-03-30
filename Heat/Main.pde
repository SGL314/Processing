import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;

import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.HashMap; // Importação necessária
import java.io.Serializable;

// movement
float zoom = 1,lastZoom = 1,dragX = 0,dragY = 0;
// keybinding
ArrayList<String> mouseClicks = new ArrayList<String>();
int tam_mouseClicks = 10;
int minLoops_doubleClick = 20;
String localMenu = "principal";
HashMap<String ,HashMap<String, String[]>> keybinding = new HashMap<String,HashMap<String,String[]>>();
HashMap<String, String> menuColors = new HashMap<String,String>();
boolean mouseIsRight = false,mouseIsLeft = false;
// tecla, muda localMenu (1 yes, 0 no)
// configs
int mapSize = 100;
float maxHeat = 100,minHeat = -100,addHeat = 0;
// varibales
int loop = 0;
ArrayList<Matrix> map = new ArrayList<Matrix>();
ArrayList<Item> selectedItems = new ArrayList<Item>();

void setup() {
	size(500,500);
	frameRate(100);
	//
	addButton("principal","#ff0000");
	addingKeybinding("principal","thermal","l","1"); addButton("thermal","#ffe600");
	// addingInKeybinding("principal","remove","r","1"); addButton("remove","#e5ff00");
	// thermal
	addingKeybinding("thermal","principal","p","1"); 
	addingKeybinding("thermal","temperature","q","0"); addButton("temperature","#09ff00");
	addingKeybinding("thermal","heater","w","0"); addButton("heater","#ff1e00");
	addingKeybinding("thermal","colder","s","0"); addButton("colder","#0051ff");
	//
	// addingInKeybinding("adding","add-memory","m","0"); addButton("add-memory","#00a2ff");
	/*
	principal : adding
	adding : principal
	*/
	createMap(mapSize);
}
void createMap(int tam) {
	ArrayList<String> auxs = new ArrayList<String>();
	auxs.add("phisical");
	String type = "air";
	//
	for (String aux : auxs) {
		Item[][] add = new Item[tam][tam];
		for (int i = 0; i < tam; i++) {
			for (int j = 0; j < tam; j++) {
				add[i][j] = new Item(type,i * width / tam,j * width / tam,width / tam);
			}
		}
		map.add(new Matrix(aux,add));
	}
}
//
void draw() {
	background(128);
	// n muda position
	//
	text(localMenu,10,10);
	// in zoom
	scale(zoom);
	translate(dragX / zoom,dragY / zoom);
	// 
	showAll();
	// out zoom
	translate(-dragX / zoom,-dragY / zoom);
	scale(1/zoom);
	//
	buttons(false);
	
	mouseIsRight = false;mouseIsLeft = false;
	loop += 1;
}

// admin
void addingKeybinding(String menu,String thing,String key,String code1) {
	if (keybinding.get(menu) == null) {
		
		HashMap<String, String[]> _thing = new HashMap<String, String[]>();
		String[] keys = {key,code1};
		_thing.put(thing,keys);
		keybinding.put(menu,_thing);
	} else {
		addingInKeybinding(menu,thing,key,code1);
	}
	// HashMap<String[]> aux = new HashMap<String[]>();
	// aux.add(new String[]{"]","0"});
	// keybinding.add(local);
}
void addingInKeybinding(String menu,String thing,String key,String code1) {
	String[] keys = {key,code1};
	keybinding.get(menu).put(thing,keys);;
}
//
void showAll() {
	fill(#ffffff);
	circle(100,100,10);
	for (Matrix mat : map) {
		mat.show(loop);
	}
}
// game
Item getItemAtMouse() {
	// converter coordenada da tela → mundo
	float worldX = (mouseX - dragX) / zoom;
	float worldY = (mouseY - dragY) / zoom;
	
	// tamanho de cada célula
	int cellSize = width / mapSize;
	
	// índice da grid
	int i = (int)(worldX / cellSize);
	int j = (int)(worldY / cellSize);
	
	// segurança (evitar sair do array)
	if (i < 0 || i >= mapSize || j < 0 || j >= mapSize) {
		return null;
	}
	
	// pegando da primeira layer (phisical)
	return map.get(0).matrix[i][j];
}
void functionner(String thing,String mode) {
	if (mode == "1") {
		localMenu = thing;
		println("'localMenu' mudou para " + localMenu);
		return;
	}
	//
	float px = mouseX - dragX;
	float py = mouseY - dragY;
	switch(thing) {
		case "heater":
			addHeat += 1;
			break;
		case "colder":
			addHeat -= 1;
			break;
		case "temperature":
			break;
	}
	addHeat = (addHeat>maxHeat) ? maxHeat : (addHeat<minHeat) ? minHeat : addHeat;
}

// keyboard
void keyPressed() {
	for (String i : keybinding.get(localMenu).keySet()) {
		println(i + " - " + keybinding.get(localMenu).get(i)[0].toCharArray()[0]);
		if (key == keybinding.get(localMenu).get(i)[0].toCharArray()[0]) {
			println("Ativando :" + i);
			functionner(i,keybinding.get(localMenu).get(i)[1]);
		}
	}
}

// buttons
boolean buttons(boolean doProcessment) {
	int tam = 50,padX = 50,px = padX,padY = height - 50 * 2,py = padY,gap = 5;
	// show
	for (String subMenu : keybinding.get(localMenu).keySet()) {
		// print(subMenu + " ");
		fill(unhex("FF" + menuColors.get(subMenu).substring(1)));
		rect(px,py,tam,tam);
		// text
		fill(#000000);
		textSize(10);
		text(subMenu,px + 10,py + 20);
		text(keybinding.get(localMenu).get(subMenu)[0],px + tam / 2,py + 30);
		findIf_buttonInteractiveText();
		// loop
		px += tam + gap;
	}
	// println("");
	// click
	if (!doProcessment) return false;
	px = padX;py = padY;
	boolean done = false;
	for (String subMenu : keybinding.get(localMenu).keySet()) {
		if (mouseX >= px && mouseX <= px + tam && mouseY >= py && mouseY <= py + tam && mouseIsLeft) {
			functionner(subMenu,keybinding.get(localMenu).get(subMenu)[1]);
			// println("Acionado: " + localMenu);
			done = true;
		}
		px += tam + gap;
	}
	return done;
}
void addButton(String menu, String cor) {
	menuColors.put(menu,cor);
}
// movement
void mousePressed() {
	//
	mouseClicks.add((mouseButton ==  LEFT) ? "L" : "R" + "-" + loop);
	if (mouseClicks.size() > tam_mouseClicks) {
		mouseClicks.remove(0);
	}
	//
	if (mouseButton == LEFT) {
		mouseIsRight = false;
		mouseIsLeft = true;
		boolean doneFunc = buttons(true);
		//
		for (String i : keybinding.get(localMenu).keySet()) {
			println(i + " - " + keybinding.get(localMenu).get(i)[0].toCharArray()[0]);
			if (key == keybinding.get(localMenu).get(i)[0].toCharArray()[0]) {			
				println("Ativando: " + i);				
				functionner(i,keybinding.get(localMenu).get(i)[1]);
				doneFunc = true;
			}
		}
		// put an selected
		if (getItemAtMouse()!= null && !doneFunc) {
			Item item = getItemAtMouse();
			selectedItems.add(item);
			item.selected = true;
			println("Selects: " + selectedItems.size());
		}
		
	} else if (mouseButton == RIGHT) {
		mouseIsRight = true;
		mouseIsLeft = false;
		//
		int t = mouseClicks.size();
		if (t<=1) return;
		if (mouseClicks.get(t - 1).split("-")[0].equals("R") && mouseClicks.get(t - 2).split("-")[0].equals("R")) {
			int a = Integer.parseInt(mouseClicks.get(t - 1).split("-")[1]);
			int b = Integer.parseInt(mouseClicks.get(t - 2).split("-")[1]);
			if (a-b<=minLoops_doubleClick){
				for (Item i : selectedItems) {
					i.selected = false;
				}
				selectedItems.clear();
			}
		}
	}
	
}
void mouseDragged() {
	// translate(mouseX-pmouseX,);
	dragX += mouseX - pmouseX;
	dragY += mouseY - pmouseY;
}
void mouseWheel(MouseEvent event) {
	// translate(dragX*zoom,dragY*zoom);
	int x = mouseX;
	int y = mouseY;
	int drx = (int)dragX;
	int dry = (int)dragY;
	
	lastZoom = zoom; 
	lastZoom *= pow(2,event.getCount() * ( -1));
	
	zoom = lastZoom;
	
	if (pow(2,event.getCount() * ( -1)) > 1) {
		dragX += (width / 2 - mouseX);
		dragY += (height / 2 - mouseY);
		dragX += -x + drx;
		dragY += -y + dry;
	} else{
		dragX = x - ( -(drx + width / 2) / 2 + width / 2);
		dragY = y - ( -(dry + height / 2) / 2 + height / 2);
		// println((-dragX+drx)+" : "+(-dragY+dry)+" | "+zoom);
	}
}
