
ArrayList<Node> Nodes = new ArrayList<Node>();
int somaX = 0;

void setup(){
    size(1800,600);
    createNodes();
}

void draw(){
    drawAll();
    correcao();
}

void createNodes(){
    int qtChilds = 0;
    int altura = 10;
    int maxQtChilds = 2;
    int minQtChilds = 1;
    int raw = 10;
    int x,y;
    Nodes = new ArrayList<Node>();
    x = (int) random(width-raw*2)+ raw;
    y = (int) random(height-raw*2)+ raw;
    color cor = color(0,0,255);
    Node root = new Node(null,x,y,raw,cor);
    Node father = null;
    Nodes.add(root);
    father = root;
    int nivel = 1;
    somaX = 0;

    qtChilds = (int) (random(maxQtChilds-minQtChilds+1)+minQtChilds);
    println(qtChilds);
    ArrayList<Node> add = getChildren(nivel+1,altura ,father,maxQtChilds,minQtChilds,raw);

    for (Node node : add){
        Nodes.add(node);
    }
    
}

// int[] cores = 

ArrayList<Node> getChildren(int nivel,int altura, Node father, int maxQtChilds,int minQtChilds, int raw){
    ArrayList<Node> NodesNow = new ArrayList<Node>();
    int qtChilds = (int) (random(maxQtChilds-minQtChilds+1)+minQtChilds);
    int x,y;
    color cor = color((255*nivel/altura),(255*nivel/altura),(255*nivel/altura/2));
    for (int i=0;i<qtChilds;i++){
        x = (int) i*20+20;
        somaX += 20;
        y = (int) nivel*50+raw;
        NodesNow.add(new Node(father,x,y,raw,cor));
    }
    if (nivel <= altura){
        ArrayList<Node> NodesAdd = new ArrayList<Node>();
        for (Node fatherNow : NodesNow){
            ArrayList<Node> add = getChildren(nivel+1,altura,fatherNow,maxQtChilds,minQtChilds,raw);
            for (Node node : add){
                NodesAdd.add(node);
            }
        }
        for (Node node : NodesAdd){
            NodesNow.add(node);
        }
    }else{
        return NodesNow;
    }
    return NodesNow;
}

void drawAll(){
    background(#FFFFFF);
    for(Node node : Nodes){
        node.drawNode();
    }
    
}

void correcao(){
    ArrayList<Node> comparados = new ArrayList<Node>();
    for (Node no : Nodes){
        comparados.add(no);
        for (Node no2 : Nodes){
            if (no == no2) continue;
            boolean sair = false;
            for (Node comp : comparados){
                if (no2 == comp) sair = true;
            }
            if (sair) continue;
            if (dist(no,no2)+10<(no.raw+no2.raw)){
                no.x += 2;
            }
        }
    }
}

float dist(Node a,Node b){
    float d = pow(pow(a.x-b.x,2f)+pow(a.y-b.y,2f),0.5f);
    return d;
}

void keyPressed(){
    if(key == 'r'){
        createNodes();
    }
}
