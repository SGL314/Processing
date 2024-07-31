class Person extends Object{
    float altura = 20;
    float largura = 5;
    float water = 0;
    float maxWater = 3;
    float consumWater = 1;
    float life = 3;
    boolean died = false;
    // thnking
    float[] coes = {1f,0,1f,0,1f,0};
    int qt_coes = 6;
    Person(String tipo){
        switch (tipo){
            case "aleatr":
                px = (int) random(width);
                py = (int) random(height-profTerreno);
                break;
        }
    }
    Person(Person base){
        int pos = (int) random(qt_coes);
        float vari = (((int) random(2))*2-1)*0.5f;
        this.coes = base.coes;
        this.coes[pos] += vari;

    }

    void live(){
        if (this.water>=this.consumWater){
            this.water -= this.consumWater;
        }else{
            this.life -= 1;
        }
    }

    void think(){
        float D_nexter=0,go=0,unbind=0;
        Poco nexter = null;

        for (Poco poco : Pocos){
            if (nexter == null){
                nexter = poco;
            }else if (abs(nexter.px-this.px) > abs(poco.px-this.px)){
                nexter = poco;
            }
        }
        if (nexter != null) D_nexter = abs(nexter.px-this.px);

        go += D_nexter*coes[1]+water*coes[3]+consumWater*coes[5];
        unbind += D_nexter*coes[0]+water*coes[2]+consumWater*coes[4];
        if (go > unbind){
            this.px += (this.px > nexter.px) ? -1 : 1;
        }
    }

    void move(){
        think();
        int dir = ((int) random(2))*2-1;
        this.px += dir;
    }

    void show(){
        String texto = this.water+" wa.";
        int espaco = 10;
        int cor = #A56B3C;
        fill(#0000FF);
        text(texto,this.px,this.py-this.altura-espaco);

        texto = this.life+" li.";
        espaco = 10;
        fill(#FF0000);
        text(texto,this.px,this.py+espaco);


        fill(cor);
        rect(this.px-this.largura/2,this.py-this.altura,this.largura,this.altura);
    }
    /*
    >D_nexter   | unbind<
    >water      | 
    >consumWater| go<
    */
}