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
ArrayList<PImage> imgs = new ArrayList<PImage>();
Node nodeCatched = null;
Node nodeSelected = null;
Node nodePassing = null;
Node nodeFlagged = null;
int somaX = 0;
// config
int basicRaw = 20;
int basicRawSaved = basicRaw;
String namePack = "unsv";
// bhbus mirinha unsv
String fileNameImg = "escola.png"; // unsv
// String fileNameImg = "onibusIgreja.png";
// String fileNameImg = "igreja.png";
// String fileNameImg = "trabalho.png";

// arquivo onde pega os dados e coloca

// Connection con = new Connection("escola.txt");
// Connection con = new Connection("escola2.txt");
// Connection con = new Connection("onibusIgreja_go.txt");
// Connection con = new Connection("igreja_go.txt");
// Connection con = new Connection("casa2trabalho.txt");
Connection con = new Connection("/Maps/one/","map001.txt");
// Connection con = new Connection("bhbus.txt");
// Connection con = new Connection("sair_escola.txt");

Algoris Alg = new Algoris();
PImage img;
ArrayList<String> nomesImgs = new ArrayList<String>();
int[][] valoresImgs = {
    {1228, 739}, // escola
    {1910, 887}, // trabalho
    {1920, 1080}, // onibusIgreja
    {1920, 1080} // igreja
};
ArrayList<Pack> Packs = new ArrayList<Pack>();
// variables
int lastMousePressed = 0;
int loop = 0;
int typeSelected = 0;
boolean breakThread = false;
boolean writeNode = false;
boolean changePositionImage = false;
boolean alreadyChangedPositionImage = false;
boolean toDrawImages = false;
boolean shiftPressed = false;
int dragX = 0,dragY = 0;
float zoom = 1,lastZoom = 1;
int[] infoImage = {0,0,0};
int variationImage = 10;
int tempo = 1;
int qtNodes = 0;
String relatorio = "";

void setup(){
    size(1980*3/4,1020);
    // createNodes();
    con.getIt();
    setPacks();
    setNomesImgs();
    images();
    if (Nodes.size() >= 1) basicRaw = Nodes.get(0).raw;
    // fullScreen();
    frameRate(100);
    
}

void draw(){
    background(#FFFFFF);
    if (toDrawImages) drawImages();
    // relatorio += "\n"+((float) -1000/tempo)+" FPS";
    // relatorio += "\n"+(tempo-millis())+" drawImages";

    scale(zoom);
    translate(dragX/zoom,dragY/zoom);
    // relatorio += "\n"+(tempo-millis())+" relatives";

    // relatorio += "\n"+((float) -1000/tempo)+" FPS";
    ecrivent();
    // position();

    drawAll();
    // println(nodePassing);
    // relatorio += "\n"+(tempo-millis())+" drawAll";
    correcao();
    // relatorio += "\n"+(tempo-millis())+" correcao";

    mouseAutomatic();
    markNodeSelected();
    // relatorio += "\n"+(tempo-millis())+" marking";
    //teste();
    if (changePositionImage) moveImages();
}

// images
void drawImages(){
    int qtImgs = 0;
    if (Packs.size() >= 1){
        for (Pack pack : Packs){
            if (pack.name.equals(namePack)){
                for (int i=0;i<pack.len();i++){
                    if ((pack.getPosX(i)*zoom+dragX)+pack.getPropX(i)*zoom >= 0 && (pack.getPosX(i)*zoom+dragX) <= width && ((pack.getPosY(i)*zoom+dragY)) <= height && ((pack.getPosY(i)*zoom+dragY))+pack.getPropY(i)*zoom >= 0){
                        if (infoImage[0] == i && changePositionImage) rect((pack.getPosX(infoImage[0])-5)*zoom+dragX,(pack.getPosY(infoImage[0])-5)*zoom+dragY,(pack.getPropX(infoImage[0])+10)*zoom,(pack.getPropY(infoImage[0])+10)*zoom);
                        image(pack.getImage(i),(int) ((pack.getPosX(i)*zoom+dragX)),(int) ((pack.getPosY(i)*zoom+dragY)),pack.getPropX(i)*zoom,pack.getPropY(i)*zoom);
                        qtImgs++;
                    }
                }
                break;
            }
        }
    }else{
        if (img != null) image(img,dragX,dragY,getPropImg('x')*zoom,getPropImg('y')*zoom);
    
    }
    relatorio += "\nimgs: "+qtImgs;
}

void images(){
    try {
        img = loadImage(fileNameImg);
    } catch (Exception e){

    }
}
void setPacks(){
    Pack add;

    // ctpm
    if (namePack == "unsv"){
        add = new Pack(namePack);
        add.add("Pack_UNSV/complement.png", 3085, 1075, -787, 1094);
        add.add("Pack_UNSV/cachoeirinha_uniao.png", 1980, 1020, 521, 485);
        add.add("Pack_UNSV/carlosprates.png", 1980, 1020, -281, 1445);
        add.add("Pack_UNSV/lourdes.png", 1980, 1020, 16, 2409);
        add.add("Pack_UNSV/parquemunicipal.png", 1980, 1020, 466, 1972);
        add.add("Pack_UNSV/prado_barropreto.png", 1980, 1020, -463, 2032);
        add.add("Pack_UNSV/cachoeirinha.png", 1980, 1020, -237, 415);
        add.add("Pack_UNSV/horto.png", 1980, 1020, 738, 1169);
        add.add("Pack_UNSV/santacruz.png", 1980, 1020, 258, -228);
        Packs.add(add);
    }else if (namePack.equals("mirinha")){
        add = new Pack(namePack);
        add.add("Pack_Mirinha/mineras.png", 1687, 780, -714, -35);
        add.add("Pack_Mirinha/alipiodemelo.png", 1668, 780, -1492, 903);
        add.add("Pack_Mirinha/santarosa.png", 1562, 775, 151, -14);
        add.add("Pack_Mirinha/cachoeirinha.png", 1532, 789, 308, 692);
        add.add("Pack_Mirinha/mataufmg.png", 1677, 779, -672, 673);
        add.add("Pack_Mirinha/br.png", 1677, 778, -811, 985);
        add.add("Pack_Mirinha/ouropreto.png", 1547, 801, -875, 271);
        add.add("Pack_Mirinha/castelocima.png", 1666, 791, -1535, 139);



        // for (int i=0;i<add.len();i++){
        //     add.setPosX(i,0);
        //     add.setPosY(i,0);
        // }
        Packs.add(add);
    }else if (namePack.equals("bhbus")){
         add = new Pack(namePack);
        add.add("Pack_bhbus/mineras.png", 1687, 780, -714, -35);
        add.add("Pack_bhbus/alipiodemelo.png", 1668, 780, -1492, 903);
        add.add("Pack_bhbus/santarosa.png", 1562, 775, 151, -14);
        add.add("Pack_bhbus/cachoeirinha.png", 1532, 789, 308, 692);
        add.add("Pack_bhbus/mataufmg.png", 1677, 779, -672, 673);
        add.add("Pack_bhbus/br.png", 1677, 778, -811, 985);
        add.add("Pack_bhbus/ouropreto.png", 1547, 801, -875, 271);
        add.add("Pack_bhbus/castelocima.png", 1666, 791, -1535, 139);



        // for (int i=0;i<add.len();i++){
        //     add.setPosX(i,0);
        //     add.setPosY(i,0);
        // }
        Packs.add(add);
    }



}
void moveImages(){
    for (Pack pack : Packs){
        if (pack.name.equals(namePack)){
            pack.setPosX(infoImage[0],infoImage[1]);
            pack.setPosY(infoImage[0],infoImage[2]);
            break;
        }
    }
}
//

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
    // println(qtChilds);
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
// casa2trabalho
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
    loop++;
    qtNodes = 0;
    // translate(dragX,dragY);
    float pax,pbx,px,pay,pby,py;
    ArrayList<Draw> after = new ArrayList<Draw>();
    boolean doPassing = true;
    nodePassing = null;
    for(Node node : Nodes){
        after.add(node.drawNode());
        after.add(node.write(" "));
        
        if (doPassing){
            px = (mouseX-dragX)/zoom;
            py = (mouseY-dragY)/zoom;
            pax = node.x-node.raw;
            pbx = node.x+node.raw;
            pay = node.y-node.raw;
            pby = node.y+node.raw;
            if (pax<=px&&px<=pbx&&pay<=py&&py<=pby){
                nodePassing = node;
                doPassing = false;
            }
        }
        
        num++;
        qtNodes++;
    }

    for (Draw draw : after){
        draw.drawIt();
    }
    translate(-dragX,-dragY);
    // if (nodeFlagged != null) println(nodeFlagged.id+" : "+loop);

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

// auxiliares
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
    // drags
    fill(#000000);
    String texto = dragX+" : "+dragY;
    textSize(25/zoom);
    text(texto,(10-dragX)/zoom,(height-10-dragY)/zoom);
    // text(texto,100,200);
    // qt nodes
    fill(#000000);
    tempo -= millis();
    relatorio += "\n"+((float) -1000/tempo)+" FPS";
    texto = ""+qtNodes+"    "+relatorio;
    tempo = millis();
    relatorio = "";
    textSize(25/zoom);
    text(texto,(10-dragX)/zoom,(30-dragY)/zoom);
    textSize(12);
    
}
int getPropImg(char eixo){ 
    int valor = 0;
    boolean exists = false;
    if (eixo == 'x'){
        int i = 0;
        for (String nome : nomesImgs){
            if (fileNameImg.equals(nome)){
                exists = true;
                break;
            }
            i++;
        }
        if (exists) valor = valoresImgs[i][0];
    }else if (eixo == 'y'){
        int i = 0;
        for (String nome : nomesImgs){
            if (fileNameImg.equals(nome)){
                exists = true;
                break;
            }
            i++;
        }
        if (exists) valor = valoresImgs[i][1];
    }
    return valor;
}
void setNomesImgs(){
    nomesImgs.add("escola.png");
    nomesImgs.add("trabalho.png");
    nomesImgs.add("onibusIgreja.png");
    nomesImgs.add("igreja.png");
    // nomesImgs.add("onibusIgreja.png");
}

// algoritmos
void algorithm(){
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
    // println(mouseX + " : "+mouseY + " | "+lastZoom);
    // if (pow(2,event.getCount()*(-1)) > 1){
    //     dragX += (width/2-mouseX);
    //     dragY += (height/2-mouseY);
    //     dragX = (x-width/2)*2 - width/2;
    //     dragY = (y-height/2)*2 - height/2;
    //     if (dragdragY = -dragY-width;
    // }

    // engine 1   
    lastZoom *= pow(2,event.getCount()*(-1));

    zoom = lastZoom;
    
    if (pow(2,event.getCount()*(-1)) > 1){
        dragX += (width/2-mouseX);
        dragY += (height/2-mouseY);
        dragX += -x+drx;
        dragY += -y+dry;
    }else{
        dragX = x-(-(drx+width/2)/2+width/2);
        dragY = y-(-(dry+height/2)/2+height/2);
        // println((-dragX+drx)+" : "+(-dragY+dry)+" | "+zoom);
    }    
}
void mouseAutomatic(){
    // if (nodeSelected == null) nodeCatched = null;
    if (nodeCatched != null){
        nodeCatched.x = (int) ((mouseX-dragX)/zoom);
        nodeCatched.y = (int) ((mouseY-dragY)/zoom);
    }

    // nodePassing = null;
    float pax,pbx,px,pay,pby,py;

    // minorisWay
    Node nodeMinorisWay = null;
    boolean showMinorisWay = false;
    if (nodePassing != null && nodeSelected == null){
        px = (mouseX-dragX)/zoom;
        py = (mouseY-dragY)/zoom;
        pax = nodePassing.x-nodePassing.raw;
        pbx = nodePassing.x+nodePassing.raw;
        pay = nodePassing.y-nodePassing.raw;
        pby = nodePassing.y+nodePassing.raw;
        if (pax<=px&&px<=pbx&&pay<=py&&py<=pby){
            nodeMinorisWay = nodePassing;
            showMinorisWay = true;
        }
    }else if (nodeFlagged != null){
        nodeMinorisWay = nodeFlagged;
        showMinorisWay = true;
    }
    if (showMinorisWay){
        if (nodeMinorisWay.minorisWay != null && nodeMinorisWay.minorisWay.size() >= 1){
            for (Node node2 : nodeMinorisWay.minorisWay){
                if (nodeMinorisWay.minorisWay.get(0) == node2) drawCrown(node2,#FF00FF);
                else drawCrown(node2,#FF0000);
            }
            drawCrown(nodeMinorisWay,#0000FF);
        }
    }
}
void mousePressed(){
    nodeCatched = null;
    for (Node node : Nodes){
        float pax,pbx,px,pay,pby,py;
        px = (mouseX-dragX)/zoom;
        py = (mouseY-dragY)/zoom;
        pax = node.x-node.raw;
        pbx = node.x+node.raw;
        pay = node.y-node.raw;
        pby = node.y+node.raw;
        if (pax<=px&&px<=pbx&&pay<=py&&py<=pby){
            typeSelected = mouseButton;
            if (mouseButton == LEFT){
                if (nodeSelected == null){
                    nodeSelected = node;
                }else{
                    if (nodeSelected == node) nodeSelected = null; // retira o node selecionado
                    else if (lastMousePressed == LEFT){
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
                            if (shiftPressed) nodeSelected = node; // continua selecionando o node que clicou
                            else nodeSelected = null;
                        }
                        
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
            break;
        }
    }
}
void mouseDragged() {
    // translate(mouseX-pmouseX,);
    dragX += mouseX-pmouseX;
    dragY += mouseY-pmouseY;
}
void keyPressed(){
    int variation = variationImage;
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
            Nodes.add(new Node(new ArrayList<Node>(),(int) ((mouseX-dragX)/zoom),(int) ((mouseY-dragY)/zoom),basicRaw,color((int) random(256),(int) random(256),(int) random(256)))); 
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
        }else if (key == 'a'){ // Algorithm
            thread("algorithm");
        }else if (key == 'w'){ // Write on the node or show iamges
            if (nodeSelected != null) writeNode = true;
            else toDrawImages = (toDrawImages) ? false : true;
        }else if (key == 'n'){ // Add new node
            Nodes.add(new Node(new ArrayList<Node>(),(int) ((mouseX-dragX)/zoom),(int) ((mouseY-dragY)/zoom),basicRaw,color((int) random(256),(int) random(256),(int) random(256))));  
        }else if (key == 'b'){ // Break Thread
            breakThread = (breakThread) ? false : true;
        }else if (key == 'c'){ // Catch node
            nodeCatched = (nodeCatched==null) ? nodePassing : null;
        }else if (key == 's'){ // Save
            con.setIt();
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
            // println(dragX + " : "+dragY+ " | "+lastZoom);
        }else if (key == 'p'){ // show position
            println(mouseX + " : "+mouseY + " | "+lastZoom);
        }else if (keyCode == UP){
            if (changePositionImage) infoImage[2]-=variation;
            else{
                for (Node node : Nodes) node.raw += (node.raw>=100) ? 0 : 1;
                basicRaw = Nodes.get(0).raw;
            }
        }else if (keyCode == DOWN){
            if (changePositionImage) infoImage[2]+=variation;
            else{
                for (Node node : Nodes) node.raw -= (node.raw<=1) ? 0 : 1;
                basicRaw = Nodes.get(0).raw;
            }
        }else if (key == 'f'){ // Flag on the point
            nodeFlagged = (nodeFlagged==null || nodePassing!=nodeFlagged) ? nodePassing : null;
        }else if (key == ESC){
            exitManually();
        }else if (keyCode == LEFT){
            if (changePositionImage) infoImage[1]-=variation;
        }else if (keyCode == RIGHT){
            if (changePositionImage) infoImage[1]+=variation;
        }else if (key == ','){
            infoImage[0]--;
            int len=0;
            for (Pack pack : Packs) if (pack.name.equals(namePack)) len=pack.len();
            if (infoImage[0]<0) infoImage[0]+=len;
            for (Pack pack : Packs) if (pack.name.equals(namePack)){
                infoImage[1] = pack.getPosX(infoImage[0]);
                infoImage[2] = pack.getPosY(infoImage[0]);
            }
        }else if (key == '.'){
            infoImage[0]++;
            int len=0;
            for (Pack pack : Packs) if (pack.name.equals(namePack)) len=pack.len();
            if (infoImage[0]>=len) infoImage[0]-=len;
            for (Pack pack : Packs) if (pack.name.equals(namePack)){
                infoImage[1] = pack.getPosX(infoImage[0]);
                infoImage[2] = pack.getPosY(infoImage[0]);
            }
        }else if (key == '['){
            for(Pack pack : Packs){
                if (pack.name.equals(namePack)){
                    pack.passTo(infoImage[0],-1);
                }
            }
            infoImage[0]++;
            int len=0;
            for (Pack pack : Packs) if (pack.name.equals(namePack)) len=pack.len();
            if (infoImage[0]>=len) infoImage[0]=len-1;
            for (Pack pack : Packs){
                if (pack.name.equals(namePack)){
                    infoImage[1] = pack.getPosX(infoImage[0]);
                    infoImage[2] = pack.getPosY(infoImage[0]);
                }
            }
        }else if (key == ']'){
            for(Pack pack : Packs){
                if (pack.name.equals(namePack)){
                    pack.passTo(infoImage[0],1);
                }
            }
            infoImage[0]--;
            int len=0;
            for (Pack pack : Packs) if (pack.name.equals(namePack)) len=pack.len();
            if (infoImage[0]<0) infoImage[0]=0;
            for (Pack pack : Packs){
                if (pack.name.equals(namePack)){
                    infoImage[1] = pack.getPosX(infoImage[0]);
                    infoImage[2] = pack.getPosY(infoImage[0]);
                }
            }
        }else if (keyCode == CONTROL){
            variationImage += (variationImage<=1) ? 0 : -1;
        }else if (keyCode == SHIFT){
            shiftPressed = true;
            variationImage += (variationImage>=1000) ? 0 : 1;
        }else if(key == 'i'){
            for (Pack pack : Packs) if (pack.name.equals(namePack)){
                infoImage[1] = pack.getPosX(infoImage[0]);
                infoImage[2] = pack.getPosY(infoImage[0]);
            }
            changePositionImage = (changePositionImage) ? false : true;
            alreadyChangedPositionImage = true;
        }else if (key == 'o'){
            ArrayList<ArrayList<Node>> conects = new ArrayList<ArrayList<Node>>();
            for (Node node : Nodes){
                conects.add(node.connected);
                node.connected = new ArrayList<Node>();
            }
            int i =0;
            for (Node node : Nodes){
                for (Node nodeFather : conects.get(i)){
                    nodeFather.connected.add(node);
                }
                i++;
            }

        }
    }
    
}
void keyReleased() {
    switch (keyCode){
        case SHIFT:
            shiftPressed = false;
    }
}

void exitManually(){
    if (alreadyChangedPositionImage){
        for (Pack pack : Packs){
            if (namePack.equals(pack.name)){
                for (int i=0;i<pack.len();i++) println("add.add(\""+pack.getName(i)+"\", "+pack.getPropX(i)+", "+pack.getPropY(i)+", "+pack.getPosX(i)+", "+pack.getPosY(i)+");");
                break;
            }
        }
    }
    exit();
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
