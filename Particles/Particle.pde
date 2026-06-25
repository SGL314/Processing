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
	ArrayList<Particle> cons = new ArrayList<Particle>();
	// specifics constants
	float width = potAttracktion - potRepulsionStrong,midpoint = (potRepulsionStrong + potAttracktion) * 0.5f;;
	//
	Particle(String type,float x, float y) {
		this.type = type;
		this.x = x;
		this.y = y;
		form();
	}
	void form() {
		this.r = 2;
		this.vx = 0;
		this.vy = 0;
		switch(type) {
			case "a":
				this.cor = color(255,0,0);
				break;
			case "b":
				this.cor = color(255,255,0);
				break;
			case "c":
				this.cor = color(0,255,0);
				break;
			case "d":
				this.cor = color(0,255,255);
				break;
			case "e":
				this.cor = color(255,0,255);
				break;
			case "f":
				this.cor = color(0,0,255);
				break;
			case "g":
				this.cor = color(255,128,0);
				break;
			default:
			this.cor = color(255,255,255);
		}
	}
	
	void update() {
		this.x += this.vx * deltaTime;
		this.y += this.vy * deltaTime;
		float total_forceX = 0,total_forceY = 0;
		float density = 0;
		
		for (Particle p : particles) {
			if (p != this) {
				// distance
				float dx = p.x - this.x;
				float dy = p.y - this.y;
				float dist = sqrt(dx * dx + dy * dy);
				//
				float force = 0;
				float coeForce = 50;
				if (dist == 0) {
					force = -1;
					total_forceX += force * random(0,1) * coeForce;
					total_forceY += force * random(0,1) * coeForce;
				} else{
					//calc
					if (dist <= potRepulsionStrong) {
						force = (dist / (potRepulsionStrong) - 1) * 2; // Stronger rep
					} else if (dist <= potAttracktion) {
						force =  attraction * getSignalForce(this.type, p.type) * (1.0f - abs(dist - midpoint) / (width * 0.5f));
					} 
					//
					total_forceX += force * dx / dist * coeForce;
					total_forceY += force * dy / dist * coeForce;
				}
			}
		}
		// apply forces
		// println(total_forceX+" : "+total_forceY+" | density: "+density);
		float forcesCons[] = phisicsCons();
		total_forceX += forcesCons[0];
		total_forceY += forcesCons[1];
		this.vx += total_forceX * deltaTime;
		this.vy += total_forceY * deltaTime;
		// max vel
		float maxVel = 1;
		if (mag(this.vx, this.vy) > maxVel) {
			this.vx = this.vx / mag(this.vx, this.vy) * maxVel;
			this.vy = this.vy / mag(this.vx, this.vy) * maxVel;
		}
		// cons
		
		// arrasto
		float arr = 0.02;
		this.vx *= 1 - arr;
		this.vy *= 1 - arr;
		
	}
	
	float getSignalForce(String type1, String type2) {
		return geralMapForces.get(type1 + type2);
	}
	
	void show() {
		if (this.shined || this.selected) {
			fill(this.cor,32);
			circle(this.x,this.y,this.r * 6);
		}
		fill(this.cor,128);
		circle(this.x,this.y,this.r * 2);
		
		// shadow attracktion
		if (showShadows) {
			stroke(1);
			fill(255,0,0,10);
			circle(x,y,potAttracktion*2);
			fill(0,0,255,10);
			circle(x,y,potRepulsionStrong*2);
			fill(0,255,0,10);
			circle(x,y,regionConnection*2);
		}
		// cons
		
		showCons();
	}
	
	float[] phisicsCons() {
		float forces[] = {0,0} ,strongForceConnection = 0;
		try{
			for (Particle p : cons) {
				// distance
				float dx = p.x - this.x;
				float dy = p.y - this.y;
				float dist = sqrt(dx * dx + dy * dy);
				//
				if (dist >= regionConnection) {
					cons.remove(p);
					continue;
				}else{
					float normal = 1f;
					strongForceConnection = normal+10f * getSignalForce(this.type, p.type);
					
					if (dist > regionConnection) { // atrai se longe
						strongForceConnection = abs(strongForceConnection);
					}else{
						if (dist < potRepulsionStrong) { // repele se perto d+
							strongForceConnection = -abs(strongForceConnection);
						}else{
							if (strongForceConnection > 0) {
								strongForceConnection = map(dist, potRepulsionStrong, potAttracktion, 0, strongForceConnection);
							}else{
								strongForceConnection = map(dist, potRepulsionStrong, potAttracktion, strongForceConnection,0);
							}
						}
					}
					
					
				}
				forces[0] += dx / dist * strongForceConnection;
				forces[1] += dy / dist * strongForceConnection;
			}
		} catch(Exception e) {}
		return forces;
	}
	void showCons() {
		stroke(255);
		strokeWeight(0.5f);
		for (Particle p : cons) {
			float dx = p.x - this.x;
			float dy = p.y - this.y;
			
			float dist = sqrt(dx * dx + dy * dy);
			
			float x1 = this.x + dx / dist * r;
			float y1 = this.y + dy / dist * r;
			
			float x2 = p.x - dx / dist * r;
			float y2 = p.y - dy / dist * r;
			
			if (dist >= regionConnection) stroke(255,0,0);
			line(x1, y1, x2, y2);
			// line(this.x,this.y,p.x,p.y);
		}
		strokeWeight(0);
	}
	
	void add(Particle p) {
		if (p == this) return;
		if (this.cons.contains(p)) {
			this.cons.remove(p);
		} else{
			this.cons.add(p);
		}
	}
}
