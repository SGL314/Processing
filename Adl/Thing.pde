class Thing{
    float px=width/2,py=height/2,raw=0,alpha=255,wid = 10,hei = 10;
    String type;
    int cor,angle;

    boolean selected = false;

    Thing(String type,float px,float py,float raw,int cor,int angle,float alpha){ // pilastra, extintor
        this.type = type;
        this.px = px;
        this.py = py;
        this.raw = raw;
        this.cor = cor;
        this.alpha = alpha;
        this.angle = angle;
    }
    Thing(String type,float px,float py,float wid,float hei,int angle,int cor,float alpha){ // caixa de som, cadeira
        this.type = type;
        this.px = px;
        this.py = py;
        this.wid = wid;
        this.hei = hei;
        this.cor = cor;
        this.alpha = alpha;
        this.angle = angle;
    }

    public void draw(){
        float vx = (float) Math.sin((float) angle*PI/180)*wid-wid/2;
        float vy = (float) Math.cos((float) angle*PI/180)*wid-wid/2;
        translate(px,py);
        rotate((float) angle*PI/180);
        translate(vx,vy);
        switch (type){
            case "pilastra":
                noStroke();
                fill(cor,alpha);
                circle(0,0,raw*2);
                break;
            case "extintor":
                noStroke();
                fill(cor,alpha);
                circle(0,0,raw*2);
                break;
            case "caixa de som":
                noStroke();
                fill(cor,alpha);
                rect(0,0,wid,hei);
                break;
            case "cadeira":
                noStroke();
                fill(cor,alpha);
                rect(0,0,wid,hei);
                break;
        }
        //selecting
        if (selected){
            fill(#ff0000,255);
            switch (type){
                case "pilastra":
                    noStroke();
                    circle(0,0,raw/2);
                    break;
                case "extintor":
                    noStroke();
                    circle(0,0,raw/2);
                    break;
                case "caixa de som":
                    noStroke();
                    rect(wid/4,wid/4,(wid+hei)/2/2,(wid+hei)/2/2);
                    break;
                case "cadeira":
                    noStroke();
                    rect(wid/4,wid/4,(wid+hei)/2/2,(wid+hei)/2/2);
                    break;
            }
        }
        translate(-vx,-vy);
        rotate((float) -angle*PI/180);
        translate(-px,-py);


    }
}
