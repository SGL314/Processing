public class Node{
    ArrayList<Node> connected = new ArrayList<Node>(),minorisWay;
    public int x,y,raw;
    public String id = "";
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
            distLine(node);
            // conexões
            if (abs(this.x-node.x) > abs(this.y-node.y)){
              fill(#000000);
              if (this.x < node.x) arc((this.x+node.x)/2,(this.y+node.y)/2,10,10,3*PI/2,3*PI/2+PI);
              else arc((this.x+node.x)/2,(this.y+node.y)/2,10,10,PI/2,3*PI/2);
            }else{
              fill(#000000);
              if (this.y < node.y) arc((this.x+node.x)/2,(this.y+node.y)/2,10,10,0,PI);
              else arc((this.x+node.x)/2,(this.y+node.y)/2,10,10,PI,2*PI);
            }
          }
        }
      }

      return new Draw(this.cor,this.x,this.y,this.raw,"node");
    }

    float distLin(Node a,Node b){
      return pow(pow(a.x-b.x,2)+pow(a.y-b.y,2),0.5f);
    }

    void distLine(Node node){
      fill(#000000);
      // fill(#FF0000);
      String texto = ""+((float) round(distLin(this,node)*10))/10;
      text(texto,(this.x+node.x)/2-textWidth(texto)/2,(this.y+node.y)/2-(textAscent()+textDescent()));
      // circle((this.x+node.x)/2-textWidth(texto)/2,(this.y+node.y)/2-(textAscent()+textDescent()),2);
    }

    Draw write(String id){
      if (!(id.equals(" "))) this.id = id;
      fill(#000000);
      String texto = ""+this.id+"";
      // if (this.connected.size() >= 2){
      //   texto += " "+this.connected.get(0).num+" | "+this.connected.get(1).num;
      // }
      return new Draw(#000000,(int) (this.x-(textAscent()+textDescent())/2),(int) (this.y+textWidth(texto)/2),texto,"text");
    }
}
