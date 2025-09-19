class Thing{
    float px=width/2,py=height/2,raw=0,alpha=255,wid = 10,hei = 10;
    String type;
    int cor,angle;

    boolean selected = false;
    boolean overPosition = false;
    int[] coresAlternadas = {#ff0000,#ff00ff,#0000ff,#00ffff,#00ff00,#ffff00};

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
            case "cadeira":
                noStroke();
                fill(cor,alpha);
                // if (overPosition){
                //     int ind = (modeler.loop%(300)-modeler.loop%(300)%50)/50;
                    
                //     fill(coresAlternadas[ind],alpha);
                // }
                rect(0,0,wid,hei);
                break;
        }
        //selecting
        if (selected){
            fill(#ff0000,255);
            switch (type){
                case "cadeira":
                    noStroke();
                    rect(wid/4,wid/4,(wid+hei)/2/2,(wid+hei)/2/2);
                    break;
            }
        }

        // // mostra posição
        // String texto = px+" "+py;
        // fill(#000000);
        // textSize(10);
        // text(texto,0,0);

        translate(-vx,-vy);
        rotate((float) -angle*PI/180);
        translate(-px,-py);

        


    }

    public Thing copy(){
        return new Thing(type,px,py,wid,hei,angle,cor,alpha);
    }
}
