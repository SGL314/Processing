Astro[] astros = new Astro[0];
int coeVel = 10;
int qtCentr = 8;
int qtBlHl = 1;
int qt = 10;
double G = 6.6743*pow(10,-2);
boolean run = false;
float tx=0,ty=0;
int posObj = 0;
float coeDil = 1;
int count = 0;
int lineTraj = 0;

void setup(){
  size(1000,1000);
  background(#000000);
  createAstros();
  frameRate(50);
  tx = width/2;
  ty = height/2;
}

double Pow(double a,double b){
  return (double) pow((float) (a), (float) (b));
}

float sqrt(double val){
  return sqrt((float) val);
}

void createAstros(){
  astros = new Astro[qt];
  int coeDist = 30;
  double D=0,V=0,d=0,v=0,a,dx,dy,setAngVel;
  double velStar = 1;
  for (int i=0;i<astros.length;i++){
    if (i==1){
      D = -75-(i-1)*coeDist;
      V = -(4-i/2-1-velStar+1);
    }
    if (i==0){
      astros[i] = new Astro(1000,0,0,velStar,0);
      astros[i].init(qt);
      astros[i].cor = #FFF412;
      continue;
    }else if (i < qtCentr+1){
      d = -25-(i-1)*coeDist;
      v = (double) -(sqrt((float) (Pow(V,2) * (D/d)))) * sqrt(astros[0].massa/10000) -velStar;
      astros[i] = new Astro(1,0,(float) d,(float) v,180);
      astros[i].init(qt);
    }else if (i < qtCentr+1+qtBlHl){
      v = 0;
      d = -6000;
      astros[i] = new Astro(100000,0,(float) d,(float) v,180);
      astros[i].cor = #0000FF;
      // astros[i].r /= 3.16;
      astros[i].init(qt);
    }else{
      d = -75-((qt-qtCentr-qtBlHl)-1)*coeDist;
      v = (double) (sqrt((float) (Pow(V,2) * (D/d)))) * sqrt(astros[0].massa/10000);
      a = 360/((qt-qtCentr-qtBlHl-1)) * (i-(qt-qtCentr-qtBlHl));

      dx = cos((float)(a*PI/180))*d;
      dy = sin((float)(a*PI/180))*d;
      if (i%2 == 1){
        a+=0; 
      }
      setAngVel = a+90;
      if (setAngVel >= 360){
        setAngVel -= 360;
      }
      //print(a + "\n");
      
      
      
      astros[i] = new Astro(1,dx,dy,(float) v,setAngVel);
      astros[i].init(qt);
    }
  }
}

void realloc(int p){
  qt -= 1;
  for (int i = p;i<qt;i++){
    astros[i] = astros[i+1];
  }
}

int ind(Astro a){
  for (int i=0;i<qt;i++){
    if (astros[i] == a){
      return i;
    }
  }
  return 0;
}

void collision(Astro a){
  Astro sum,sub;
  int p =0;
  for (Astro b : astros){
    if(a == b){
      continue;
    }
    if (distLin(a,b) < a.r/2 + b.r/2){
      if (a.massa >= b.massa){
        sum = a;
        sub = b;
      }else{
        sum = b;
        sub = a;
      }
      sum.velX += ((sub.velX - sum.velX)*sub.massa)/sum.massa;
      sum.velY += ((sub.velY - sum.velY)*sub.massa)/sum.massa;
      sum.massa += sub.massa;
      p = ind(sub);
      realloc(p);
      sum.r = (pow((float) sum.massa/PI,0.5f)+5/0.5)*0.5;
      break;
    }
  }
  p++;
}

double angulo(Astro a,Astro b){
  double dx = a.x - b.x;
  double dy = - a.y + b.y;
  double soma = 90;
  if (dx >= 0){
      soma += 180;
  }
  double ang = (atan((float) (dy/dx)) * 180 / PI + soma+ 90) % 360;
  return ang;
}

double distLin(Astro a1,Astro a2){
  return pow(pow((float) (a1.x - a2.x),2) + pow((float) (a1.y - a2.y),2),0.5f);
}

void forces(){
  //print("F:");
  double ang,dist;
  int p = 0;
  for (Astro a1 : astros){
    for (Astro a2 : astros){
      
      if (a1 == a2){
        continue;
      }
      
      ang = angulo(a1,a2);
      dist = distLin(a1,a2);
      
      a2.Vets[p].v = G*a1.massa*a2.massa/pow((float) dist,2);
      a2.Vets[p].a = ang*PI/180;
      //print("|" + a1.Vets[p].v);
      
    }
    p+=1;

  }
  //print("|\n");
}

void draw(){
  translate(width/2+tx,height/2+ty);
  scale(coeDil);
  
  if (posObj != -1){
    
    tx = (float)(-astros[posObj].x*coeDil);
    ty = (float)(-astros[posObj].y*coeDil);
    
  }
  if (run){
    background(0);
    forces();
    for (int i=0;i<astros.length;i++){
      astros[i].update();
      collision(astros[i]);
      astros[i].show();
      astros[i].lineTraj = lineTraj;
    }
  }else{
    background(0);
    for (int i=0;i<astros.length;i++){
      astros[i].show();
      astros[i].lineTraj = lineTraj;
    }
  }
}

void keyReleased() {
  if (keyCode == CONTROL){
    run = (run == false) ? true : false;
  }else if (keyCode == LEFT){
    posObj -= 1;
    print(posObj + "\n");
  }else if (keyCode == RIGHT){
    posObj += 1;
    print(posObj + "\n");
  }else if (keyCode == SHIFT){
    posObj = -1;
    print(posObj + "\n");
  }else if (keyCode == UP){
    coeDil *= 1.02;
  }else if (keyCode == DOWN){
    coeDil *= 1/1.02;
  }else if (keyCode == ALT){
    lineTraj = (lineTraj==0) ? 1: 0;
  }
  
  if (posObj <-1){
    posObj += qt+1;
  }else if (posObj >= qt){
    posObj = -1;
  }
  
  if (coeDil < 0){
    coeDil = 0;
  }
}

void mouseDragged(){
  tx += mouseX - pmouseX;
  ty += mouseY - pmouseY;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount(); 
  if(e < 0) coeDil+=0.02; 
  else coeDil-=0.02; 
}
