class Person extends Object{
    float altura = 20;
    float largura = 5;
    float initWater = 20,
    initFood = 9;
    float water = initWater,
    maxWater =    6,
    consumWater = 0.75f,
    food =        initFood,
    maxFood =     3,
    consumFood =  0.25f;
    float life = 3;
    boolean died = false;
    // thnking
    float[] coes = {-12.0f, 2.0f, 9.0f, -23.0f}; // tested
    int qt_coes = 4,
    vari_coes = 1;
    Person(String tipo){
        switch (tipo){
            case "aleatr":
                px = (int) random(width);
                py = (int) random(height-profTerreno);
                break;
        }
    }
    Person(Person base,int pos){
        //engineAleatr
        int posCoe = (int) random(qt_coes);
        float vari = (((int) random(2))*2-1)*vari_coes;
        this.coes = base.coes;
        this.coes[posCoe] += vari;
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

        goWater += water*consumWater*coes[0]+food*consumFood*coes[1];
        goFood += water*consumWater*coes[2]+food*consumFood*coes[3];
        if (goWater > goFood){
            this.px += (this.px > nexterWater.px) ? -1 : 1;
            qt_water++;
        }else if (goFood > goWater){
            this.px += (this.px > nexterFood.px) ? -1 : 1;
            qt_food++;
        }
    }

    void move(){
        think();
        int dir = ((int) random(2))*2-1;
        this.px += dir*1;
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
