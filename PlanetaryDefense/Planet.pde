import java.util.Map;

class Planet{
	float x, y, r, vida=100;
	String name;
	color cor;
	float angleTurret=90;
	Bullet bulletTracked = null;
	HashMap<Bullet,Float> bulletsTrackeds = new HashMap<Bullet,Float>();
	float vel  = 4;
	private boolean protecting = false;
	private int raioAction = 3;
  private float timeLastCalc = 0;

	Planet(String nome, float x, float y, float r,color cor){
		this.name = nome;
		this.x = x;
		this.y = y;
		this.r = r;
		this.cor = cor;
	}

	void update(){
		float dist = 0;
		Bullet seeing = null;
		freshTracking();
		
		if (vida <= 0){
			exit();
		}
		if (protecting){
			protection();
		}else{
			for (int i = 0; i < bullets.size(); i++){
			// bullets.get(i).marked = 0;
			boolean jump = false;
			for (Map.Entry b : bulletsTrackeds.entrySet()){
				if(bullets.get(i) == b){
					jump=true;
					break;
				}
			}
			if(jump) continue;
			if(bullets.get(i).localFrom != "planet"){
				float d = dist(this.x, this.y, bullets.get(i).x, bullets.get(i).y);
				if(d < dist || dist == 0){
					dist = d;
					seeing = bullets.get(i);
				}
			}
		}
		if(seeing != null){
			// 
			angleTurret = calcAngle(seeing);
			seeing.marked = 1;
			bulletTracked = seeing;
		}
		}
	}

	private void freshTracking(){
		for (Map.Entry b : bulletsTrackeds.entrySet()){
			if(millis() > (float)b.getValue()){
				bulletsTrackeds.remove(b.getKey());
			}
		}
	}

	private void protect(){
		protecting = !protecting;
	}

	void protection(){
		for (int i = 0; i < bullets.size(); i++){
			boolean cont = false;
			Bullet seeing = bullets.get(i);
			for (Map.Entry b : bulletsTrackeds.entrySet()){
				if(seeing == b){
					cont = true;
					break;
				}
			}
			if(cont) continue;
			//
			if(seeing.localFrom != "planet"){
				if (dist(this.x, this.y, seeing.x, seeing.y) <= raioAction*this.r){
					// seeing.marked = 1;
					bulletTracked = seeing;
					kaboomOn(seeing);
				}
			}
		}
	}
	private void kaboomOn(Bullet b){
		angleTurret = calcAngle(b);
		bulletTracked.marked = 2;
		println("Time: "+timeLastCalc);
		bulletsTrackeds.put(bulletTracked, millis()+timeLastCalc);
		kaboom();
	}

	float calcAngle(Bullet seeing){
		if(seeing==null) return angleTurret;
		float b = atan2(this.y-seeing.y,seeing.x-this.x)*180/PI,d=asin(seeing.speed*sin((seeing.angle+180-b)/180*PI)/vel);
		timeLastCalc = dist(this.x, this.y, seeing.x, seeing.y)/(vel*cos(d)+seeing.speed*cos((seeing.angle+180-b)/180*PI))/60;
		return b-d*180/PI;
	}

	void show(){
		noStroke();
		fill(this.cor);
		circle(this.x, this.y, this.r*2);
		stroke(0);
		line(this.x, this.y, this.x+cos(angleTurret*PI/180)*this.r, this.y-sin(angleTurret*PI/180)*this.r);
		//
		textSize(20);
		fill(0);
		text(name, this.x-textWidth(name)/2, this.y-10);
		text("Vida: "+this.vida, this.x-textWidth("Vida: "+this.vida)/2, this.y+10);
		//
		if (protecting){
			noFill();
			stroke(cor);
			circle(this.x, this.y, raioAction*this.r*2);
		}
	}

	void kaboom(){
		Bullet blt = new Bullet("circle",aurora.x,aurora.y,aurora.angleTurret,vel,#0000FF,2);
		blt.localFrom = "planet";
		bullets.add(blt);
		if (trackBullet){
			bulletTracking = blt;
		}
	}
}
