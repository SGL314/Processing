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

// package estruturas;
package main;
import estruturas.Node;

class Main2 extends PApplet implements Serializable{
    ArrayList<Node> Nodes = new ArrayList<Node>();
    Node nodeCatched = null;
    Node nodeSelected = null;
    int somaX = 0;
    // config
    int basicRaw = 20;
    Connection con = new Connection("nodes.bin");
    // variables
    int lastMousePressed = 0;
    boolean breakThread = false;
    boolean writeNode = false;

    void setup(){
        size(600,600);
        // createNodes();
        con.getIt();
    }

    void draw(){
        drawAll();
        correcao();
        mouseAutomatic();
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
            after.add(node.write(" "));
            num++;
        }

        for (Draw draw : after){
            draw.drawIt();
        }

        markNodeSelected();
        minorisWay();
    }

    void markNodeSelected(){
        if (nodeSelected != null){
            if (writeNode) fill(#00FF00);
            else fill(#FF0000);
            // stroke(#FF0000);
            circle(nodeSelected.x,nodeSelected.y,nodeSelected.raw);
            // stroke(1);
            // show minorisWay
            Node node = nodeSelected;
            if (node.minorisWay != null){
                for (Node node2 : node.minorisWay){
                    fill(#0000FF);
                    circle(node2.x,node2.y,basicRaw);
                }
                fill(#00F0F0);
                circle(node.x,node.y,basicRaw);
            }
            
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

    void teste(){
        // if (nodeCatched != null) println(nodeCatched.id);
    }

    // algoritmos
    void algorithim(){
        // excluir();
        rename();
        // preOrdem();
        // delay(250);
        // emOrdem();
        // delay(250);
        // posOrdem();
        // delay(250);
        distances();
        delay(250);
    }

    void excluir(){
        ArrayList<Node> nova = new ArrayList<Node>();
        String[] ids = {"15","14","5","4","9","8","7","6"};
        for (Node node : Nodes){
            boolean add = true;
            for (String str : ids){
                if (node.id.equals(str)){
                    nodeSelected = node;
                    ArrayList<Node> newNodes = new ArrayList<Node>();
                    for (Node node2 : Nodes){
                        if (node2.connected != null){
                            ArrayList<Node> nova2 = new ArrayList<Node>();
                            for (Node nodeFil : node2.connected){
                                if (nodeFil != nodeSelected){
                                    nova2.add(nodeFil);
                                }
                            }
                            node2.connected = nova2;
                        }
                        if (node2 != nodeSelected) newNodes.add(node2);
                    }
                    Nodes = newNodes;
                    add = false;
                }
                nodeSelected = null;
            }
            if (add) nova.add(node);
        }
        Nodes = nova;
    }
    void rename(){
        String[] names = {"a","c","b","e","d","g","f"};
        int tam=0;
        for (String c : names) tam++;
        int i = 0;
        for (Node node : Nodes){
            node.id = names[i];
            i++;
            if (tam == i){
                break;
            }
        }
    }

    void distances(){
        println("BEGIN");
        int initDist = 10000;
        for (Node node : Nodes){
            node.id = ""+initDist;
        }
        if (nodeCatched != null){
            Node after = nodeCatched;
            nodeCatched = null;
            nodeSelected = vis(after,null,0,new ArrayList<Node>());
            after.minorisWay = null;
        }
        println("END");
    }

    Node vis(Node node,Node after,float somaB,ArrayList<Node> way){
        int time = 1;
        if (breakThread) return null;
        if (node != null){
            nodeSelected = node;
            way.add(nodeSelected);
            // print(nodeSelected.id+" ");
            if (nodeSelected.connected.size() >= 1){
                int tam = nodeSelected.connected.size(),i=0;
                float soma=0;
                while (true){
                    if (i == tam) break;
                    // para-loops
                    boolean continueIt = false;
                    for (Node nodeWay : way){
                        if (nodeWay == nodeSelected.connected.get(i)){
                            i++;
                            continueIt = true;
                            break;
                        }
                    }
                    if (continueIt) continue;
                    //
                    soma = somaB+distLin(nodeSelected,nodeSelected.connected.get(i));
                    delay(time);
                    if (Float.parseFloat(nodeSelected.connected.get(i).id) > soma){
                        nodeSelected.connected.get(i).id = ""+soma;
                        nodeSelected.connected.get(i).minorisWay = new ArrayList<Node>();
                        for (Node nodeWay : way) nodeSelected.connected.get(i).minorisWay.add(nodeWay);
                    }
                    ArrayList<Node> put = new ArrayList<Node>();
                    for (Node nodePut : way) put.add(nodePut);
                    
                    nodeSelected = vis(nodeSelected.connected.get(i),nodeSelected,soma,put);
                    i++;
                    
                }
            }
            delay(time);
            return after;
        }
        return after;
    }

    void preOrdem(){
        nodeSelected = Nodes.get(0);
        delay(500);
        nodeSelected = visPreOrdem(Nodes.get(0),null);
        delay(500);
        nodeSelected = null;
        println("");
    }
    Node visPreOrdem(Node node,Node after){
        if (node != null){
            nodeSelected = node;
            print(nodeSelected.id+" ");
            if (nodeSelected.connected.size() >= 2){
                delay(500);
                nodeSelected = visPreOrdem(nodeSelected.connected.get(1),nodeSelected);
                delay(500);
                nodeSelected = visPreOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() >= 1){
                delay(500);
                nodeSelected = visPreOrdem(nodeSelected.connected.get(0),nodeSelected);
            }
            delay(500);
            return after;
        }
        return after;
    }

    void emOrdem(){
        nodeSelected = Nodes.get(0);
        delay(500);
        nodeSelected = visEmOrdem(Nodes.get(0),null);
        delay(500);
        nodeSelected = null;
        println("");
    }
    Node visEmOrdem(Node node,Node after){
        if (node != null){
            nodeSelected = node;
            if (nodeSelected.connected.size() >= 2){
                delay(500);
                nodeSelected = visEmOrdem(nodeSelected.connected.get(1),nodeSelected);
                print(nodeSelected.id+" ");
                delay(500);
                nodeSelected = visEmOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() >= 1){
                delay(500);
                nodeSelected = visEmOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() == 0){
                print(nodeSelected.id+" ");
            }
            delay(500);
            return after;
        }
        return after;
    }

    void posOrdem(){
        nodeSelected = Nodes.get(0);
        delay(500);
        nodeSelected = visPosOrdem(Nodes.get(0),null);
        delay(500);
        nodeSelected = null;
        println("");
    }
    Node visPosOrdem(Node node,Node after){
        if (node != null){
            nodeSelected = node;
            if (nodeSelected.connected.size() >= 2){
                delay(500);
                nodeSelected = visPosOrdem(nodeSelected.connected.get(1),nodeSelected);
                delay(500);
                nodeSelected = visPosOrdem(nodeSelected.connected.get(0),nodeSelected);
                print(nodeSelected.id+" ");
            }else if (nodeSelected.connected.size() >= 1){
                delay(500);
                nodeSelected = visPosOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() == 0){
                print(nodeSelected.id+" ");
            }
            delay(500);
            return after;
        }
        return after;
    }

    // connections
    void mouseAutomatic(){
        // if (nodeSelected == null) nodeCatched = null;
        if (nodeCatched != null){
            nodeCatched.x = mouseX;
            nodeCatched.y = mouseY;
        }
    }
    void mousePressed(){
        nodeCatched = null;
        for (Node node : Nodes){
            if (node.x-node.raw <= mouseX && mouseX <= node.x+node.raw && node.y-node.raw <= mouseY && mouseY <= node.y+node.raw){
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
            if(key == 'r'){
                createNodes();
            }else if (key == 'l'){
                Nodes = new ArrayList<Node>();
                Nodes.add(new Node(new ArrayList<Node>(),mouseX,mouseY,basicRaw,color((int) random(256),(int) random(256),(int) random(256))));
                nodeSelected = null;
                nodeCatched = null;
            }else if (key == 'd'){
                if (nodeSelected != null){
                    ArrayList<Node> newNodes = new ArrayList<Node>();
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
                nodeSelected = null;
            }else if (key == 'a'){
                thread("algorithim");
            }else if (key == 'w'){
                if (nodeSelected != null) writeNode = true;
            }else if (key == 'n'){
                Nodes.add(new Node(new ArrayList<Node>(),mouseX,mouseY,basicRaw,color((int) random(256),(int) random(256),(int) random(256))));  
            }else if (key == 'b'){
                breakThread = (breakThread) ? false : true;
            }else if (key == 'c'){
                nodeCatched = (nodeCatched==null) ? nodeSelected : null;
            }else if (key == 's'){
                con.setIt();
                exit();
            }
        }
    }
    void minorisWay(){
        for (Node node : Nodes){
            if (node.x-node.raw <= mouseX && mouseX <= node.x+node.raw && node.y-node.raw <= mouseY && mouseY <= node.y+node.raw){
                if (node.minorisWay != null){
                    for (Node node2 : node.minorisWay){
                        drawCrown(node2);
                    }
                    fill(#00F0F0);
                    circle(node.x,node.y,basicRaw);
                }
            }
        }
    }

    void drawCrown(Node node) {
    float outerRadius = node.raw*1.2;
    float innerRadius = node.raw*1;
    int numSegments = 50; // Número de segmentos da coroa

    float angleStep = TWO_PI / numSegments;

    fill(255, 0, 0); // cor vermelha
    noStroke();

    beginShape();
    for (int i = 0; i <= numSegments; i++) {
        float angle = i * angleStep;
        float xOuter = node.x + cos(angle) * outerRadius;
        float yOuter = node.y + sin(angle) * outerRadius;
        vertex(xOuter, yOuter);
    }
    for (int i = numSegments; i >= 0; i--) {
        float angle = i * angleStep;
        float xInner = node.x + cos(angle) * innerRadius;
        float yInner = node.y + sin(angle) * innerRadius;
        vertex(xInner, yInner);
    }
    endShape(CLOSE);
    stroke(1);
    }

    // calculus
    float distLin(Node a,Node b){
        return pow(pow(a.x-b.x,2)+pow(a.y-b.y,2),0.5f);
    }
}
