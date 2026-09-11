class Planet{
	float x, y, r;
	color cor;
	float angleTurret=90;
	Bullet bulletTracked = null;
	ArrayList<Bullet> bulletsTrackeds = new ArrayList<Bullet>();
	float vel  = 4;

	Planet(float x, float y, float r,color cor){
		this.x = x;
		this.y = y;
		this.r = r;
		this.cor = cor;
	}

	void update(){
		float dist = width;
		Bullet seeing = null;
		for (int i = 0; i < bullets.size(); i++){
			bullets.get(i).marked = false;
			boolean jump = false;
			for (Bullet b : bulletsTrackeds){
				if(bullets.get(i) == b){
					jump=true;
					break;
				}
			}
			if(jump) continue;
			if(bullets.get(i).localFrom != "planet"){
				float d = dist(this.x, this.y, bullets.get(i).x, bullets.get(i).y);
				if(d < dist){
					dist = d;
					seeing = bullets.get(i);
				}
			}
		}
		if(seeing != null){
			// 
			angleTurret = calcAngle(seeing);
			seeing.marked = true;
			bulletTracked = seeing;
			
		}
	}

	float calcAngle(Bullet seeing){
		float b = atan2(this.y-seeing.y,seeing.x-this.x)*180/PI;
		return b-asin(seeing.speed*sin((seeing.angle+180-b)/180*PI)/vel)*180/PI;
	}

	void show(){
		noStroke();
		fill(this.cor);
		circle(this.x, this.y, this.r*2);
		stroke(0);
		line(this.x, this.y, this.x+cos(angleTurret*PI/180)*this.r, this.y-sin(angleTurret*PI/180)*this.r);
	}

	void kaboom(){
		Bullet blt = new Bullet("circle",aurora.x,aurora.y,aurora.angleTurret,vel,#0000FF,2);
		blt.localFrom = "planet";
		bulletsTrackeds.add(bulletTracked);
		bullets.add(blt);
	}
}