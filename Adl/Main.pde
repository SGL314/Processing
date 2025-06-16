Padrao padrao = new Padrao();
Miriam miriam = new Miriam();
Mini_Miriam mini_miriam = new Mini_Miriam();
Davi davi = new Davi();
Modeler modeler = new Modeler("Modelos","Coliseu_model"); // somente o nome, sem o '.txt' e sem '/'

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
        modeler.angle += event.getCount()*(-1)*modeler.variationAngle;
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
    if (modeler.shiftPressed){
        // pass
    }else{
        modeler.settedPossSelector = false;
        modeler.dragX += mouseX-pmouseX;
        modeler.dragY += mouseY-pmouseY;
    }
}

void keyReleased(){
    char chave = (""+key).toLowerCase().toCharArray()[0];
    if (modeler.ctrlPressed){
        if (keyCode == UP){ // angleUP
            modeler.variationAngle ++;
        }else if (keyCode == DOWN){ // angleDOWN
            modeler.variationAngle --;
        }
        if (modeler.variationAngle < 1) modeler.variationAngle = 1;
        if (modeler.variationAngle > 10) modeler.variationAngle = 10;
   
    }else{
        if (chave == modeler.keyMap.get("new-chair").toCharArray()[0]){ // new-chair

            float px = mouseX/modeler.zoom-modeler.dragX/modeler.zoom;
            float py = mouseY/modeler.zoom-modeler.dragY/modeler.zoom - modeler.tamCadeira;
            modeler.things.add(new Thing("cadeira",px,py,modeler.tamCadeira,modeler.tamCadeira,modeler.angle,modeler.corCadeiras,modeler.alphaCorCadeiras));
        
        }else if (chave == modeler.keyMap.get("quit").toCharArray()[0]){ // quit
            exit();
        }else if (chave == modeler.keyMap.get("show-preview-new-chair").toCharArray()[0]){ // show-preview-new-chair
            modeler.showPreviewNewChair = (modeler.showPreviewNewChair) ? false : true;
        }else if (chave == modeler.keyMap.get("clear-selecteds").toCharArray()[0]){
            for (Thing thing : modeler.things){
                thing.selected = false;
            }
        }else if (chave == modeler.keyMap.get("save").toCharArray()[0]){
            modeler.saveModel();
        }
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
        case DELETE:
            ArrayList<Thing> remover = new ArrayList<Thing>();

            for (Thing thing : modeler.things){
                if (thing.selected){
                    remover.add(thing);
                }
            }

            for (Thing thing : remover){
                modeler.things.remove(thing);
            }

            break;
    }
}
