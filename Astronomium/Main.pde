Astro[] astros = new Astro[0];
int coeVel = 10;
int qt = 3;
double G = 6.6743*pow(10,-2);
boolean run = true;
float tx=0,ty=0;
int posObj = 0;

void setup(){
  size(800,800);
  createAstros();
  tx = width/2;
  ty = height/2;
}

void createAstros(){
  astros = new Astro[qt];
  for (int i=0;i<astros.length;i++){
    if (i==0){
      astros[i] = new Astro(10000,0,0);
      astros[i].init(qt);
      continue;
    }
    
    
    
    astros[i] = new Astro(1000,0,-75 - (i-1)*100,4-i,180);
    astros[i].init(qt);
  }
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
  print("F:");
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
  print("|\n");
}

void org(Astro ast,int pos){
  int cof = 1;
  boolean yes = true;
  
  if (pos < astros.length-1){
    if (ast.r < astros[pos+1].r){
      Astro take = astros[pos+1];
      astros[pos+1] = ast;
      astros[pos] = take;
    }
  }

  float last = 100000000;
  for (Astro asti : astros){
    if (asti.r <= last){
      last = asti.r;
    }else{
      yes = false;
      break;
    }
  }
  //print(yes, '\n');
}

void draw(){
  translate(tx,ty);
  tx = (float)(-astros[posObj].x+width/2);
  ty = (float)(-astros[posObj].y+height/2);
  //tx = (float) astros[qt-1].x;
  
  
  
  //fill(#FFED4B);
  //ellipse(0,0, 150,150);
  //delay(1000);
  if (run){
    background(#000000);
    forces();
    
    for (int i=0;i<astros.length;i++){
      //org(astros[i],i);
      astros[i].update();
      astros[i].show();
    }
  }
}

void keyReleased() {
  if (keyCode == CONTROL){
    run = (run == false) ? true : false;
  }else if (keyCode == UP){
    posObj += 1;
  }else if (keyCode == DOWN){
    posObj -= 1;
  }
  if (posObj <0){
    posObj += qt;
  }else if (posObj >= qt){
    posObj = 0;
  }
}
