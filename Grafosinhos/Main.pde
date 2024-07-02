ArrayList<Node> Nodes = new ArrayList<Node>();
Node nodeCatched = null;
Node nodeSelected = null;
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
    int altura = 3;
    int maxQtChilds = 2;
    int minQtChilds = 2;
    int raw = 20;
    int x,y;

    Nodes = new ArrayList<Node>();
    x = (int) random(width-raw*2)+ raw;
    y = (int) random(height-raw*2)+ raw;
    x = 50;
    y = 50;
    color cor = color(0,0,255);
    Node root = new Node(new ArrayList<Node>(),x,y,raw,cor);
    root.num = 1;
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
        Node added = new Node(father,x,y,raw,cor);
        NodesNow.add(added);
        father.connected.add(added);
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
    int num = 1;
    ArrayList<Draw> after = new ArrayList<Draw>();
    for(Node node : Nodes){
        after.add(node.drawNode());
        after.add(node.write(num));
        num++;
    }

    for (Draw draw : after){
        draw.drawIt();
    }

    markNodeSelected();
}

void markNodeSelected(){
    if (nodeSelected != null){
        fill(#FF0000);
        // stroke(#FF0000);
        circle(nodeSelected.x,nodeSelected.y,nodeSelected.raw);
        // stroke(1);
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

// algoritmos
void preOrdem(){
    delay(2000);
    nodeSelected = Nodes.get(0);
    println(nodeSelected.num+": "+nodeSelected.connected.get(0).num+" | "+nodeSelected.connected.get(1).num);
    delay(500);
    nodeSelected = visL(nodeSelected.connected.get(1),nodeSelected);
    println(nodeSelected.num+": "+nodeSelected.connected.get(0).num+" | "+nodeSelected.connected.get(1).num);
    delay(500);
    nodeSelected = visL(nodeSelected.connected.get(0),nodeSelected);
    delay(500);
}
Node visL(Node node,Node after){
    if (node != null){
        nodeSelected = node;
        println(nodeSelected.num);
        if (nodeSelected.connected.size() >= 2){
            delay(500);
            nodeSelected = visL(nodeSelected.connected.get(1),nodeSelected);
            delay(500);
            nodeSelected = visL(nodeSelected.connected.get(0),nodeSelected);
        }else if (nodeSelected.connected.size() >= 1){
            delay(500);
            nodeSelected = visL(nodeSelected.connected.get(0),nodeSelected);
        }
        delay(500);
        return after;
    }
    return after;
}

// connections
void mouseDragged(){
    if (nodeCatched != null){
        nodeCatched.x = mouseX;
        nodeCatched.y = mouseY;
    }else{
        translate(1,0);
    }
}
void mousePressed(){
    nodeCatched = null;
    for (Node node : Nodes){
        if (node.x-node.raw <= mouseX && mouseX <= node.x+node.raw && node.y-node.raw <= mouseY && mouseY <= node.y+node.raw){
            if (mouseButton == LEFT) nodeCatched = node;
            else if (mouseButton == RIGHT){
                if (nodeSelected == null){
                    nodeSelected = node;
                }else{
                    if (nodeSelected != node){
                        boolean exists = false;
                        for (Node nodeVer : nodeSelected.connected){
                            if (nodeVer == node) exists = true;
                        }
                        if (exists == false) nodeSelected.connected.add(node);
                    }
                    nodeSelected = null;
                }
            }
        }
    }
}
void keyPressed(){
    if(key == 'r'){
        createNodes();
    }else if (key == 'd'){
        if (nodeSelected != null){
            for (Node node : Nodes){
                if (node.connected != null){
                    ArrayList<Node> nova = new ArrayList<Node>();
                    for (Node nodeFil : node.connected){
                        if (nodeFil != nodeSelected){
                            nova.add(nodeFil);
                        }
                    }
                    node.connected = nova;
                }
                if (node == nodeSelected) node = null;
            }
        }
        nodeSelected = null;
    }else if (key == 'a'){
        thread("preOrdem");
    }
}
