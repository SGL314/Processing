import java.nio.file.Files;
import java.nio.file.Path;

import java.util.*;

abstract class Construction {
  public String name, id, type, specificId;
  public boolean modusLinearis = false;
  protected boolean effectiveModusLinearis = false;
  public boolean shined = false, negativeShined=false, selected = false, hide = false;
  private boolean isTypeOfPipe = false, isTypeOfConnector = false, isTypeOfMacroPiece= false;
  private float pax, pay, pbx, pby;
  public float px, py, r, tam;
  private float coeMats = 1;
  public boolean canPutByMaterials = true;
  public LinkedHashMap<Material, Float> materials = new LinkedHashMap<Material, Float>();
  public ArrayList<LinkedHashMap<Material, Float>> materialsOptions = new ArrayList<LinkedHashMap<Material, Float>>();
  protected ArrayList<Construction> connections = new ArrayList<Construction>();
  Material material; // material geral
  float scaleShow = 1f; // for macropieces
  float[][] points = null;
  Construction(String id) {
    this.id = id;
    _isTypeOfWhat();
    defineSpecificId();
  }
  void defineSpecificId() {
    String letra = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt((int)random(26)) + "";
    this.specificId = this.id + "-" + (int)random(100) + letra + "-" + Cfg.idRunning + "-" + millis();
  }
  
  void show() {
  };
  void show(String a, boolean b) {
  };
  abstract protected void _show(boolean canPut);
  abstract void update();
  void modusLinearis(float a, float b) {
  }
  void definePointsConstruit() {
  };
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
    if (modus.equals("normal")) {
      connections.get(0).connections.add(this);
      connections.get(1).connections.add(this);
    }
    // raws
    float r1 = connections.get(0).r, r2 = connections.get(1).r;

    // println(r1 + " " + r2);
    // points
    float[][] pts = {
      {pax + cos(beta) * r1, pay - sin(beta) * r1 * ( -1)},
      {pbx + cos(beta) * r2, pby - sin(beta) * r2 * ( -1)},
      {pbx - cos(beta) * r2, pby + sin(beta) * r2 * ( -1)},
      {pax - cos(beta) * r2, pay + sin(beta) * r2 * ( -1)}
    };
    int i = 0;
    points = new float[4][2];
    for (float[] p : pts) {
      points[i] = p;
      i++;
    }
    if (modus.equals("normal")) {
      float coe = sqrt(pow(pax - pbx, 2) + pow(pay - pby, 2)) / this.tam;
      for (Material mat : materials.keySet()) {
        materials.put(mat, materials.get(mat) * coe);
      }
    }
  }

  private void _isTypeOfWhat() {
    for (String type : typeOfPipes) {
      if (this.id.equals(type)) {
        isTypeOfPipe = true;
        break;
      }
    }
    for (String type : typeOfConnectors) {
      if (this.id.equals(type)) {
        isTypeOfConnector = true;
        break;
      }
    }
    for (String type : typeOfMacroPieces) {
      if (this.id.equals(type)) {
        isTypeOfMacroPiece = true;
        break;
      }
    }
    if (!(isTypeOfPipe||isTypeOfConnector||isTypeOfMacroPiece)) {
      println("ERRO ao processar construciton of a Construction:\n   type '" + id + "' is an unknown type, Construction._isTypeOfWhat()");
    }
  }

  void disconnectAll() {
    for (Construction c : connections) {
      c.connections.remove(this);
      println("Disconnecting " + c.specificId + " ->cons " + this.specificId);
      if (c.isTypeOfPipe) Cfg.preProcessSaving("removeFromConstructions", c); // recursivo pra remover pipes
    }
    this.connections.clear();
  }
  // COPY
  String getFormatter() {
    //	P;Connector;connector;metal;init;0;0;metal,10_aluminium,4
    String text = type + ";" + name + ";" + id + ";" + material.id + ";" + tam;
    text += ";" + px + ";" + py + ";";

    for	(int i = 0; i < materials.size(); i++) {
      Material	mat = materials.keySet().toArray(new Material[0])[i];
      float	qtd = materials.get(mat);
      text += mat.id + "," + qtd;
      if	(i <	materials.size() - 1) text += "_";
    }
    return text;
  }
  String getStringOfMe() {
    //	P;Connector;connector;metal;tam;px;py;metal,10_aluminium,4;
    //	specificId;id_id_id;modusLin.;effect.ModusLin.;istypeofpipe;
    String text = getFormatter() + ";" + specificId + ";";

    for	(int i = 0; i < connections.size(); i++) {
      text += connections.get(i).specificId;
      if	(i < connections.size() - 1) text += "_";
    }
    if	(connections.size() == 0) text += "---";
    text += ";" + modusLinearis + ";" + effectiveModusLinearis + ";" + isTypeOfPipe;
    return	text;
  }
  Construction copy() {
    // println(type);
    Construction copy = Cfg.disformatter(this.getFormatter());
    copy.materialsOptions = this.materialsOptions;
    return copy;
  }

  // AUX
  Material getMaterialFromMaterialsByIndex(int ind) {
    int i = 0;
    for (Material mat : materials.keySet()) {
      if (i == ind) return mat;
      i++;
    }
    println("ERRO ao processar construction:\n   indice ultrapassou o tamanho da lista: '" + ind + "' for construction '" + this.id + "' in Construction.getMaterialFromMaterialsByIndex()");
    return null;
  }

  // INTERSECTION
  boolean verByVectorialProduct(Construction cons) {
    // this.definePointsConstruit(); // acho q n é necessario
    float[][][] as = new float[this.points.length][2][2];
    //
    for (int i=0; i<this.points.length; i++) {
      as[i][0] = this.points[i];
      as[i][1] = this.points[(i+1)%this.points.length];
      // se tem o ponto do objeto q esta sendo movido dentro do q esta sendo verificado
      if (cons.points!=null &&cons.pointInsidePolygon(as[i][0][0], as[i][0][1])) return true;
    }
    if (cons.points!=null) {
      float[][][] bs = new float[cons.points.length][2][2];
      for (int i=0; i<cons.points.length; i++) {
        bs[i][0] = cons.points[i];
        bs[i][1] = cons.points[(i+1)%cons.points.length];
        
      }
      //
      for (int i=0; i<as.length; i++) {
        for (int j=0; j<bs.length; j++) {
          if (intersecta(as[i][0], as[i][1], bs[j][0], bs[j][1])) return true;
        }
      }
    } else if (cons.isTypeOfConnector) {
      float[] center = {cons.px, cons.py};
      for (int i=0; i<as.length; i++) {
        if (intersecta_circ(as[i][0], as[i][1], center, cons.r)) return true;
      }
    }

    return false;
  }
  float orient(float[] a, float[] b, float[] c) {
    return (b[0]-a[0])*(c[1]-a[1]) - (b[1]-a[1])*(c[0]-a[0]);
  }
  boolean intersecta(float[] a, float[] b,
    float[] c, float[] d) {

    float o1 = orient(a, b, c);
    float o2 = orient(a, b, d);
    float o3 = orient(c, d, a);
    float o4 = orient(c, d, b);

    return o1*o2 < 0 && o3*o4 < 0;
  }
  boolean intersecta_circ(float[] a, float[] b,
    float[] c, float r) {

    float[] ab = {b[0]-a[0], b[1]-a[1]};
    float[] ac = {c[0]-a[0], c[1]-a[1]};

    float t = (ac[0]*ab[0] + ac[1]*ab[1])/(ab[0]*ab[0] + ab[1]*ab[1]);

    t = constrain(t, 0, 1);

    float[] p = {a[0]+ab[0]*t, a[1]+ab[1]*t};

    return dist(p[0], p[1], c[0], c[1]) < r;
  }
  boolean pointInsidePolygon(float mx, float my) {
    boolean inside = false;
    int n = points.length;
    for (int i = 0, j = n - 1; i < n; j = i++) {
      if (((points[i][1] > my) != (points[j][1] > my)) &&
        (mx < (points[j][0] - points[i][0]) * (my - points[i][1]) /
        (points[j][1] - points[i][1]) + points[i][0])) {
        inside = !inside;
      }
    }
    return inside;
  }
}
