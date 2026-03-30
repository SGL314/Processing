int tamMaxClicks = 10;
float tamNode = 20;
// variables
int loop = 1;
ArrayList<Node> nodes = new ArrayList<Node>();
ArrayList<int[]> clicks = new ArrayList<int[]>();

void setup(){
  size(300,300);
}

void draw(){
  background(128);
  show();
  loop+=1;
}

// show
void show(){
  for (Node node : nodes){
    node.show();
  }
}

// gaming
void addNode(int x,int y){
  Node node = new Node((float)x,(float)y,tamNode);
  nodes.add(node);
}

// clicks
void mousePressed(){
  
  int ind = (mouseButton==LEFT)?0:1;
  int[] put = {ind,loop};
  clicks.add(put);
  int t = clicks.size();
  // process
  fill(#00ff00);
    text(t,20,20);
      
  if (t>=2){
    
    if (clicks.get(t-1)[0] == clicks.get(t-2)[0]){
      
      addNode(mouseX,mouseY);
    }
  }
  // retira os cliques
  if (clicks.length>tamMaxClicks){
    int minLoop = loop,pos=0,p=0;
    for (int[] key : clicks){
      if (key[1] < minLoop){
        minLoop = key[1];
        pos = p;
      }
      p+=1;
    }
    clicks.remove(p); 
  }
}

class Node{
  float px,py,tam;
  
  ArrayList<Node> cons = new ArrayList<Node>();
  
  Node(float px,float py,float tam){   
    this.px = px;
    this.py = py;
    this.tam = tam;
  }
  
  void show()
{
    fill(#ffff00);
    circle(px,py,tam);
  }
}

// n mude abaixo