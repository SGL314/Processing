class Person extends Object{
    float altura = 20;
    float largura = 5;
    float water = 6,
    maxWater =    6,
    consumWater = 1,
    food =        3,
    maxFood =     3,
    consumFood =  0.25f;
    float life = 3;
    boolean died = false;
    // thnking
    float[] coes = {0,0,0,0,0,0,0,0,0,0,0,0};
    int qt_coes = 12;
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
        float vari = (((int) random(2))*2-1)*2f;
        this.coes = base.coes;
        this.coes[pos] += vari;

    }

    void live(){
        if (this.water>=this.consumWater && this.food>=this.consumFood){
            this.water -= this.consumWater;
            this.food -= this.consumFood;
        }else{
            this.life -= 1;
        }
    }

    void think(){
        float D_nexterWater=0,D_nexterFood=0,goWater=0,goFood=0;
        Poco nexterWater = null;
        Fazenda nexterFood = null;

        for (Poco poco : Pocos){
            if (nexterWater == null){
                nexterWater = poco;
            }else if (abs(nexterWater.px-this.px) > abs(poco.px-this.px)){
                nexterWater = poco;
            }
        }
        for (Fazenda fazenda : Fazendas){
            if (nexterFood == null){
                nexterFood = fazenda;
            }else if (abs(nexterFood.px-this.px) > abs(fazenda.px-this.px)){
                nexterFood = fazenda;
            }
        }
        if (nexterWater != null) D_nexterWater = abs(nexterWater.px-this.px);
        if (nexterFood != null) D_nexterFood = abs(nexterFood.px-this.px);

        goWater += D_nexterWater*coes[0]+water*coes[1]+consumWater*coes[2]+D_nexterFood*coes[3]+food*coes[4]+consumFood*coes[5];
        goFood += D_nexterWater*coes[6]+water*coes[7]+consumWater*coes[8]+D_nexterFood*coes[9]+food*coes[10]+consumFood*coes[11];
        if (goWater > goFood){
            this.px += (this.px > nexterWater.px) ? -1 : 1;
        }else{
            this.px += (this.px > nexterFood.px) ? -1 : 1;
        }
    }

    void move(){
        think();
        int dir = ((int) random(2))*2-1;
        this.px += dir;
    }

    void show(){
        int casasDecimais = 3;
        String texto = round(this.water*pow(10,3))/pow(10,3)+" wa.";
        int espaco = 10;
        int cor = #A56B3C;
        fill(#0000FF);
        text(texto,this.px,this.py-this.altura-espaco);

        texto = this.life+" li.";
        espaco = 10;
        fill(#FF0000);
        text(texto,this.px,this.py+espaco);

        texto = round(this.food*pow(10,3))/pow(10,3)+" fo.";
        espaco = 10;
        fill(#E0D783);
        text(texto,this.px,this.py-this.altura-espaco*2);


        fill(cor);
        rect(this.px-this.largura/2,this.py-this.altura,this.largura,this.altura);
    }
    /*
    >D_nexterWater| goFood<
    >water        | 
    >consumWater  | 
    >D_nexterFood | 
    >food         | 
    >consumFood   | goWater<
    */
}
