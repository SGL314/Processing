class Astro{
  float dist;
  float r;
  float ang;
  float omega;
  color cor;
  double massa;
  double x=0,y=0;
  double vel=0,angVel=0;
  double velX=0,velY=0;
  double cx = 0,cy =0;
  Vector[] Vets;
  private double G = 6.6743*pow(10,-11);
  int lineTraj = 0;
  boolean isStar = false;
  boolean onLux = false;
  
  ArrayList<Point> rastro = new ArrayList<Point>();

  int lineVel = 0;
  int lineFor = 0;

  public color padcolor(int sum){
    return color((int) random(255-sum)+sum,(int) random(255-sum)+sum,(int) random(255-sum)+sum);
  }
  
  Astro(double massa,double x,double y){
    this.omega = ((float)random(1000) +1)/50;
    this.ang = 0;
    this.r = (pow((float) massa/PI,0.5f)+5/0.3)*0.3f;
    this.dist = (float)random(width/3)+75+this.r/2;
    this.cor = padcolor(128);
    this.massa = massa;
    this.x = x;
    this.y = y;
  }
  Astro(double massa,double x,double y,double vel,double angVel){
    this.omega = ((float)random(1000) +1)/50;
    this.ang = 0;
    this.r = (pow((float) massa/PI,0.5f)+5/0.5)*0.5;
    this.dist = (float)random(width/3)+75+this.r/2;
    this.cor = padcolor(128);
    this.massa = massa;
    this.x = x;
    this.y = y;
    this.vel = vel;
    this.angVel = angVel;
  }

  void init(int qt){
    this.Vets = new Vector[qt];
    for (int i=0;i<qt;i++){
      Vets[i] = new Vector(0,0);
    }

    

    double descX=0,descY=0;
    float ang;
    ang = round((float) (this.angVel*1000000))/1000000;
    this.angVel *= PI/180;
    this.angVel = (double) round((float) (this.angVel*1000000))/1000000;

    if (ang != 90 && ang != 270){
      descX = vel*cos((float) this.angVel);
    }
    if (ang != 0 && ang != 180){
      descY = vel*sin((float) this.angVel);
    }

    //print(ang + ">" + descX + " : " + descY + "\n");

    this.velX += descX;
    this.velY += descY;

  }

  void forces(){
    double compX=0,compY=0;
    float a;
    for (Vector v : Vets){
      a = round((float) v.a*180/PI*1000000)/1000000;
      if (a != 90 && a != 270)
        compX += v.v*cos((float) v.a);
      if (a != 0 && a != 180)
        compY += v.v*sin((float) v.a);
    }
    for (Vector vec : Vets){
      vec.a = 0;
      vec.v = 0;
    }
    //print("/" + compX + "/" + compY + "/\n");
    this.cx = compX;
    this.cy = -compY;

    this.velX += compX/this.massa;
    this.velY += -compY/this.massa;
  }
  
  void update(){
    double descX=0,descY=0;
    forces();
    this.x += this.velX;
    this.y += this.velY;
    
    synchronized(this){
      rastro.add(new Point(this.x,this.y));
      if(rastro.size() > 1000) rastro.remove(0);
    }
  }

  void sleep(float segs){
    int m = millis();
    while (millis()-m<segs*1000);
  }

  void lux(){
    stroke(0);
    float r1=0,r2=0,g1=0,g2=0,b1=0,b2=0,tot = (int) pow(16,6);
    int dist = 200,p=1,resCor;
    float varR,varG,varB;

    b1 = (tot+this.cor)%((int)pow(16,2));
    g1 = (tot+this.cor-b1)/((int)pow(16,2))%((int)pow(16,2));
    r1 = ((tot+this.cor-b1)/((int)pow(16,2))-g1)/((int)pow(16,2));

    float coeDiscolor = 0.75;
    float coeDist = 3;
    dist *= 1;

    r1 *= coeDiscolor;
    g1 *= coeDiscolor;
    b1 *= coeDiscolor;

    varR = (r2-r1)/dist;
    varG = (g2-g1)/dist;
    varB = (b2-b1)/dist;

    
    r1=0;
    g1=0;
    b1=0;
    


    while (p<=dist){
      stroke(0);
      
      r1 += -varR;
      g1 += -varG;
      b1 += -varB;
      fill(color(r1,g1,b1));
      //stroke(resCor);
      
      print(r1+"," +g1+"," +b1 +" : "+color(r1,g1,b1)+ "\n");
      //background(resCor);
      //sleep(0.01);
      ellipse((float) this.x,(float) this.y,r+dist*coeDist-p*coeDist,r+dist*coeDist-p*coeDist);
      p++;
    }

    

  }
  
  void show(){
    

    
    if (this.isStar && this.onLux){
      lux();
    }
    stroke(0);
    fill(this.cor);
    ellipse((float) this.x,(float) this.y,r,r);
    float coe = 10;
    


    synchronized(this){
      if (this.lineTraj == 0){
        fill(this.cor);
        stroke(this.cor);
        for(int k = 0; k < rastro.size(); k++){
          point((float) rastro.get(k).x, (float)rastro.get(k).y);
        }
      }
    }
    
    
    if (this.lineVel == 1){
      stroke(#0000FF);
      line((float) this.x,(float) this.y,(float) (this.x+this.velX*coe),(float) (this.y+this.velY*coe));
    }
    if (this.lineFor == 1){
      stroke(#FF0000);
      line((float) this.x,(float) this.y,(float) (this.x+this.cx*coe),(float) (this.y+this.cy*coe));
    }
  }
}
