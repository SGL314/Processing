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
  
  ArrayList<Point> rastro = new ArrayList<Point>();

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
  
  void show(){
    stroke(0);
    fill(this.cor);
    ellipse((float) this.x,(float) this.y,r,r);

    int lineVel = 0;
    int lineFor = 1;
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
    
    
    if (lineVel == 1){
      stroke(#0000FF);
      line((float) this.x,(float) this.y,(float) (this.x+this.velX*coe),(float) (this.y+this.velY*coe));
    }
    if (lineFor == 1){
      stroke(#FF0000);
      line((float) this.x,(float) this.y,(float) (this.x+this.cx*coe),(float) (this.y+this.cy*coe));
    }
  }
}
