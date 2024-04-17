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

  public color padcolor(int sum){
    return color((int) random(255-sum)+sum,(int) random(255-sum)+sum,(int) random(255-sum)+sum);
  }
  
  Astro(double massa,double x,double y){
    this.omega = ((float)random(1000) +1)/50;
    this.ang = 0;
    this.r = (pow((float) massa/PI,0.5f)+5)*0.3;
    this.dist = (float)random(width/3)+75+this.r/2;
    this.cor = padcolor(128);
    this.massa = massa;
    this.x = x;
    this.y = y;
  }
  Astro(double massa,double x,double y,double vel,double angVel){
    this.omega = ((float)random(1000) +1)/50;
    this.ang = 0;
    this.r = (pow((float) massa/PI,0.5f)+5)*0.5;
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
    ang = round((float) angVel*10)/10;
    angVel *= PI/180;
    angVel = round((float) angVel*10)/10;

    if (ang != 90 && ang != 270){
      descX = vel*cos((float) angVel);
    }
    if (ang != 0 && ang != 180){
      descY = vel*sin((float) angVel);
    }

    print("sc :> " + ang +" <ang " + sin((float) angVel) + " | " + cos((float) angVel));

    this.velX += descX;
    this.velY += descY;

  }

  void forces(){
    double compX=0,compY=0,a;
    for (Vector v : Vets){
      a = round((float) v.a*180/PI);
      if (a != 90 && a != 270)
        compX += v.v*cos((float) v.a);
      if (a != 0 && a != 180)
        compY += v.v*sin((float) v.a);
    }
    print("/" + compX + "/" + compY + "/\n");
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
  }
  
  void show(){
    stroke(0);
    fill(this.cor);
    ellipse((float) this.x,(float) this.y,r,r);
    
    fill(#0000FF);
    float coe = 33;
    stroke(128);
    line((float) this.x,(float) this.y,(float) (this.x+this.velX*coe),(float) (this.y+this.velY*coe));
  }
}
