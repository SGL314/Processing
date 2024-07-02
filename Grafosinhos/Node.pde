public class Node{
    ArrayList<Node> connected = new ArrayList<Node>();
    public int x,y,raw,num;
    color cor;
    public Node (ArrayList<Node> connected,int x,int y,int raw,color cor){
        this.connected = connected;
        this.x = x;
        this.y = y;
        this.raw = raw;
        this.cor = cor;
    }
    public Node (Node node,int x,int y,int raw,color cor){
        // if (node != null) connected.add(node);
        this.x = x;
        this.y = y;
        this.raw = raw;
        this.cor = cor;
    }

    Draw drawNode(){
      if (this.connected != null){
        for (Node node : connected){
          if (node != null){
            fill(#00FF00);
            line(this.x,this.y,node.x,node.y);
          }
        }
      }

      return new Draw(this.cor,this.x,this.y,this.raw,"node");
    }

    Draw write(int num){
      this.num = num;
      fill(#000000);
      String texto = ""+num+"";
      // if (this.connected.size() >= 2){
      //   texto += " "+this.connected.get(0).num+" | "+this.connected.get(1).num;
      // }
      return new Draw(#000000,(int) (this.x-(textAscent()+textDescent())/2),(int) (this.y+textWidth(texto)/2),texto,"text");
    }
}
