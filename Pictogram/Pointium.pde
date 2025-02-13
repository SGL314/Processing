import java.util.HashMap;

class Pointium extends Thing {
  int alpha = 10,sectorsTypes=0,timeToGrow,lastTimeGrew;
  float distance = 1;
  boolean initLife = true;
  ArrayList<Conectum> children = new ArrayList<Conectum>();

  Pointium(float px,float py){
    super();
    super._color = color(random(64,240),random(64,240),random(64,240));
    this.alpha = 255;
    super.px = round(px*1)/1;
    super.py = round(py*1)/1;
    super.raw = 10;
    this.timeToGrow = 50;
    this.lastTimeGrew = 0;
    this.sectorsTypes = 4;
    this.distance = super.raw*pow(2,sectorsTypes-1);
    super.grandFather = this;
    super.father = this;
  }

  void putName(){
    super.name = "Pointium";
  }

  void draw(){
    if (this.lived){      
      if (running) processing();
      aftermeter.put(this.getId(),"circle",this.px,this.py,this.raw,this._color,this.alpha,this._color);
    }else{
      aftermeter.put(this.getId(),"circle",this.px,this.py,this.raw,#000000,this.alpha,#000000);
    }
    showMarkation();
  }
  void processing(){
    connect();
    if (initLife){
      presetChildren();
      initLife=false;
    }
    this.lastTimeGrew++;
    if (this.lastTimeGrew>=this.timeToGrow){
      if (toGrow()) this.lastTimeGrew=0;
    }
  }
  void connect(){
    improveNetwork();
  }

  void presetChildren(){
    String[] directions = {"-y,30","z,90","-x,150","y,210","-z,270","x,330"};
  }

  boolean toGrow(){
    String[] bicoords = {"-y,z","x,-y","x,-z","y,-z","-x,y","-x,z"};
    String[] coords = {"-y","z","-x","y","-z","x"};
    HashMap<String,Integer> directions = new HashMap<String,Integer>();
    directions.put("-y",30);
    directions.put("z",90);
    directions.put("-x",150);
    directions.put("y",210);
    directions.put("-z",270);
    directions.put("x",330);
    
    // put everyone on a list
    ArrayList<Thing> everyone = new ArrayList<>();
    everyone.add(this);
    int len = 1;
    for (Conectum child : children){
      everyone.add(child);
      len++;
    }
    // choses one
    
    // set position
    int trying = 5;
    while (trying>0) {
      Thing thing = everyone.get((int) random(len));
      // sorts the trains
      int nx=thing.nx,
      ny=thing.ny,
      nz=thing.nz;
      // to fix
      String[] fixs = {"x","y","z"};
      String fix = fixs[(int)random(3)];
      int num = (int)((int)random(1,pow(2,sectorsTypes-1))*(((int)random(2))*2-1));
      // put other equal
      switch (fix){
        case "z":
          nx += num;
          ny += num;
          break;
        case "y":
          nx += num;
          nz += num;
          break;
        case "x":
          nz += num;
          ny += num;
          break;
      }

      if (abs(nx)>pow(2,sectorsTypes-1)||abs(ny)>pow(2,sectorsTypes-1)||abs(nz)>pow(2,sectorsTypes-1)){
        trying--;
        continue;
      }
      boolean put = true;
      for (Thing thing2 : things){
        if (thing2.grandFather == this && equalRealDirections(thing2,nx,ny,nz)){
          put = false;
          break;
        }
      }
      if(put) {
        print(thing.nx+","+thing.ny+","+thing.nz+" > "+nx+","+ny+","+nz);
        Conectum toPut = new Conectum(this,thing,nx,ny,nz,_color);
        children.add(toPut);
        thing.connecteds.add(toPut);
        toAdd.add(toPut);
        return true;
      }
      trying--;
    }
    return false;

  }

  // void improveNetwrok(){
  //   HashMap<String, ArrayList<Thing>> childrenByDirection = new HashMap<>();
  //   String[] directions = {"-y","z","-x","y","-z","x"};
  //   for (String item : directions) childrenByDirection.put(item,null);
  //   for (Thing thing : connecteds){
  //     String direction = "o";
  //     if (thing.nz-this.nz==0){
  //       if (thing.ny==thing.nx&&thing.nx>0){
  //         direction = "z";
  //         // compare
  //         if (childrenByDirection.get(direction)!=null){
  //           if (childrenByDirection.get(direction).nx>thing.nx) childrenByDirection.get(direction).add(thing);
  //         }
  //       }else if (thing.ny==thing.nx&&thing.nx<0){
  //         direction = "-z";
  //         // compare
  //         if (childrenByDirection.get(direction)!=null){
  //           if (childrenByDirection.get(direction).nx<thing.nx) childrenByDirection.get(direction).add(thing);
  //         }
  //       }
  //     }else if (thing.ny-this.ny==0){
  //       if (thing.nz==thing.nx&&thing.nx>0){
  //         direction = "y";
  //         // compare
  //         if (childrenByDirection.get(direction)!=null){
  //           if (childrenByDirection.get(direction).nx>thing.nx) childrenByDirection.get(direction).add(thing);
  //         }
  //       }else if (thing.nz==thing.nx&&thing.nx<0){
  //         direction = "-y";
  //         // compare
  //         if (childrenByDirection.get(direction)!=null){
  //           if (childrenByDirection.get(direction).nx<thing.nx) childrenByDirection.get(direction).add(thing);
  //         }
  //       }
  //     }else if (thing.nx-this.nx==0){
  //       if (thing.nz==thing.ny&&thing.ny<0){
  //         direction = "x";
  //         // compare
  //         if (childrenByDirection.get(direction)!=null){
  //           if (childrenByDirection.get(direction).ny>thing.ny) childrenByDirection.get(direction).add(thing);
  //         }
  //       }else if (thing.nz==thing.ny&&thing.ny<0){
  //         direction = "-x";
  //         // compare
  //         if (childrenByDirection.get(direction)!=null){
  //           if (childrenByDirection.get(direction).ny<thing.ny) childrenByDirection.get(direction).add(thing);
  //         }
  //       }
  //     }
      
  //   }
  //   // sort
  //   for (String key : childrenByDirection.keys()){
  //     ArrayList<Thing> array = new ArrayList<>();
  //     ArrayList<Thing> remainArray = new ArrayList<>();
  //     for (Thing item : childrenByDirection.get(key)) remainArray.add(item);
  //     while (!remainArray.size()==0){
  //       Thing less = null;
  //       for (ArrayList<Thing> item : remainArray){
  //         switch (key){
  //           case "x":
  //             if(less!=null)if(less.ny>item.ny)less=item;else less=item;
  //             break;

  //           case "-x":
  //             if(less!=null)if(less.ny<item.ny)less=item;else less=item;
  //             break;

  //           case "y":
  //             if(less!=null)if(less.nx>item.nx)less=item;else less=item;
  //             break;

  //           case "-y":
  //             if(less!=null)if(less.nx<item.nx)less=item;else less=item;
  //             break;

  //           case "z":
  //             if(less!=null)if(less.nx>item.nx)less=item;else less=item;
  //             break;

  //           case "-z":
  //             if(less!=null)if(less.nx<item.nx)less=item;else less=item;
  //             break;
  //         }
  //       }
  //       remainArray.remove(less);
  //       array.add(less);
  //     }
  //     childrenByDirection.put(key,array);
  //   }
  //   // put father by father
  //   for (String key : childrenByDirection.keys()){
  //     int ind = 0;
  //     Thing last = null;
  //     for (Thing thing : childrenByDirection.get(key)){
  //       if (ind == 0){
  //         thing.father = this;
  //       }else{
  //         thing.father = last;
  //       }
  //       last = thing;
  //       ind++;
  //     }
  //   }
  // }

  // void uplodLayourNexters(){
  //   String[] bicoords = {"-y,z","x,-y","x,-z","y,-z","-x,y","-x,z"};
  //   HashMap<String,Integer> directions = new HashMap<String,Integer>();
  //   directions.put("-y",30);
  //   directions.put("z",90);
  //   directions.put("-x",150);
  //   directions.put("y",210);
  //   directions.put("-z",270);
  //   directions.put("x",330);
  //   for (String bicoord : bicoords){
  //     String a,b;
  //     a = bicoord.split(",")[0];
  //     b = bicoord.split(",")[1];
  //     float posx=0,posy=0;
  //     posx += cos(directions.get(a)*PI/180)*this.distance/pow(2,sectorsTypes-1);
  //     posx += cos(directions.get(b)*PI/180)*this.distance/pow(2,sectorsTypes-1);
  //     posy += sin(directions.get(a)*PI/180)*this.distance/pow(2,sectorsTypes-1);
  //     posy += sin(directions.get(b)*PI/180)*this.distance/pow(2,sectorsTypes-1);
  //     toAdd.add(new Conectum(this,posx,posy,_color));
  //   }
  // }


  


  
  
  
  
}
