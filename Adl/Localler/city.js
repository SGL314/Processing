class City{
    constructor(nome, raw, px, py){
        this.nome = nome;
        this.raw = raw;
        this.px = px;
        this.py = py;
    }

    show(){
        fill("#ff0000");
        circle(this.px,this.py,raw);
    }


}