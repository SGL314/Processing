public class Node{
    Node father;
    int x,y,raw;
    color cor;
    public Node (Node father,int x,int y,int raw,color cor){
        this.father = father;
        this.x = x;
        this.y = y;
        this.raw = raw;
        this.cor = cor;
    }

    void drawNode(){
      fill(this.cor);
      circle(this.x,this.y,this.raw);
      
      if (this.father != null){
        fill(#00FF00);
        line(this.x,this.y,this.father.x,this.father.y);
      }
    }
}
