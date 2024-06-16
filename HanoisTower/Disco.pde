public class Disco{
  int comprimento;
  int largura;
  int bastao = 1;

  Disco(int comprimento,int largura){
    this.comprimento = comprimento;
    this.largura = largura;
  }

  void desenha(int i,boolean estaNoBuffer){
    if (!(estaNoBuffer)){
      float dist = width/4;
      fill(#FF0000);
      rect(dist*this.bastao-this.comprimento/2,height-30-this.largura*i,this.comprimento,this.largura);
    }else{
      float dist = width/4;
      fill(#FF0000);
      rect(dist*this.bastao-this.comprimento/2,height/3-10-this.largura,this.comprimento,this.largura);
    }
  }
  void desenha(int i){
    float dist = width/4;
    fill(#FF0000);
    rect(dist*this.bastao-this.comprimento/2,height-30-this.largura*i,this.comprimento,this.largura);

  }
}
