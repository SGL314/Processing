Padrao padrao = new Padrao();
Miriam miriam = new Miriam();
Mini_Miriam mini_miriam = new Mini_Miriam();
Davi davi = new Davi();
Modeler modeler = new Modeler();

void setup() {
    // padrao.init();
    // miriam.init();
    // mini_miriam.init();
     //davi.init();
    modeler.init();
    size(1000,1000);
}

void draw() {
    // padrao.draw();
    // miriam.draw();    
    // mini_miriam.draw(); 
     //davi.draw();
    modeler.draw();
}

// UI

void mouseWheel(MouseEvent event){
    if (modeler.ctrlPressed){
        modeler.angle += event.getCount()*(-1);
        if (modeler.angle < 0) modeler.angle += 360;
        if (modeler.angle > 360) modeler.angle -= 360;
    }else{
        int x = mouseX;
        int y = mouseY;
        int drx = modeler.dragX;
        int dry = modeler.dragY;

        modeler.lastZoom = modeler.zoom; 
        modeler.lastZoom *= pow(2,event.getCount()*(-1));

        modeler.zoom = modeler.lastZoom;
        
        if (pow(2,event.getCount()*(-1)) > 1){
            modeler.dragX += (width/2-mouseX);
            modeler.dragY += (height/2-mouseY);
            modeler.dragX += -x+drx;
            modeler.dragY += -y+dry;
        }else{
            modeler.dragX = x-(-(drx+width/2)/2+width/2);
            modeler.dragY = y-(-(dry+height/2)/2+height/2);
        }
    }    
}
void mouseDragged(){
    modeler.dragX += mouseX-pmouseX;
    modeler.dragY += mouseY-pmouseY; //  type,float px,float py,float wid,float hei,int cor,float alp
}

void keyReleased(){
    char chave = (""+key).toLowerCase().toCharArray()[0];

    if (chave == modeler.keyMap.get("new-chair").toCharArray()[0]){
        float px = mouseX/modeler.zoom-modeler.tamCadeira/2-modeler.dragX/modeler.zoom;
        float py = mouseY/modeler.zoom-modeler.tamCadeira/2-modeler.dragY/modeler.zoom;
        // translate(-modeler.dragX/modeler.zoom,-modeler.dragY/modeler.zoom);

        modeler.things.add(new Thing("cadeira",px,py,modeler.tamCadeira,modeler.tamCadeira,modeler.angle,modeler.corCadeiras,modeler.alphaCorCadeiras));
    
    }else if (chave == modeler.keyMap.get("quit").toCharArray()[0]){
        exit();
    }

    switch (keyCode){
        case CONTROL:
            modeler.ctrlPressed = false;
            break;
        case SHIFT:
            modeler.shiftPressed = false;
            break;
    }
}
void keyPressed(){
    switch (keyCode){
        case CONTROL:
            modeler.ctrlPressed = true;
            break;
        case SHIFT:
            modeler.shiftPressed = true;
            break;
    }
}
