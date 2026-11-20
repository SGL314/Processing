abstract class Component {
  String name;
  String type;
  String cor;
  int level;
  float wid, hei, tam;
  float px, py;
  String format="-xxx-";
  float temp = 25;
  String id = "-xxx-";
  float raw;
  Component coupleComponent = null;
  ArrayList<Component> energysConnections = new ArrayList<Component>();
  ArrayList<Component> logicsConnections = new ArrayList<Component>();


  Component(String name, String type, int level, String format_, float px, float py) {
    this.id = name+"_"+loop;
    this.name = name;
    this.type = type;
    this.level = level;
    this.format = format_;
    this.px = px;
    this.py = py;
  }

  boolean show(String typeOfCrown) {
    return show(typeOfCrown, true);
  }
  abstract boolean show(String typeOfCrown, boolean canPut);
  abstract Component copy();
  abstract String toString();
  protected String defaultToString(){
    String txtEnergys = "xxx";
    for (int i = 0;i<energysComponents.size();i++){
      if (i==0) txtEnergys = "";
      txtEnergys += energys
    }
    return this.type + ";" + this.level + ";" + this.px + ";" + this.py +";"+txtEnergys+";"+txtLogics;
  }

  private boolean verifyCollision(Component comp) {
    switch (this.format+"_"+comp.format) {
    case "square_square":
      return caseCollision_sqsq(comp);
    case "circle_square":
      return caseCollision_sqci(this, comp);
    case "square_circle":
      return caseCollision_sqci(comp, this);
    case "circle_circle":
      return caseCollision_cici(comp);
    default:
      println("Collision not defined in verifyCollision() : " + this.format+"_"+comp.format);
      return false;
    }
  }
  private boolean caseCollision_sqsq(Component comp) {
    float ptsA[][] = {
      {this.px-this.tam/2, this.py-this.tam/2},
      {this.px+this.tam/2, this.py-this.tam/2},
      {this.px+this.tam/2, this.py+this.tam/2},
      {this.px-this.tam/2, this.py+this.tam/2}
    };
    float ptsB[][] = {
      {comp.px-comp.tam/2, comp.py-comp.tam/2},
      {comp.px+comp.tam/2, comp.py-comp.tam/2},
      {comp.px+comp.tam/2, comp.py+comp.tam/2},
      {comp.px-comp.tam/2, comp.py+comp.tam/2}
    };
    boolean v1 = false;
    for (int i = 0; i < ptsA.length; i++) {
      v1 = ptsB[0][0] < ptsA[i][0] && ptsA[i][0] < ptsB[1][0] && ptsB[1][1] < ptsA[i][1] && ptsA[i][1] < ptsB[2][1];
      if (v1) return true;
    }
    for (int i = 0; i < ptsB.length; i++) {
      v1 = ptsA[0][0] < ptsB[i][0] && ptsB[i][0] < ptsA[1][0] && ptsA[1][1] < ptsB[i][1] && ptsB[i][1] < ptsA[2][1];
      if (v1) return true;
    }
    boolean byMinDits = dist(this.px, this.py, comp.px, comp.py) < this.tam/2 + comp.tam/2;
    return v1 || byMinDits;
  }
  private boolean caseCollision_sqci(Component compC, Component compS) {
    float pts[][] = {
      {compS.px-compS.tam/2, compS.py-compS.tam/2},
      {compS.px+compS.tam/2, compS.py-compS.tam/2},
      {compS.px+compS.tam/2, compS.py+compS.tam/2},
      {compS.px-compS.tam/2, compS.py+compS.tam/2}
    };
    // by points inner
    for (int i = 0; i < pts.length; i++) {
      if (dist(pts[i][0], pts[i][1], compC.px, compC.py) < compC.tam/2) return true;
    }
    // by dist lateral
    float minDistLateral = compS.tam/2 + compC.raw;
    boolean v1 = abs(compS.py-compC.py)<minDistLateral,
      v2=abs(compS.px-compC.px)<minDistLateral;
    if (v1&&v2) return true;
    return false;
  }
  private boolean caseCollision_cici(Component comp) {
    return dist(this.px, this.py, comp.px, comp.py) < this.raw + comp.raw;
  }

  protected void pre_showAsComponent(String typeOfCrown) {
    pre_showAsComponent(typeOfCrown, true);
  }
  protected void pre_showAsComponent(String typeOfCrown, boolean canPut) {
    noStroke();
    if (canPut) fill(unhex("FF" + this.cor.substring(1)));
    else fill(#F70707);
  }
  protected void pos_showAsComponent(String typeOfCrown) {
   
    if (showHeat) showMyHeat();
    if (typeOfCrown!="none") this.showCrown(typeOfCrown);
    // if (showEnergysWires) showEnergysWires();
  }

  public void showCrown(String type) {
    if (type=="none") return;
    switch(type) {
    case "crown-remove":
      stroke(#B20B05);
      break;
    case "crown-normal":
      stroke(#24B205);
      break;
    case "crown-selected":
      stroke(#DBD400);
      break;
    default:
      println("Crown not defined in showCrown() : " + type);
      stroke(unhex("FF0000"));
    }
    float percent = 0.25;
    noFill();
    switch (this.format) {
    case "square":
      rect(this.px-this.wid/2-this.tam*percent/2,
        this.py-this.hei/2-this.tam*percent/2,
        this.wid*(1+percent), this.hei*(1+percent));
      break;
    case "circle":
    // println("me");
      circle(this.px, this.py, 2*this.raw*(1+percent));
      break;
    default:
      println("Format not defined in showCrown() : " + this.format);
    }
    stroke(#000000);
  }
  private void showEnergyWires() {
  }

  void fillInfraRed() {
    float tempK = temp + 273.15;
    float zeroAbsoluto = -273.15;
    float passo = 273.15; // Cada transição completa de canal (0 a 255) dura 273.15 °C
    float limiteVermelho = passo * 3; // 819.45 °C

    if (tempK <= zeroAbsoluto) {
      // Azul puro no zero absoluto (ou abaixo)
      fill(0, 0, 255);
    } else if (tempK <= 0) {
      // Azul puro (0, 0, 255) -> Ciano puro (0, 255, 255)
      float g = map(tempK, zeroAbsoluto, 0, 0, 255);
      fill(0, g, 255);
    } else if (tempK <= passo) {
      // Ciano puro (0, 255, 255) -> Verde puro (0, 255, 0) [até 273.15 °C]
      float b = map(tempK, 0, passo, 255, 0);
      fill(0, 255, b);
    } else if (tempK <= passo * 2) {
      // Verde puro (0, 255, 0) -> Amarelo puro (255, 255, 0) [até 546.30 °C]
      float r = map(tempK, passo, passo * 2, 0, 255);
      fill(r, 255, 0);
    } else if (tempK <= limiteVermelho) {
      // Amarelo puro (255, 255, 0) -> Vermelho puro (255, 0, 0) [até 819.45 °C]
      float g = map(tempK, passo * 2, limiteVermelho, 255, 0);
      fill(255, g, 0);
    } else {
      // Acima de 819.45 °C -> Roxo puro
      fill(148, 0, 211); // Ou fill(255, 0, 255) para magenta/roxo RGB máximo
    }
  }
  void showMyHeat() {
    textSize(10);
    fillInfraRed();
    String texto = round(this.temp*10)/10.0+"°C";
    text(texto, this.px-textWidth(texto)/2, this.py);
  }
}
