ArrayList<Thing> things = new ArrayList<Thing>();
ArrayList<Thing> toAdd = new ArrayList<Thing>();
ArrayList<Thing> toRemove = new ArrayList<Thing>();
ArrayList<Thing> markeds = new ArrayList<Thing>();
ArrayList<Thing> remainMarkeds = new ArrayList<Thing>();
UI ui = new UI();
Writer writer = new Writer();
Aftermeter aftermeter = new Aftermeter();
int loop=0,dragX=0,dragY=0,showSelect = 0;
float zoom=1,lastZoom=1;
boolean running = true;
// Actions
ArrayList<Action> actions = new ArrayList<Action>();

void setup(){
  size(600,600);
  setActions();
}

void draw(){
  loop++;
  background(#DADADA);


  writer.write(ui);
  scale(zoom);
  translate(dragX/zoom,dragY/zoom);
  //
  //
  ArrayList<Action> workingActions = copyActions(actions,"main");
  toRemove = new ArrayList<Thing>();
  toAdd = new ArrayList<Thing>();
  remainMarkeds = copyThings(markeds);

  for (Thing thing : things){
    thing.draw();
    if (ui.firstIteraion_Dragged==false){
      thing.markMe(touched(thing,aftermeter.find("selection")));
    }
    // Actions
    if (workingActions.stream().filter(action -> "showHierarchy".equals(action.name)).findFirst().orElse(null).threw && thing.marked){
      thing.father.marked = true;
      thing.father.markedType = "one";
    }
    if (workingActions.stream().filter(action -> "deleteMarkeds".equals(action.name)).findFirst().orElse(null).threw && thing.marked){
      toRemove.add(thing);
    }
    if (thing instanceof Pointium){
      if (workingActions.stream().filter(action -> "giveLife".equals(action.name)).findFirst().orElse(null).threw && thing.marked){
        Pointium thingA = (Pointium) thing;
        thingA.lived = true;
      }
    }
    if (workingActions.stream().filter(action -> "refreshMarkeds".equals(action.name)).findFirst().orElse(null).threw){
      thing.marked = false;
      thing.markedType = "one";
    }
  }
  for (Thing thing : toRemove){
    things.remove(thing);
  }
  for (Thing thing : toAdd){
    things.add(thing);
  }

  ui.dinamicInterations();
  aftermeter.draw();
  actions = copyActions(workingActions,"return");
  markeds = copyThings(remainMarkeds);
}

boolean touched(Thing thing,Figure figure){
  float ax,bx,ay,by,ch;
  switch (thing.name){
    case "Pointium":
      ax = (mouseX-dragX)/zoom;
      bx = (ui.initialPositionX_Dragged-dragX)/zoom;
      ay = (mouseY-dragY)/zoom;
      by = (ui.initialPositionY_Dragged-dragY)/zoom;
      if (bx>ax){
        ch = ax;
        ax = bx;
        bx = ch;
      }
      if (by>ay){
        ch = ay;
        ay = by;
        by = ch;
      }
      if (
        (thing.px+thing.raw>=bx &&
        thing.px+thing.raw<=ax ||
        thing.px-thing.raw>=bx &&
        thing.px-thing.raw<=ax) &&
        (thing.py+thing.raw>=by &&
        thing.py+thing.raw<=ay ||
        thing.py-thing.raw>=by &&
        thing.py-thing.raw<=ay)
      ){
        return true;
      }
      break;
    case "Conectum":
      ax = (mouseX-dragX)/zoom;
      bx = (ui.initialPositionX_Dragged-dragX)/zoom;
      ay = (mouseY-dragY)/zoom;
      by = (ui.initialPositionY_Dragged-dragY)/zoom;
      if (bx>ax){
        ch = ax;
        ax = bx;
        bx = ch;
      }
      if (by>ay){
        ch = ay;
        ay = by;
        by = ch;
      }
      if (
        (thing.px+thing.raw>=bx &&
        thing.px+thing.raw<=ax ||
        thing.px-thing.raw>=bx &&
        thing.px-thing.raw<=ax) &&
        (thing.py+thing.raw>=by &&
        thing.py+thing.raw<=ay ||
        thing.py-thing.raw>=by &&
        thing.py-thing.raw<=ay)
      ){
        return true;
      }
      break;
    default:
      println("ERROR : touched > Name not recongnized : '"+thing.name+"'");
  }
  return false;
}

// UI
void mouseReleased(){
  ui.mouseReleased(mouseButton);
}
void mouseDragged(){
  ui.mouseDragged(mouseButton);
}
void mouseWheel(MouseEvent event){
  ui.mouseWheel(event);
}
void keyReleased(){
  ui.keyReleased(key,keyCode);
}
void keyPressed(){
  ui.keyPressed(key,keyCode);
}

// Workable
void setActions(){
  actions.add(new Action("refreshMarkeds"));
  actions.add(new Action("deleteMarkeds"));
  actions.add(new Action("giveLife"));
  actions.add(new Action("showHierarchy"));
}
void throwAction(String name,boolean repeat){
  boolean found = false;
  for (Action action : actions){
    if (name == action.name){
      action.throwAction((repeat) ? !(action.repeat) : false);
      found = true;
      break;
    }
  }
  if (!found){
    println("ERROR : throwAction > Not found action's name : '"+name+"'");
  }
}

// Auxs
void drawCrown(Thing node,color _color) {
    float outerRadius = node.raw*1.4;
    float innerRadius = node.raw*1.2;

    int numSegments = 50; // Número de segmentos da coroa

    float angleStep = TWO_PI / numSegments;
    
    fill(_color); // cor vermelha
    //
    noStroke();

    beginShape();
    for (int i = 0; i <= numSegments; i++) {
    float angle = i * angleStep;
    float xOuter = node.px+ cos(angle) * outerRadius;
    float yOuter = node.py+ sin(angle) * outerRadius;
    vertex(xOuter, yOuter);
    }
    for (int i = numSegments; i >= 0; i--) {
    float angle = i * angleStep;
    float xInner = node.px+ cos(angle) * innerRadius;
    float yInner = node.py+ sin(angle) * innerRadius;
    vertex(xInner, yInner);
    }
    endShape(CLOSE);
    stroke(1);
}
ArrayList<Action> copyActions(ArrayList<Action> array,String mode){
  ArrayList<Action> put = new ArrayList<Action>();
  if (mode=="main"){
    for (Action item : array){
      Action action = new Action(item.name);
      action.threw = item.threw;
      put.add(action);
    }
  }else if (mode=="return"){
    for (Action item : array){
      Action action = new Action(item.name);
      Action eq_action = actions.stream().filter(act -> act.name.equals(item.name)).findFirst().orElse(null);
      if (item.repeat){
        put.add(eq_action);
      }else{
        if (eq_action.threw && !item.threw){
          put.add(eq_action);
        }else{
          put.add(action);
        }
      }
    }
  }else{
    println("ERROR : copyActions > Mode not defined : '"+mode+"'");
  }
  return put;
}
ArrayList<Thing> copyThings(ArrayList<Thing> toCopy){
  ArrayList<Thing> toPaste = new ArrayList<Thing>();
  for (Thing thing : toCopy) toPaste.add(thing);
  return toPaste;
}
