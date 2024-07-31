class Poco extends Object{
    float largura=10,altura=5;
    Poco(int px){
        this.px = px;
        this.py = height-profTerreno;
    }

    void show(){
        fill(#1553EA);
        rect(this.px-1,this.py-12,2,12);
        fill(#311A05);
        rect(this.px-largura/2,this.py-altura,largura,altura);
    }
}