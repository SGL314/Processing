abstract class Thing implements IThing {
    int nx=0,ny=0,nz=0;
    float px = 0, py = 0, raw = 1;
    String name = "Thing",markedType = "one";
    boolean marked = false, lived=false;
    color _color;
    Thing father = null,grandFather=null;
    ArrayList<Thing> connecteds = new ArrayList<>();

    Thing() {
        putName();
    }

    public void markMe(boolean markMe) {
        if (markMe) {
            this.marked = ui.modeDrag;// ERROR
            this.markedType = "one";
            remainMarkeds.add(this);
            showSelect++;
        }
    }

    abstract void draw(); // put in [showMarkation]
    abstract void connect(); // in draw
    void showMarkation(){
        // defines color by markedType
        if (this.marked){
            color dc_color = #ff0000;
            switch (markedType){
                case "one":
                    break;
                case "two":
                    dc_color = #00ff00;
                    break;
                case "three":
                    dc_color = #0000ff;
                    break;
                default:
                    println("ERROR: showMarkation > Marked Type not defined: '"+markedType+"'");
            }
            drawCrown(this,dc_color);
        }
    }
    // abstract void improveNetwrok(); // in connect
    void improveNetwork(){
        HashMap<String, ArrayList<Thing>> childrenByDirection = new HashMap<>();
        String[] directions = {"-y","z","-x","y","-z","x"};
        for (String item : directions) childrenByDirection.put(item,new ArrayList<Thing>());
        // put by direction
        for (Thing thing : connecteds){
        String direction = "o";
        if (thing.nz-this.nz==0){
            if (thing.ny-this.ny==thing.nx-this.nx&&thing.nx-this.nx>0){
            direction = "z";
            // compare
            childrenByDirection.get(direction).add(thing);
            
            }else if (thing.ny-this.ny==thing.nx-this.nx&&thing.nx-this.nx<0){
            direction = "-z";
            // compare
            childrenByDirection.get(direction).add(thing);
            
            }
        }else if (thing.ny-this.ny==0){
            if (thing.nz-this.nz==thing.nx-this.nx&&thing.nx-this.nx>0){
            direction = "y";
            // compare
            childrenByDirection.get(direction).add(thing);
            
            }else if (thing.nz-this.nz==thing.nx-this.nx&&thing.nx-this.nx<0){
            direction = "-y";
            // compare
            childrenByDirection.get(direction).add(thing);
            
            }
        }else if (thing.nx-this.nx==0){
            if (thing.nz-this.nz==thing.ny-this.ny&&thing.ny-this.ny>0){
            direction = "x";
            // compare
            childrenByDirection.get(direction).add(thing);
            
            }else if (thing.nz-this.nz==thing.ny-this.ny&&thing.ny-this.ny<0){
            direction = "-x";
            // compare
            childrenByDirection.get(direction).add(thing);
            
            }
        }
        
        }
        // sort
        for (String key : childrenByDirection.keySet()){
            ArrayList<Thing> array = new ArrayList<>();
            ArrayList<Thing> remainArray = new ArrayList<>();
            if (childrenByDirection.get(key)==null) continue;
            // print(key+":");
            for (Thing item : childrenByDirection.get(key)){
                // print(item.showDirections()+">");
                remainArray.add(item);
            }
            int turn = 0;
            while (!(remainArray.size()==0)){
                Thing less = null;
                for (Thing item : remainArray){
                switch (key){
                    case "x":
                    if(less!=null){
                        if(less.ny>item.ny)less=item;
                    }else less=item;
                    break;

                    case "-x":
                    if(less!=null){
                        if(less.ny<item.ny)less=item;
                    }else less=item;
                    break;

                    case "y":
                    if(less!=null){
                        if(less.nx>item.nx)less=item;
                    }else less=item;
                    break;

                    case "-y":
                    if(less!=null){
                        if(less.nx<item.nx)less=item;
                    }else less=item;
                    break;

                    case "z":
                    if(less!=null){
                        if(less.nx>item.nx)less=item;
                    }else less=item;
                    break;

                    case "-z":
                    if(less!=null){
                        if(less.nx<item.nx)less=item;
                    }else less=item;
                    break;
                }
                }
                remainArray.remove(less);
                array.add(less);
                turn++;
                // println(remainArray.size());
            }
            childrenByDirection.put(key,array);
        }
        // put father by father
        ArrayList<Thing> newConnecteds = new ArrayList<>();
        for (String key : childrenByDirection.keySet()){
            int ind = 0;
            Thing last = null;
            // print(key+":");
            if (childrenByDirection.get(key)==null) continue;
            for (Thing thing : childrenByDirection.get(key)){
                // print(thing.showDirections()+">");
                if (ind == 0){
                    thing.father.connecteds.remove(thing);
                    thing.father = this;
                    this.connecteds.add(thing);
                }else{
                    thing.father.connecteds.remove(thing);
                    thing.father = last;
                    last.connecteds.add(thing);
                }
                newConnecteds.add(thing);
                last = thing;
                ind++;
            }
            // println("<"+loop);
        }
        connecteds = newConnecteds;
        // by line fathers
        Thing a=this;
        Thing b=a.father;
        for (Thing c : things){
            if (a!=b&&b!=c&&c!=a){
                if (internCollinear(a,c,b)){
                    c.father = b;
                    c.father.connecteds.remove(c);
                    b.connecteds.remove(a);
                    a.father = c;
                    c.connecteds.add(a);
                    c.father = b;
                    b.connecteds.add(c);
                    
                    a.marked = true;
                    b.marked = true;
                    c.marked = true;
                    a.markedType = "one";
                    b.markedType = "two";
                    c.markedType = "three";
                    println("Replaceing fathers "+loop);
                    // running = false;
                }
                
            }
        }
        //
        
    }

    String showDirections(){
        return this.nx+","+this.ny+","+this.nz;
    }
    int[] getDirections(){
        return new int[]{this.nx,this.ny,this.nz};
    }

    void updateColor(color newColor){
        this._color = newColor;
        for (Thing con : connecteds){
            con.updateColor(newColor);
        }
    }

    String getId(){
        return this.name+"_"+this+"_"+this.showDirections();
    }

    boolean internCollinear(Thing a,Thing b,Thing c){
        /* determinant
        |ax,ay,1|ax,ay
        |bx,by,1|bx,by
        |cx,cy,1|cx,cy
        det = -(cx*by+ax*cy+ay*bx)+(ax*by+ay*cx+bx*cy)
        */
        int[][] rd = {getRealDirection(a),getRealDirection(b),getRealDirection(c)};
        int det = -(rd[2][0]*rd[1][1]+rd[0][0]*rd[2][1]+rd[0][1]*rd[1][0])+(rd[0][0]*rd[1][1]+rd[0][1]*rd[2][0]+rd[1][0]*rd[2][1]);
        if (det==0) {
            if (rd[0][0]>rd[1][0]&&rd[1][0]>rd[2][0] || rd[0][0]<rd[1][0]&&rd[1][0]<rd[2][0] ||
            rd[0][1]>rd[1][1]&&rd[1][1]>rd[2][1] || rd[0][1]<rd[1][1]&&rd[1][1]<rd[2][1]
            ) return true; // subindo
            println(a.showDirections()+" "+b.showDirections()+" "+c.showDirections());
            // print(a.showDirections()+" "+b.showDirections()+" "+c.showDirections()+" > ");
            println(rd[0][0]+","+rd[0][1]+":"+rd[1][0]+","+rd[1][1]+":"+rd[2][0]+","+rd[2][1]);
            return false;
        }
        return false;
    }

    boolean equalRealDirections(Thing a,Thing b){
        int[] realD_a=getRealDirection(a);
        int[] realD_b=getRealDirection(b);
        if (realD_a[0]==realD_b[0]&&realD_a[1]==realD_b[1]) return true;
        return false;
    }
    boolean equalRealDirections(Thing a,int x,int y,int z){
        int[] realD_a=getRealDirection(a);
        int[] realD_b=getRealDirection(new int[]{x,y,z});
        if (realD_a[0]==realD_b[0]&&realD_a[1]==realD_b[1]) return true;
        return false;
    }

    int[] getRealDirection(int[] directions){
        int[] realD = {0,0};
        realD[0]+=directions[0];realD[1]+=directions[0];
        realD[0]+=-directions[1];realD[1]+=directions[1];
        realD[1]+=-2*directions[2];
        return realD;
    }
    int[] getRealDirection(Thing a){
        int[] directions = a.getDirections();
        int[] realD = {0,0};
        realD[0]+=directions[0];realD[1]+=directions[0];
        realD[0]+=-directions[1];realD[1]+=directions[1];
        realD[1]+=-2*directions[2];
        return realD;
    }
}
