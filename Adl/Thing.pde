class Thing{
    float px=width/2,py=height/2,raw=0,alpha=255,wid = 10,hei = 10;
    String type,cor;

    boolean selected = false;

    Thing(String type,float px,float py,float raw,String cor,float alpha){ // pilastra, extintor
        this.type = type;
        this.px = px;
        this.py = py;
        this.raw = raw;
        this.cor = cor;
        this.alpha = alpha;
    }
    Thing(String type,float px,float py,float wid,float hei,String cor,float alpha){ // caixa de som, cadeira
        this.type = type;
        this.px = px;
        this.py = py;
        this.wid = wid;
        this.hei = hei;
        this.cor = cor;
        this.alpha = alpha;
    }

    public void draw(){
        switch (type){
            case "pilastra":
                noStroke();
                fill(cor,alpha);
                circle(px,py,raw*2);
                break;
            case "extintor":
                noStroke();
                fill(cor,alpha);
                circle(px,py,raw*2);
                break;
            case "caixa de som":
                noStroke();
                fill(cor,alpha);
                rect(px,py,wid,hei);
                break;
            case "cadeira":
                noStroke();
                fill(cor,alpha);
                rect(px,py,wid,hei);
                break;
        }
        //selecting
        if (selected){
            fill("#ffffff",255);
            switch (type){
                case "pilastra":
                    noStroke();
                    circle(px,py,raw/2);
                    break;
                case "extintor":
                    noStroke();
                    circle(px,py,raw/2);
                    break;
                case "caixa de som":
                    noStroke();
                    circle(px,py,(wid+hei)/2/2);
                    break;
                case "cadeira":
                    noStroke();
                    circle(px,py,(wid+hei)/2/2);
                    break;
            }
        }


    }
}