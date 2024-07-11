import java.io.Serializable;

class Node{
    
    ArrayList<Node> connected = new ArrayList<Node>(),minorisWay = new ArrayList<Node>();
    public int x,y,raw;
    public String id = "";
    private String identificator ;
    color cor;
    public Node (ArrayList<Node> connected,int x,int y,int raw,color cor){
        this.connected = connected;
        this.x = x;
        this.y = y;
        this.raw = raw;
        this.cor = cor;
        this.identificator = getIdentificator();
    }
    public Node (Node node,int x,int y,int raw,color cor){
        // if (node != null) connected.add(node);
        this.x = x;
        this.y = y;
        this.raw = raw;
        this.cor = cor;
        this.identificator = getIdentificator();
    }

    Draw drawNode(){
      if (this.connected != null){
        for (Node node : connected){
          if (node != null){
            stroke(#000000);
            line(this.x,this.y,node.x,node.y);
            distLine(node);
            float rawCon = pow(basicRaw,1)/basicRawSaved*10;
            // conexões
            stroke(0);
            fill(#000000);
            if (abs(this.x-node.x) > abs(this.y-node.y)){
              if (this.x < node.x) arc((this.x+node.x)/2,(this.y+node.y)/2,rawCon,rawCon,3*PI/2,3*PI/2+PI);
              else arc((this.x+node.x)/2,(this.y+node.y)/2,rawCon,rawCon,PI/2,3*PI/2);
            }else{
              if (this.y < node.y) arc((this.x+node.x)/2,(this.y+node.y)/2,rawCon,rawCon,0,PI);
              else arc((this.x+node.x)/2,(this.y+node.y)/2,rawCon,rawCon,PI,2*PI);
            }
          }
        }
      }
      return new Draw(this.cor,this.x,this.y,this.raw,"node");
    }

    String getIdentificator(){
      String identificatorHere = aleatr();
      while (true){
        boolean pass = true;
        for (Node node : Nodes){
          if (node.identificator == identificatorHere){
            identificatorHere = aleatr();
            pass = false;
            break;
          }
        }
        if (pass) break;
      }
      return identificatorHere;
    }
    String aleatr(){
      return ""+(((int) random(90))+10)+"_"+(((int) random(90))+10)+"_"+(((int) random(90))+10);
    }

    float distLin(Node a,Node b){
      return pow(pow(a.x-b.x,2)+pow(a.y-b.y,2),0.5f);
    }

    void distLine(Node node){
      fill(#888888);
      // fill(#FF0000);
      String texto = ""+((float) round(distLin(this,node)*10))/10;
      textSize(2);
      text(texto,(this.x+node.x)/2-textWidth(texto)/2,(this.y+node.y)/2-(textAscent()+textDescent()));
      // circle((this.x+node.x)/2-textWidth(texto)/2,(this.y+node.y)/2-(textAscent()+textDescent()),2);
    }

    Draw write(String id){
      if (!(id.equals(" "))) this.id = id;
      int corTexto = #888888;
      String texto = ""+this.id+"";
      return new Draw(corTexto,(int) (this.x-textWidth(texto)/2),(int) (this.y+this.raw),texto,"text");
    }

    @Override
    public String toString(){
      String t_connected = "";
      int i = 0,tam;
      if (connected != null){
        tam = connected.size();
        for (Node node : connected){
          t_connected += node.identificator;
          i++;
          if (i != tam){
            t_connected += " ";
          }
        }
      }
      String t_minorisWay = "";
      i = 0;
      if (minorisWay != null){
        tam = minorisWay.size();
        for (Node node : minorisWay){
          t_minorisWay += node.identificator;
          i++;
          if (i != tam){
            t_minorisWay += " ";
          }
        }
      }
      return "Node{identificator='"+identificator+"', x='"+x+"', y='"+y+"', raw='"+raw+"', id='"+id+"', cor='"+cor+"', connected='"+t_connected+"', minorisWay='"+t_minorisWay+"'}";
    }
}
