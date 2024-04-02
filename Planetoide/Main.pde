Astro[] astros = new Astro[1];
int coeVel = 10;
int qt = 1000;

void setup(){
  size(800,800);
  createAstros();
}

void createAstros(){
  astros = new Astro[qt];
  for (int i=0;i<astros.length;i++){
    astros[i] = new Astro();
  }
}

void draw(){
  translate(height/2,width/2);
  background(#000000);
  fill(#FFED4B);
  ellipse(0,0, 150,150);
  //delay(1000);
  
  for (int i=0;i<astros.length;i++){
    astros[i].update();
    astros[i].show();
  }
}

