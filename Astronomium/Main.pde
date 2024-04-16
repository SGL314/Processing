Astro[] astros = new Astro[0];
int coeVel = 10;
int qt = 1;

void setup(){
  size(800,800);
  createAstros();
}

void createAstros(){
  astros = new Astro[qt];
  for (int i=0;i<astros.length;i++){
    if (i==0){
      astros[i] = new Astro(1000,0,0);
      continue;
    }
    astros[i] = new Astro(50,200,0);
  }
}

double angulo(Astro a,Astro b){
  double ang = atan(pow(pow(a.y-b.y,2),0.5f)/pow(pow(a.x-b.x,2),0.5f));
  if (a.x > b.x){
    ang = 180-ang;
  }
}

void forces(){
  for (Astro a1 : astros){
    for (Astro a2 : astros){
      angulo = ang(a1,a2);
    }
  }
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
  print(yes, '\n');
}

void draw(){
  translate(height/2,width/2);
  background(#000000);
  fill(#FFED4B);
  ellipse(0,0, 150,150);
  //delay(1000);
  
  for (int i=0;i<astros.length;i++){
    org(astros[i],i);
    astros[i].update();
    astros[i].show();
  }
}
