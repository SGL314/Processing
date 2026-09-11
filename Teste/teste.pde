#include <vector>
  // #include <cmath>
  // using namespace std;

  class Number {
public:
  int n, x, y, c, p;

  Number(int n, int x, int y, int p, int c) {
    this->n=n;
    this->x=x;
    this->y=y;
    this->p=p;
    this->c=c;
  }
};

class Box {
public:
  int x, y, w, h;
  string name;
  Box(string name,int x, int y, int w, int h) {
    this->name=name;
    this->x=x;
    this->y=y;
    this->w=w;
    this->h=h;
  }
}

int prime(int n);
int addPrimes(int init, int n);
void toggleKeyboard();
void menu();
string cleanNumber(int n);

vector<Number> list;
vector<Box> boxes;

int tela;
int last=2;

float mvx=0;
float mvy=0;
float zoom=1;

bool running=true, drawPrimes=true, alwaysShow=true, readingKeyboard=false;
int delay = 0;
int dir=0;
int qtMaxToFindPrimes = 1000000, qtMinToFindPrimes = 1,qtToFindPrimes = 10;
int pxBoxVel = 200, pyBoxVel = 10, widBoxVel =100, heiBoxVel=25;

int blk=1;
int posblk=0;
int qtblk=0;
int tamNumber=1;

int px=0, py=0;
string keyboardStr = "";
int loop=0;
Number *numberOver;

int prime(int n) {
  if (n<2) return 0;
  if (n==2) return 1;
  if (n%2==0) return 2;

  for (int i=3; i<=sqrt(n); i+=2)
    if (n%i==0) return i;

  return 1;
}

int addPrimes(int init, int n) {
  int qt=0;
  int i;

  for (i=init; i>0; i++) {
    switch(dir) {
    case -1:
      px ++;
      break;
    case 0:
      px++;
      break;
    case 1:
      py--;
      break;
    case 2:
      px--;
      break;
    case 3:
      py++;
      break;
    }

    posblk++;

    if (posblk==blk) {
      posblk=0;
      dir=(dir+1)%4;
      qtblk++;
    }

    if (qtblk==2) {
      blk++;
      qtblk=0;
    }

    int k=prime(i);

    if (k==1) {
      Number num(i, px, py, k, 0);
      list.push_back(num);
      qt++;
    }

    if (qt==n) break;
  }

  return i+1;
}

void setup() {
  size(1079, 1079); // 1920 x 1080
  // fullScreen();
  tela=width;
  background(0);
  noStroke();
  px=width/2;
  py=height/2;
  // boxes
  // list.add(new Box("vel",200,10,100,25));
  // list.add(new Box("init",350,10,100,25));
  // list.add(new Box("end",350,10,130,25));
  // list.add(new Box("find",350,10,160,25));
}

void draw() {
  int initLoop = millis();
  pushMatrix();
  scale(height/width*zoom*1.0);
  translate(mvx, mvy);
  // stroke(1);



  if (drawPrimes||loop<=110) {
    background(0);
    boolean drawedOne = alwaysShow;
    for (Number &num : list) {
      if (!dentroDaTela(num)) {
        num.c = 0;
        continue;
      }

      if (num.p==1) {
        if (num.n<=10) fill(255, 0, 0);
        else fill(255);
      }
      if (numberOver!=null&&num.n==numberOver->n) fill(0, 0, 255);
      // else if (num.p==2)
      //   fill(0, 255, 0);
      // else
      //   continue;
      if (num.c==0) {
        num.c = 1;
        drawedOne = true;
      }
      rect(num.x, num.y, tamNumber, tamNumber);
    }
    drawPrimes=drawedOne;
  }
  popMatrix();

  if (loop>=101&&running) {
    last=addPrimes(last, qtToFindPrimes);
  }
  menu();
  delay = millis()-initLoop;
  loop++;
}

void menu() {
  fill(0, 128);
  rect(0, 0, width, 200);

  fill(255);
  textSize(25);
  text("Zoom: "+zoom, 10, 30);
  text("Delay: "+delay+" ms", 10, 50);
  text("Nums. Verify: "+cleanNumber(last), 10, 70);
  text("Primes: "+cleanNumber(list.size()), 10, 90);
  println(drawPrimes);

  //
  fill(#FFA331);
  rect(pxBoxVel, pyBoxVel, widBoxVel, heiBoxVel);
  textSize(15);
  fill(255);
  text("Find "+cleanNumber(qtToFindPrimes,false)+" Primes", pxBoxVel, pyBoxVel+25/2);
  //

  if (!readingKeyboard) fill(255, 0, 0);
  else fill(0, 255, 0);
  circle(width-25, 25, 25);
  fill(0);
  text("qwe", width-25-textWidth("qwe")/2, 25+15/3);
  if (!alwaysShow) fill(255, 0, 0);
  else fill(0, 255, 0);
  circle(width-25, 55, 25);
  fill(0);
  text("shw", width-25-textWidth("shw")/2, 55+15/3);



  fill(0, 255, 0);
  if (numberOver!=null) {
    text(numberOver->n, mouseX, mouseY+5);
    text(numberOver->x+" "+numberOver->y, mouseX, mouseY+30);
    /* deixa assim pra qnd retirar de cima do pixel
    ele mostrar onde ta azul mas sem coocar o texto por cima */
  }
}

void mouseDragged() {
  drawPrimes = true;
  mvx+=(mouseX-pmouseX)/zoom;
  mvy+=(mouseY-pmouseY)/zoom;
}

void mouseWheel(MouseEvent event) {
  drawPrimes = true;
  bool inBoxVel = mouseX>pxBoxVel&&mouseX<pxBoxVel+widBoxVel&&mouseY>pyBoxVel&&mouseY<pyBoxVel+heiBoxVel;
  if (inBoxVel){
    int newVel = qtToFindPrimes;
    int degrau = 1e7;
    if (newVel>=1e8) degrau=1e8;
    else if (newVel>=1e7) degrau=1e7;
    else if (newVel>=1e6) degrau=1e6;
    else if (newVel>=1e5) degrau=1e5;
    else if (newVel>=1e4) degrau=1e4;
    else if (newVel>=1e3) degrau=1e3;
    else if (newVel>=1e2) degrau=1e2;
    else if (newVel>=1e1) degrau=1e1;
    else degrau = 1;

    int k= (int)event.getCount()*degrau*(
      (newVel/(degrau*1.0)==1)?
       ((event.getCount()<0)?1/10.0:1.0):1.0
      );

    newVel+=k;


    if (newVel>=qtMaxToFindPrimes) newVel=qtMaxToFindPrimes;
    else if (newVel<=qtMinToFindPrimes) newVel=qtMinToFindPrimes;
    qtToFindPrimes=newVel;
  }else{
   
  }
}

void zoom(int count){

}

void keyPressed() {
  drawPrimes = true;
  int move=10;
  // setinha: movimentação
  // s: toggle > faz carregar a tela a cada loop, se desativado, só carrega qnd faz movimento;
  // i: posição e zoom inciais
  // 0-9: digito de numero
  // ENTER: salva numero
  // k: toggle > keyboard

  if (key==CODED) {
    if (keyCode==LEFT) mvx+=move;
    else if (keyCode==RIGHT) mvx-=move;
    else if (keyCode==UP) mvy+=move;
    else if (keyCode==DOWN) mvy-=move;

    8f 
  } else if (key=='s'||key=='S') alwaysShow = !alwaysShow;
  
  else {
    key = tolower(key);
    switch(key) {
    case 'k':
      toggleKeyboard();
      break;
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9':
      keyboardStr+=key;
      break;
    case '+':
      zoom(1);
      break;
    case '-':
      zoom(-1);
      break;
    }
  }


  if (key==' ')
    running=!running;
  else if (key=='i') {
    zoom=1;
    mvx=0;
    mvy=0;
  }
}
// KEYBOARD
void toggleKeyboard(){
  readingKeyboard = !readingKeyboard;
  if (readingKeyboard) {
    keyboardStr = "";
  }
}
// AUXS
string cleanNumber(int n){
  string faixas[4] = {"k","mi","bi","tri"};
  if (n>=1e9) return str(round(1.0*n/1e9*1000)/1000.0)+" "+faixas[2];
  else if (n>=1e6) return str(round(1.0*n/1e6*1000)/1000.0)+" "+faixas[1];
  else if (n>=1e3) return str(round(1.0*n/1e3*1000)/1000.0)+" "+faixas[0];
  else return str(n);
}
string cleanNumber(int n,bool putFloat){
  if (putFloat) return cleanNumber(n);
  string faixas[4] = {"k","mi","bi","tri"};
  if (n>=1e9) return str(round(1.0*n/1e9))+" "+faixas[2];
  else if (n>=1e6) return str(round(1.0*n/1e6))+" "+faixas[1];
  else if (n>=1e3) return str(round(1.0*n/1e3))+" "+faixas[0];
  else return str(n);
}
bool dentroDaTela(Number &num) {
  float telaX=(num.x+mvx)*zoom;
  float telaY=(num.y+mvy)*zoom;
  if (!running) numberOver = (
    mouseX<=telaX+tamNumber/2.0*zoom &&
    mouseX>=telaX-tamNumber/2.0*zoom &&
    mouseY<=telaY+tamNumber/2.0*zoom &&
    mouseY>=telaY-tamNumber/2.0*zoom
    )?&num:numberOver; // tva dando bug qnd os primos estaop sendo procurados
  // if (numberOver!=null) println(numberOver->n);
  return telaX>=0 &&
    telaX<width &&
    telaY>=0 &&
    telaY<height;
}
