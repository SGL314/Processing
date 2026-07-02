import java.nio.file.Files;
import java.nio.file.Path;

import java.util.*;

abstract class Construction{
	public String name,id,type,specificId;
	public boolean modusLinearis = false;
	protected boolean effectiveModusLinearis = false;
	public boolean shined = false,negativeShined=false,selected = false;
	private float pax,pay,pbx,pby;
	public float px,py,r,tam;
	public LinkedHashMap<Material,Float> materials = new LinkedHashMap<Material,Float>();
	public ArrayList<LinkedHashMap<Material,Float>> materialsOptions = new ArrayList<LinkedHashMap<Material,Float>>();
	protected ArrayList<Construction> connections = new ArrayList<Construction>();
	PVector[] points = new PVector[4];
	Construction(String id) {
		this.id = id;
		isTypeOfPipe();
		defineSpecificId();
	}
	void defineSpecificId() {
		String letra = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt((int)random(26)) + "";
		this.specificId = this.id + "-" + (int)random(100) + letra + "-" + idRunning + "-" + millis();
	}
	boolean pointInsidePolygon(float mx,float my) {
		boolean inside = false;
		int n = points.length;
		for (int i = 0, j = n - 1; i < n; j = i++) {
			if (((points[i].y > my) != (points[j].y > my)) && 
				(mx < (points[j].x - points[i].x) * (my - points[i].y) /
				       (points[j].y - points[i].y) + points[i].x)) {
				    inside = !inside;
				}
		}
		return inside;
	}
	void show() {};
	void show(String a, boolean b) {};
	abstract protected void _show(boolean canPut);
	abstract void update();
	abstract String getFormatter();
	abstract String getStringOfMe();
	abstract Construction copy();
	void modusLinearis(float a, float b) {}
	void effectiveModusLinearis() {
		_effectiveModusLinearis("normal");
	}
	void effectiveModusLinearis(String modus) {
		_effectiveModusLinearis(modus);
	}
	private void _effectiveModusLinearis(String modus) {
		effectiveModusLinearis = true;
		// pontos dos connects
		pax = connections.get(0).px;
		pay = connections.get(0).py;
		pbx = connections.get(1).px;
		pby = connections.get(1).py;
		// angulo
		float ang = atan2(pby - pay, pbx - pax) * 180 / PI;
		ang *= -1;
		if (ang < 0) { // normalization
			ang *= -1;
			if (ang > 90)
				ang = 270 - (ang - 90);
			else
				ang = 360 - ang;
		} 					
		float beta = 90 - ang;
		// println(beta);
		// println(pax + " " + pay + ";" + pbx + " " + pby);
		ang = ang / 180 * PI;
		beta = beta / 180 * PI;
		// connections
		connections.get(0).connections.add(this);
		connections.get(1).connections.add(this);
		// raws
		float r1 = connections.get(0).r, r2 = connections.get(1).r;
		
		// println(r1 + " " + r2);
		// points
		PVector[] pts = {
			new PVector(pax + cos(beta) * r1,pay - sin(beta) * r1 * ( -1)),
				new PVector(pbx + cos(beta) * r2,pby - sin(beta) * r2 * ( -1)),
				new PVector(pbx - cos(beta) * r2,pby + sin(beta) * r2 * ( -1)),
				new PVector(pax - cos(beta) * r2,pay + sin(beta) * r2 * ( -1))
			};
		int i = 0;
		for (PVector p : pts) {
			points[i] = p;
			i++;
		}
		if (modus.equals("normal")) {
			float coe = sqrt(pow(pax - pbx,2) + pow(pay - pby,2)) / this.tam;
			for (Material mat : materials.keySet()) {
				materials.put(mat,materials.get(mat) * coe);
			}
		}
	}
	private boolean isTypeOfPipe = false,processed_isTypeOfPipe = false;
	public boolean isTypeOfPipe() {
		if (processed_isTypeOfPipe) return isTypeOfPipe;
		for (String typeOfPipe : typeOfPipes) {
			if (this.id.equals(typeOfPipe)) {
				isTypeOfPipe = true;
				break;
			}
		}
		processed_isTypeOfPipe = true;
		return isTypeOfPipe;
	}
	
	void disconnectAll(){
		for (Construction c : connections){
			c.connections.remove(this);
			if (c.isTypeOfPipe) Cfg.preProcessSaving("removeFromConstructions",c); // recursivo pra remover pipes 
		}
		this.connections.clear();
	}
}