
ArrayList<Node> Nodes = new ArrayList<Node>();

void setup(){
    size(600,600);
    createNodes();
}

void draw(){
    drawAll();
}

void createNodes(){
    int qtChilds = 0;
    int altura = 3;
    int maxQtChilds = 5;
    int raw = 20;
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

    qtChilds = (int) random(maxQtChilds+1);
    ArrayList<Node> add = getChildren(nivel+1,altura ,father,maxQtChilds,raw);

    for (Node node : add){
        Nodes.add(node);
    }
    
}

ArrayList<Node> getChildren(int nivel,int altura, Node father, int maxQtChilds, int raw){
    ArrayList<Node> NodesNow = new ArrayList<Node>();
    int qtChilds = (int) random(maxQtChilds+1);
    int x,y;
    color cor = color(nivel/altura*255,0,0);
    for (int i=0;i<qtChilds;i++){
        x = (int) random(width-raw*2)+ raw;
        y = (int) nivel*100+raw;
        NodesNow.add(new Node(father,x,y,raw,cor));
    }
    if (nivel <= altura){
        ArrayList<Node> NodesAdd = new ArrayList<Node>();
        for (Node fatherNow : NodesNow){
            ArrayList<Node> add = getChildren(nivel+1,altura,fatherNow,maxQtChilds,raw);
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

void keyPressed(){
    if(key == 'r'){
        createNodes();
    }
}
