class Astro{
  float dist;
  float r;
  float ang;
  float omega;
  color cor;
  double massa;
  double x,y;
  private static double G = 6.6743*pow(10,-11);
  
  Astro(double massa,double x,double y){
    this.omega = ((float)random(1000) +1)/50;
    this.ang = 0;
    this.r = (int)random(50)+5;
    this.dist = (float)random(width/3)+75+this.r/2;
    this.cor = color((int)random(256),(int)random(256),(int)random(256));
    this.massa = massa;
    this.x = x;
    this.y = y;
  }

  void forces(){
    
  }
  
  void update(){
    forces();
  }
  
  void show(){
    fill(this.cor);
    //float x = this.dist * cos(radians(this.ang));
    //float y = - this.dist * sin(radians(this.ang));
    this.x = x;
    this.y = y;
    ellipse(x,y,r,r);
  }
}