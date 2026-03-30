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
String localMenu = "principal";
HashMap<String ,HashMap<String, String[]>> keybinding = new HashMap<String,HashMap<String,String[]>>();
HashMap<String, String> menuColors = new HashMap<String,String>();
boolean mouseIsRight = false,mouseIsLeft = false;
// tecla, muda localMenu (1 yes, 0 no)
//
ArrayList<Component> components = new ArrayList<Component>();

void setup() {
	size(500,500);
	frameRate(100);
	//
	addButton("principal","#ff0000");
	addingKeybinding("principal","adding","a","1"); addButton("adding","#48ff00");
	addingInKeybinding("principal","remove","r","1"); addButton("remove","#e5ff00");
	addingKeybinding("adding","principal","p","1"); 
	addingInKeybinding("adding","add-memory","m","0"); addButton("add-memory","#00a2ff");
	/*
	principal : adding
	adding : principal
	*/
}

void draw() {
	background(0);
	// n muda position
	text(localMenu,10,10);
	buttons();
	//
	scale(zoom);
	translate(dragX / zoom,dragY / zoom);
	//
	
	showComponents();
	mouseIsRight = false;mouseIsLeft = false;
}

// admin
void addingKeybinding(String menu,String thing,String key,String code1) {
	HashMap<String, String[]> _thing = new HashMap<String, String[]>();
	String[] keys = {key,code1};
	_thing.put(thing,keys);
	keybinding.put(menu,_thing);
	// HashMap<String[]> aux = new HashMap<String[]>();
	// aux.add(new String[]{"]","0"});
	// keybinding.add(local);
}
void addingInKeybinding(String menu,String thing,String key,String code1) {
	String[] keys = {key,code1};
	keybinding.get(menu).put(thing,keys);;
}
//
void showComponents() {
	circle(100,100,10);
	for (Component comp : components) {
		comp.show();
	}
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
		case "add-memory":
			components.add(new Memory("memory","1",1,px,py));
			break;
	}
}
// buttons
void buttons() {
	int tam = 50,padX = 50,px = padX,padY = height - 50 * 2,py = padY,gap = 5;
	// show
	for (String subMenu : keybinding.get(localMenu).keySet()) {
		// print(subMenu + " ");
		fill(unhex("FF" + menuColors.get(subMenu).substring(1)));
		rect(px,py,tam,tam);
		px += tam + gap;
	}
	println("");
	// click
	px = padX;py = padY;
	for (String subMenu : keybinding.get(localMenu).keySet()) {
		if (mouseX >= px && mouseX <= px + tam && mouseY >= py && mouseY <= py + tam && mouseIsLeft) {
			functionner(subMenu,keybinding.get(localMenu).get(subMenu)[1]);
			// println("Acionado: " + localMenu);
		}
		px += tam + gap;
	}
}
void addButton(String menu, String cor) {
	menuColors.put(menu,cor);
}
// movement
void mousePressed() {
	if (mouseButton == LEFT) {
		mouseIsRight = false;
		for (String i : keybinding.get(localMenu).keySet()) {
		    println(i + " - " + keybinding.get(localMenu).get(i)[0].toCharArray()[0]);
			if (key == keybinding.get(localMenu).get(i)[0].toCharArray()[0]) {			
				println("Ativando :" + i);				
				functionner(i,keybinding.get(localMenu).get(i)[1]);
			}
		}
		mouseIsLeft = true;
	}else if (mouseButton == RIGHT) {
		mouseIsRight = true;
		mouseIsLeft = false;
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
	}else{
		dragX = x - ( -(drx + width / 2) / 2 + width / 2);
		dragY = y - ( -(dry + height / 2) / 2 + height / 2);
		// println((-dragX+drx)+" : "+(-dragY+dry)+" | "+zoom);
	}
}
