abstract class Construction{
	public String name,id,type,specificId;
	public boolean modusLinearis = false;
	protected boolean effectiveModusLinearis = false;
	public boolean shined = false,selected = false;
	private float pax,pay,pbx,pby;
	public float px,py,r,tam;
	public LinkedHashMap<Material,Float> materials = new LinkedHashMap<Material,Float>();
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
	void effectiveModusLinearis() {}
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
}