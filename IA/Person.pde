class Person{
    float px,py;
    float altura = 20;
    float largura = 5;
    float water = 3;
    float maxWater = 3;
    float consumWater = 1;
    float life = 3;
    Person(String tipo){
        switch (tipo){
            case "aleatr":
                px = (int) random(width);
                py = (int) random(height-profTerreno);
                break;
        }
    }

    void live(){
        if (this.water>=this.consumWater){
            this.water -= this.consumWater;
        }else{
            this.life -= 1;
        }
    }

    void move(){
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
}