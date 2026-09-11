import java.util.ArrayList;

Planet aurora = new Planet(400, 700, 100,#B550FF);
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Bullet> removeBullets = new ArrayList<Bullet>();
float timeToDrop = 4000,timeLastDrop = timeToDrop/4;


void setup(){
	size(800,800);
	timeLastDrop = millis();
	frameRate(60);
}


void draw(){
	background(255);
	aurora.update();
	aurora.show();
	// if (millis() - timeLastDrop > timeToDrop){
	// 	timeLastDrop = millis();
	// 	bullets.add(new Bullet("circle",1,random(0,width/2),90-random(0,90),1,#FF0000,10));
	// }
	//
	ArrayList<Bullet> n_bullets = new ArrayList<Bullet>();
	for (int i = 0; i < bullets.size(); i++){
		if(bullets.get(i).update()){
			n_bullets.add(bullets.get(i));
			bullets.get(i).show();
		}else{
			// bullets.get(i).remove();
		}
	}
	bullets = n_bullets;
	n_bullets = new ArrayList<Bullet>();
	for (int i = 0; i < bullets.size(); i++){
		boolean add=true;
		for (int j = 0; j < removeBullets.size(); j++){
			if(bullets.get(i) == removeBullets.get(j)){
				bullets.set(i, null);
				add=false;
			}
		}
		if(add) n_bullets.add(bullets.get(i));
	}
	bullets = n_bullets;
	removeBullets = new ArrayList<Bullet>();
}

void keyPressed(){
	switch(key){
		case ENTER:
			bullets.add(new Bullet("circle",1,random(0,width/2),45-random(0,90),1,#FF0000,10));
			break;
		case ' ':
			aurora.kaboom();
			break;
	}
}

