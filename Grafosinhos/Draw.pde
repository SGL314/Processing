class Draw{
    color cor;
    int x,y,raw;
    String tipo,text;
    Draw(color cor,int x,int y,int raw,String tipo){
        this.cor = cor;
        this.x = x;
        this.y = y;
        this.raw = raw;
        this.tipo = tipo;
    }
    Draw(int cor,int x,int y,String text,String tipo){
        this.cor = cor;
        this.x = x;
        this.y = y;
        this.text = text;
        this.tipo = tipo;
    }

    void drawIt(){
        switch (this.tipo){
            case "node":
                fill(this.cor);
                circle(this.x,this.y,this.raw);
                break;
            case "text":
                fill(this.cor);
                // textSize(1.2f);
                text(this.text,this.x,this.y);
                break;
            default:
                println("ERRO: Tipo não identificado '"+this.tipo+"'");
        }
    }
}