class Conectum extends Thing {
    color _color;

    Conectum(Thing grandFather,Thing father,int nx,int ny,int nz, color _color) {
        super();
        super.father = father;
        super.grandFather = grandFather;
        float posx=0,posy=0,l=grandFather.raw,r3=pow(3,.5);
        this.nx = nx;
        this.ny=ny;
        this.nz=nz;
        float h = l*r3/2.,m=l/2.;
        posx += h*nx; // x
        posy += m*nx; // x
        posx += -h*ny; // y
        posy += m*ny; // y
        posy += -2*m*nz; // z
        super.px = posx+grandFather.px;
        super.py = posy+grandFather.py;
        println(" -> ("+grandFather.px+","+grandFather.py+")"+super.px+","+super.py);
        this._color = _color;
        this.raw = 2;
        super.lived = true;
    }

    @Override
    void putName() {
        super.name = "Conectum";
    }

    @Override
    void draw() {
        connect();
        if (this.father == null){
            toRemove.add(this);
            super.lived = false;
        }
        if (super.lived) {
            fill(_color);
            stroke(_color);
        }else{
            fill(#000000);
            stroke(#000000);
        }
        circle(super.px, super.py, this.raw*2);
        showMarkation();
    }

    @Override
    void connect(){
        improveNetwork();
        stroke(#000000,16);
        line(super.px,super.py,father.px,father.py);
    }
}