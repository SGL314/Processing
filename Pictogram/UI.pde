class UI{
    String mode = "Movement";
    boolean firstIteraion_Dragged = true,modeDrag=true,
    ctrlPressed=false,cPressed=false;
    float initialPositionX_Dragged,initialPositionY_Dragged;
    Thing changeColor = null;

    UI(){

    }

    void dinamicInterations(){
        position();
        resetVariables();
    }

    // mouse
    void mouseReleased(int mouseButton) {
        if (mouseButton == LEFT){
            switch (this.mode){
                case "PutPointium":
                    things.add(new Pointium((mouseX-dragX)/zoom,(mouseY-dragY)/zoom));
                    break;
            }
        }
        firstIteraion_Dragged = true;
    }
    void mouseDragged(int mouseButton) {
        if (ctrlPressed){
            if (mouseButton == LEFT){
                if (firstIteraion_Dragged){
                    initialPositionX_Dragged = mouseX;
                    initialPositionY_Dragged = mouseY;
                    firstIteraion_Dragged = false;
                }
                modeDrag = true;
                aftermeter.put("selection","rect",initialPositionX_Dragged,initialPositionY_Dragged,(mouseX-initialPositionX_Dragged)/zoom,(mouseY-initialPositionY_Dragged)/zoom,#ADB9FF,128,#4865FF);
            }else if (mouseButton == RIGHT){
                if (firstIteraion_Dragged){
                    initialPositionX_Dragged = mouseX;
                    initialPositionY_Dragged = mouseY;
                    firstIteraion_Dragged = false;
                }
                modeDrag = false;
                aftermeter.put("selection","rect",initialPositionX_Dragged,initialPositionY_Dragged,(mouseX-initialPositionX_Dragged)/zoom,(mouseY-initialPositionY_Dragged)/zoom,#FFAFAF,128,#FF4848);
            }
        }else{
            dragX+=mouseX-pmouseX;
            dragY+=mouseY-pmouseY;
        }
    }
    void mouseWheel(MouseEvent event){
        int x = mouseX;
        int y = mouseY;
        int drx = dragX;
        int dry = dragY;

        lastZoom = zoom;  
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
        }
    }

    // keyboard
    void keyReleased(char key, int keyCode) {
        switch (key) {
            case 'p': // mode PutPointium
                this.mode = (mode.equals("PutPointium")) ? "Movement" : "PutPointium";
                break;
            case 'm': // mode Movement
                this.mode = "Movement";
                break;
            case 'd': // delete 
                throwAction("deleteMarkeds",false);
                break;
            case 'r': // remove Markeds
                throwAction("refreshMarkeds",false);
                break;
            case 'l': // give Life
                throwAction("giveLife",false);
                break;
            case 'i': // show Hierarchy
                throwAction("showHierarchy",true);
                break;
            case 'c': // change color
                cPressed = false;
                break;
        }
        switch (keyCode) {
            case CONTROL:
                ctrlPressed = false;
                firstIteraion_Dragged = true;
                break;
            case UP:
                if (cPressed){
                    
                }
            case 32: // (SPACE)
                running = (running) ? false : true;
                break;
        }
    }
    void keyPressed(char key, int keyCode) {
        switch (key) {
            case 'c': // change color
                if (showSelect==1){
                    changeColor = markeds.get(0);
                }else{
                    cPressed = false;
                    changeColor = null;
                }
                cPressed = true;
                break;
        }
        switch (keyCode) {
            case CONTROL:
                ctrlPressed = true;
                break;
        }
    }

    // others
    void position(){
        String add = "";
        if (showSelect>0){
            add = "|"+showSelect;
        }
        writer.texter((mouseX-dragX)/zoom+","+(mouseY-dragY)/zoom+add,#ff0000,(mouseX-dragX)/zoom,(mouseY-dragY)/zoom,20/zoom,"default");
    }
    void resetVariables(){
        showSelect = 0;
    }


}
