import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;

import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.Serializable;

ArrayList<Node> Nodes = new ArrayList<Node>();
Node nodeCatched = null;
Node nodeSelected = null;
Node nodePassing = null;
int somaX = 0;
// config
int basicRaw = 20;
Connection con = new Connection("nodes.txt");
Algoris Alg = new Algoris();
// variables
int lastMousePressed = 0;
int typeSelected = 0;
boolean breakThread = false;
boolean writeNode = false;
int dragX = 0,dragY = 0;
float zoom = 1,lastZoom = 1;

void setup(){
    size(600,600);
    // createNodes();
    con.getIt();
}

void draw(){
    background(#FFFFFF);
    scale(zoom);
    translate(dragX/zoom,dragY/zoom);
    position();
    ecrivent();

    drawAll();
    correcao();

    mouseAutomatic();
    markNodeSelected();

    teste();
}

void createNodes(){
    int qtChilds = 0;
    int altura = 7;
    int maxQtChilds = 2;
    int minQtChilds = 2;
    int raw = basicRaw;
    int x,y;

    Nodes = new ArrayList<Node>();
    x = (int) random(width-raw*2)+ raw;
    y = (int) random(height-raw*2)+ raw;
    x = 50;
    y = 50;
    color cor = color(0,0,128);
    Node root = new Node(new ArrayList<Node>(),x,y,raw,cor);
    root.id = "0";
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

    // coloca os ids
    int num = 1;
    for(Node node : Nodes){
        node.write(""+num);
        num++;
    }
    
}

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
    int num = 1;
    // translate(dragX,dragY);
    ArrayList<Draw> after = new ArrayList<Draw>();
    for(Node node : Nodes){
        after.add(node.drawNode());
        after.add(node.write(" "));
        num++;
    }

    for (Draw draw : after){
        draw.drawIt();
    }
    translate(-dragX,-dragY);
}

void markNodeSelected(){
    // selected
    if (nodeSelected != null){
        if (writeNode) drawCrown(nodeSelected,#00FF00);
        else if (typeSelected == RIGHT) drawCrown(nodeSelected,#FF0000);
        else drawCrown(nodeSelected,#FFFF00);
        // if (nodeSelected == nodePassing) nodePassing = null;
    }
    // passing
    if (nodePassing != null && nodeSelected != nodePassing && nodePassing.minorisWay.size() == 0){
        drawCrown(nodePassing,#00F0F0);
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

// Auxiliares
void teste(){
    // stroke(#FF0000);
    // // translate(zoom/dragX,zoom/dragY);
    // // line(width/2+dragX,0+dragY,width/2+dragX,width+dragY);
    // // line(0+dragX,width/2+dragY,width+dragX,width/2+dragY);
    // // translate(dragX/zoom,dragY/zoom);
    // stroke(1);
}

void position(){
    fill(#FF00A0);
    String texto = "("+mouseX+", "+mouseY+")";
    text(texto,(mouseX-dragX)/zoom,(mouseY-dragY)/zoom); // Segue o mouse
}

void ecrivent(){
    fill(#000000);
    String texto = dragX+" : "+dragY;
    textSize(25/zoom);
    text(texto,(10-dragX)/zoom,(width-2-dragY)/zoom);
    textSize(12);
}

// algoritmos
void algorithim(){
    Alg.rename();
    Alg.distances();
    delay(250);
}

// connections
void mouseWheel(MouseEvent event){
    // translate(dragX*zoom,dragY*zoom);
    int x = mouseX;
    int y = mouseY;
    int drx = dragX;
    int dry = dragY;

    lastZoom = zoom;

        
    if (pow(2,event.getCount()*(-1)) > 1){
        dragX += (width/2-mouseX);
        dragY += (height/2-mouseY);
        dragX += -x+drx;
        dragY += -y+dry;
    }else{
        // dragX += (width/2-mouseX);
        // dragY += (height/2-mouseY);
        println((-dragX+drx)+" : "+(-dragY+dry));
        // dragX += x;
        // dragY += y;
    }

    lastZoom *= pow(2,event.getCount()*(-1));

    zoom = lastZoom;


    println(mouseX + " : "+mouseY + " | "+lastZoom);

    

    
}
void mouseAutomatic(){
    // if (nodeSelected == null) nodeCatched = null;
    if (nodeCatched != null){
        nodeCatched.x = mouseX-dragX;
        nodeCatched.y = mouseY-dragY;
    }
    nodePassing = null;
    for (Node node : Nodes){
        if (node.x-node.raw+dragX <= mouseX && mouseX <= node.x+node.raw+dragX && node.y-node.raw+dragY <= mouseY && mouseY <= node.y+node.raw+dragY){
            nodePassing = node;
            break;
        }
    }
    // minorisWay
    if (nodePassing != null && nodeSelected == null)
    if (nodePassing.x-nodePassing.raw+dragX <= mouseX && mouseX <= nodePassing.x+nodePassing.raw+dragX && nodePassing.y-nodePassing.raw+dragY <= mouseY && mouseY <= nodePassing.y+nodePassing.raw+dragY){
        // if (nodePassing.minorisWay != null)
        if (nodePassing.minorisWay != null && nodePassing.minorisWay.size() >= 1){
            for (Node node2 : nodePassing.minorisWay){
                if (nodePassing.minorisWay.get(0) == node2) drawCrown(node2,#FF00FF);
                else drawCrown(node2,#FF0000);
            }
            drawCrown(nodePassing,#0000FF);
        }
    }
}
void mousePressed(){
    nodeCatched = null;
    for (Node node : Nodes){
        if (node.x-node.raw+dragX <= mouseX && mouseX <= node.x+node.raw+dragX && node.y-node.raw+dragY <= mouseY && mouseY <= node.y+node.raw+dragY){
            typeSelected = mouseButton;
            if (mouseButton == LEFT){
                if (nodeSelected == null){
                    nodeSelected = node;
                }else{
                    if (lastMousePressed == LEFT){
                        if (nodeSelected != node){
                            boolean exists = false;
                            for (Node nodeVer : nodeSelected.connected){
                                if (nodeVer == node){ // retira o node
                                    nodeSelected.connected.remove(nodeVer);
                                    exists = true;
                                    break;
                                }
                            }
                            if (exists == false) nodeSelected.connected.add(node);
                        }
                        nodeSelected = null;
                    }else nodeSelected = null;
                }
            }else if (mouseButton == RIGHT){
                if (nodeSelected == null){
                    nodeSelected = node;
                }else{
                    if (lastMousePressed == RIGHT){
                        if (nodeSelected != node){
                            boolean exists = false;
                            for (Node nodeVer : nodeSelected.connected){
                                if (nodeVer == node){ // retira o node
                                    nodeSelected.connected.remove(nodeVer);
                                    nodeVer.connected.remove(nodeSelected);
                                    exists = true;
                                    break;
                                }
                            }
                            if (exists == false){
                                nodeSelected.connected.add(node);
                                node.connected.add(nodeSelected);
                            }
                        }
                        nodeSelected = null;
                    }else nodeSelected = null;
                }
                
            }
            lastMousePressed = mouseButton;
        }
    }
}
void mouseDragged() {
    // translate(mouseX-pmouseX,);
    dragX += mouseX-pmouseX;
    dragY += mouseY-pmouseY;
    println("---------\n"+mouseX+"\n"+pmouseX+"\n"+mouseY+"\n"+pmouseY);
    println("---------");
}
void keyPressed(){
    if (nodeSelected == null) writeNode = false;
    if (writeNode){
        for (char c : "abcdefghijklmnopqrstuvwxyz0123456789".toCharArray()){
            if (key == c){
                nodeSelected.id += c;
            }
        }
        if (key == '\n'){
            writeNode = false;
            nodeSelected = null;
        }else if (keyCode == 8) nodeSelected.id = "";
    }else{
        if (key == 'r'){ // Creates nodes
            createNodes();
        }else if (key == 'l'){ // Clear the map
            Nodes = new ArrayList<Node>();
            Nodes.add(new Node(new ArrayList<Node>(),mouseX-dragX,mouseY-dragY,basicRaw,color((int) random(256),(int) random(256),(int) random(256))));
            nodeSelected = null;
            nodeCatched = null;
        }else if (key == 'd'){ // Delete node
            if (nodePassing != null){
                ArrayList<Node> newNodes = new ArrayList<Node>();
                for (Node node : Nodes){
                    if (node.connected != null){
                        ArrayList<Node> nova = new ArrayList<Node>();
                        for (Node nodeFil : node.connected){
                            if (nodeFil != nodePassing){
                                nova.add(nodeFil);
                            }
                        }
                        node.connected = nova;
                    }
                    if (node != nodePassing) newNodes.add(node);
                }
                Nodes = newNodes;
                if (nodePassing == nodeSelected){
                    newNodes = new ArrayList<Node>();
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
                        if (node != nodeSelected) newNodes.add(node);
                    }
                    Nodes = newNodes;
                }
                if (nodePassing == nodeSelected) nodeSelected = null;
                nodePassing = null;
            }
        }else if (key == 'a'){ // Algorithim
            thread("algorithim");
        }else if (key == 'w'){ // Write on the node
            if (nodeSelected != null) writeNode = true;
        }else if (key == 'n'){ // Add new node
            Nodes.add(new Node(new ArrayList<Node>(),(int) ((mouseX-dragX)/zoom),(int) ((mouseY-dragY)/zoom),basicRaw,color((int) random(256),(int) random(256),(int) random(256))));  
        }else if (key == 'b'){ // Break Thread
            breakThread = (breakThread) ? false : true;
        }else if (key == 'c'){ // Catch node
            nodeCatched = (nodeCatched==null) ? nodePassing : null;
        }else if (key == 's'){ // Skip
            con.setIt();
            exit();
        }else if (key == 'm'){ // MinorisWay will be clear
            for (Node node : Nodes) node.minorisWay = new ArrayList<Node>();
        }else if (key == 'z'){ // Turn into zero the drags
            dragX=0;dragY=0;
        }else if (key == 't'){ // Tester
            // if (zoom < lastZoom){
            //     dragX += -mouseX*zoom;
            //     dragY += -mouseY*zoom;
            //     println("Minoris");
            // }else if (zoom != lastZoom){
            //     dragX += mouseX*lastZoom;
            //     dragY += mouseY*lastZoom;
            //     println("Majoris");
            // }
            zoom = lastZoom;
            println(dragX + " : "+dragY+ " | "+lastZoom);
        }else if (key == 'p'){
            println(mouseX + " : "+mouseY + " | "+lastZoom);
        }
    }
}

// calculus
float distLin(Node a,Node b){
    return pow(pow(a.x-b.x,2)+pow(a.y-b.y,2),0.5f);
}
float dist(Node a,Node b){
    float d = pow(pow(a.x-b.x,2f)+pow(a.y-b.y,2f),0.5f);
    return d;
}
void drawCrown(Node node,color cor) {
    float outerRadius = node.raw*1.2;
    float innerRadius = node.raw*1;
    int numSegments = 50; // Número de segmentos da coroa

    float angleStep = TWO_PI / numSegments;

    fill(cor); // cor vermelha
    noStroke();

    beginShape();
    for (int i = 0; i <= numSegments; i++) {
    float angle = i * angleStep;
    float xOuter = node.x+dragX + cos(angle) * outerRadius;
    float yOuter = node.y+dragY + sin(angle) * outerRadius;
    vertex(xOuter, yOuter);
    }
    for (int i = numSegments; i >= 0; i--) {
    float angle = i * angleStep;
    float xInner = node.x+dragX + cos(angle) * innerRadius;
    float yInner = node.y+dragY + sin(angle) * innerRadius;
    vertex(xInner, yInner);
    }
    endShape(CLOSE);
    stroke(1);
}
