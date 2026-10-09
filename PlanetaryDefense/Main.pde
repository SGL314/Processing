import java.util.ArrayList;
import java.nio.file.Files;
import java.nio.file.Path;
//import

Planet aurora = null;
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Bullet> removeBullets = new ArrayList<Bullet>();
float timeToDrop = 25, timeLastDrop = timeToDrop/4;
String idRunning = "idr." + hour() + ":" + minute() + ":" + second() + "*" + day() + ":" + month() + ":" + year();
// int tamGrid = initialTamSquare * 20;

// KEY AND MOUSE
float mvx, mvy, zoom=1;

// GAME
boolean rush = false, running = true;
boolean trackBullet = false,mouseTracking=false;
Bullet bulletTracking = null;
ArrayList<Construction> constructions = new ArrayList<Construction>();
ArrayList<Menu> menus = new ArrayList<Menu>();
Configuration Cfg = new Configuration();
Construction onHandConstruction = null, selectedConstruction = null, overConstruction = null;
Inventory Inv = new Inventory();

void setup() {
  size(800, 800);
  aurora = new Planet("Aurora", width/2,height/2, 50, #B550FF);
  timeLastDrop = millis();
  frameRate(60);
	defineMenus();
}

void draw() {
  background(255);
  //
  textSize(15);
  fill(0, 0, 0);
  text(bullets.size()+"", 10+(int)log10(bullets.size()+1)*5, 20);
  text(aurora.bulletsTrackeds.size()+"", 10+(int)log10(aurora.bulletsTrackeds.size()+1)*5, 40);
  //
  if (trackBullet) {
    if (bulletTracking != null) {
      mvx = -bulletTracking.x+width/2;
      mvy = -bulletTracking.y+height/2;
      if (bulletTracking.exists == false) {
        bulletTracking = null;
      }
    } else {
      mvx=aurora.x-width/2;
      mvy=-aurora.y+height/2;
    }
    // mvx/=zoom;
    // mvy*=zoom;
  }
	showMenus();
	// moved
  scale(zoom);
  translate(mvx, mvy);

  drawAll();
}

void drawAll() {
  //
  if (running) {
    aurora.update();
    aurora.show();
    if (millis() - timeLastDrop > timeToDrop && rush) {
      timeLastDrop = millis();
      newBullet();
    }
    //
    ArrayList<Bullet> n_bullets = new ArrayList<Bullet>();
    for (int i = 0; i < bullets.size(); i++) {
      if (bullets.get(i).update()) {
        n_bullets.add(bullets.get(i));
        bullets.get(i).show();
      } else {
        // bullets.get(i).remove();
      }
    }
    bullets = n_bullets;
    n_bullets = new ArrayList<Bullet>();
    for (int i = 0; i < bullets.size(); i++) {
      boolean add=true;
      for (int j = 0; j < removeBullets.size(); j++) {
        if (bullets.get(i) == removeBullets.get(j)) {
          bullets.set(i, null);
          add=false;
        }
      }
      if (add) n_bullets.add(bullets.get(i));
    }
    bullets = n_bullets;
    removeBullets = new ArrayList<Bullet>();
  } else {
    aurora.show();
    //
    for (int i = 0; i < bullets.size(); i++) {
      bullets.get(i).show();
		}
    
  }
}

void newBullet() {
  float a = random(0, 361), d=aurora.r*2*(random(50, 101)/10.0);
  bullets.add(
		new Bullet("circle", aurora.x+d*cos(radians(a)), aurora.y-d*sin(radians(a)), 
		a-180-random(0, 90)+45, 
		1+random(0, 100)/100.0,
		 #FF0000, 2));
}

// KEYBOARD AND MOUSE

void keyPressed() {
	String keysUP = "QWERTYUIOPASDFGHJKLZXCVBNMÇ";
	for (int i = 0; i < keysUP.length(); i++) {
		if (key == keysUP.charAt(i)) key = Character.toLowerCase(key);
			
		}
  switch(key) {
  case 't'://track last bullet
    trackBullet = !trackBullet;
    break;
  case 'r':
    rush = !rush;
    break;
  case 'p':
    aurora.protect();
    break;
	case 'b': // barreira
		aurora.bereer(); 
		break;
	case 'm':// aurora track mouse
		mouseTracking = !mouseTracking;
		break;
  case 'e': // enemy
    newBullet();
    break;
  case ENTER:
    aurora.kaboom();
    break;
  case ' ':
    running = !running;
    break;
	// MENUS
	case 'g' // geral
		:
		toggleMenu("Geral");
		break;
  
	}
}
void mousePressed(){
	boolean left = mouseButton == LEFT,right = mouseButton == RIGHT;
  if (!updateMenus(left,right)) {
    
	}
}
void mouseDragged() {
  mvx += (mouseX - pmouseX)/zoom;
  mvy += (mouseY - pmouseY)/zoom;
}
void mouseWheel(MouseEvent event) {
  float oldZoom = zoom;

  zoom *= pow(2, -event.getCount());

  float maxZ = 100;
  float minZ = 0.01;

  zoom = constrain(zoom, minZ, maxZ);

  float fator = zoom / oldZoom;

  mvx = mouseX / zoom - (mouseX / oldZoom - mvx);
  mvy = mouseY / zoom - (mouseY / oldZoom - mvy);
}

// MENUS
// LAYER MENU
void defineMenus() {
  float px = 0, py = 0, w = 0, h = 0;
  int i, j;
  float step, hBtUp, wBtUp;
  int localX = 0, localY = 0;
  Menu[] menusA = {
    new Menu("Geral", color(#DBDBDB, 64)),
    // new Menu("Inventory", color(#DBDBDB, 64)),
    new Menu("Construction", color(#A8FCCF)),
    new Menu("Level 1", color(#FF7040)),
    new Menu("Level 2", color(#FFD640)),
    // new Menu("Putting", color(#A8FCCF, 64))
  };
  //0 left, 1 right, 2 both
  for (i = 0;
    i   < menusA.length;
    i++) {
    Menu menu = menusA[i];
    menus.add(menu);
    localX = 0;
    // depois de cor = tamtext

    switch(menu.name) {
    case "Geral":
      px = 0;
      h = 100;
      py = width - 100;
      w = 50;
      step = 5;
      hBtUp = 20;
      wBtUp = 20;
      // up
      menu.addButton(new Button("CONS.", "rect", "Construction", color(#FF7040), px + step + localX * (step + wBtUp), py + step, wBtUp, hBtUp, 0));
      // localX++;
      // menu.addButton(new Button("Level 2","rect","lvl2",color(#FFD640),px+step+localX*(step+wBtUp),py-hBtUp,wBtUp,hBtUp,0));
      break;
    case "Inventory":
      w = 200;
      h = height-100*2;
      px = width-w;
      py = height - h;
      step = 5;
      hBtUp = 20;
      wBtUp = 20;
      // up
      int qtdColumns = 4;
      i=0;
      j=0;
      for (Material material : Cfg.materials) {
        menu.addButton(new Button("invmat-"+material.name,
          "rect", "invmat-"+material.id, color(material.cor),
          px + step + i * (step + wBtUp),
          py + step + j * (step + hBtUp), wBtUp, hBtUp, 0));
        i++;
        if (i == qtdColumns) {
          i = 0;
          j++;
        }
      }
      break;
    case "Construction":
      px = 50;
      h = 100;
      py = width - h;
      w = width - px * 2;
      step = 10;
      hBtUp = 20;
      wBtUp = 50;
      // up
      menu.addButton(new Button("Level 1", "rect", "lvl1", color(#FF7040), px + step + localX * (step + wBtUp), py - hBtUp, wBtUp, hBtUp, 0));
      localX++;
      menu.addButton(new Button("Level 2", "rect", "lvl2", color(#FFD640), px + step + localX * (step + wBtUp), py - hBtUp, wBtUp, hBtUp, 0));
      break;
    case "Level 1":
      px = 52;
      h = 80;
      py = width - 10;
      w = 5;
      step = 10;
      hBtUp = 70;
      wBtUp = 50;
      // up
      menu.addButton(new Button("Connector", "rect", "connector", menu.cor, 11, px + step + localX * (step + wBtUp), py - hBtUp, wBtUp, hBtUp, 0));
      localX++;
      menu.addButton(new Button("Pipe", "rect", "pipe", menu.cor, 11, px + step + localX * (step + wBtUp), py - hBtUp, wBtUp, hBtUp, 0));
      break;
    case "Level 2":
      px = 52;
      h = 80;
      py = width - 10;
      w = 5;
      step = 10;
      hBtUp = 20;
      wBtUp = 50;
      // up
      // menu.addButton(new Button("Level 1","rect","lvl1",color(#FF7040),px+step+localX*(step+wBtUp),py-hBtUp,wBtUp,hBtUp,0));
      localX++;
      // menu.addButton(new Button("Level 2","rect","lvl2",color(#FFD640),px+step+localX*(step+wBtUp),py-hBtUp,wBtUp,hBtUp,0));
      break;
    case "Putting":
      px = 50;
      h = 100;
      py = 0;
      w = width - px * 2;
      step = 10;
      hBtUp = 70;
      wBtUp = 50;
      Cfg.menu_putting = menu;
      // up
      menu.addButton(new Button("var-onHandConstruction", "rect", "onHand", color(#A8FCCF), 10, px + step + localX * (step + wBtUp), py + step, wBtUp, hBtUp, 0));
      localX++;
      // menu.addButton(new Button("Level 2","rect","lvl2",color(#FFD640),px+step+localX*(step+wBtUp),py-hBtUp,wBtUp,hBtUp,0));
      break;
    }
    menu.defineConfigurations(px, py, w, h);
		// menu.active = true;
  }
}
boolean toggleMenu(String menuName) {
  for  (Menu menu : menus) {
    if  (menu.name == menuName) {
      menu.active = !menu.active;
      if (menu.active ==  false) menu.deactiveAll();
      return menu.active;
    }
  }
  println("ERRO ao processar menu:\n   menu nao reconhecido: '" + menuName + "'");
  return false;
}
void modusMenu(String menuName, boolean active) {
  for  (Menu menu : menus) {
    if  (menu.name == menuName) {
      menu.active = active;
      if  (menu.active ==  false) menu.deactiveAll();
    }
  }
}
void  showMenus() {
  // if (onHandConstruction!= null) {
  //   if (Cfg.menu_putting.active ==  false) Cfg.menu_putting.active = true;
  // } else Cfg.menu_putting.active = false;
  for  (Menu menu : menus) {
    if  (!menu.active) continue;
    menu.show();
    menu.update(mouseX, mouseY, false, false);
  }
}
boolean updateMenus(boolean left, boolean right) {
  boolean somethingActivated = false;
  for  (Menu  menu : menus) {
    if  (menu.active == false) continue;
    String  ret   = menu.update(mouseX, mouseY, left, right);
    if  (ret!=   "none") {
      menu.deactiveAllLess(ret);
      somethingActivated = true;
    }
  }
  return somethingActivated;
}
//  LAYER  BUTTON
void  modusButton(Button bt, boolean active) {
  _identifyButtonFunction(bt, active, "m");
}
void  toggleButton(Button bt) {
  _identifyButtonFunction(bt, true, "t");
}
void  _identifyButtonFunction(Button bt, boolean active, String mode) {
  // println(">>" + bt.id);
  switch(bt.id) {
    //  menus
  case  "Construction" : // cons
    if  (mode   ==    "m") modusMenu(bt.id, active);
    else  toggleMenu(bt.id);
    break;
    //  sub  menus
  case  "lvl1":
  case  "lvl2":
    if  (mode   ==    "m") modusMenu(bt.name, active);
    else  toggleMenu(bt.name);
    break;
    //  pieces
  case  "pipe":
  case  "connector":
    // if (active)putOnHand(bt.id);
    break;
  }
}

// AUXS

float log10(float x) {
  return log(x)/log(10);
}
