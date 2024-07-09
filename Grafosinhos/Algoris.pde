class Algoris{
    int time = 0;
    void distances(){
        println("BEGIN");
        int initDist = 10000;
        for (Node node : Nodes){
            node.id = ""+initDist;
        }
        if (nodePassing != null){
            Node after = nodePassing;
            nodePassing = null;
            nodeSelected = vis(after,null,0,new ArrayList<Node>());
            after.minorisWay = new ArrayList<Node>();
        }
        println("END");
    }

    Node vis(Node node,Node after,float somaB,ArrayList<Node> way){
        if (breakThread) return null;
        if (node != null){
            nodeSelected = node;
            way.add(nodeSelected);
            // print(nodeSelected.id+" ");
            if (nodeSelected.connected.size() >= 1){
                int tam = nodeSelected.connected.size(),i=0;
                float soma=0;
                while (true){
                    if (i == tam) break;
                    // para-loops
                    boolean continueIt = false;
                    for (Node nodeWay : way){
                        if (nodeWay == nodeSelected.connected.get(i)){
                            i++;
                            continueIt = true;
                            break;
                        } 
                    }
                    if (continueIt) continue;
                    //
                    soma = somaB+distLin(nodeSelected,nodeSelected.connected.get(i));
                    delay(time);
                    if (Float.parseFloat(nodeSelected.connected.get(i).id) > soma){
                        nodeSelected.connected.get(i).id = ""+soma;
                        nodeSelected.connected.get(i).minorisWay = new ArrayList<Node>();
                        for (Node nodeWay : way) nodeSelected.connected.get(i).minorisWay.add(nodeWay);
                    }
                    ArrayList<Node> put = new ArrayList<Node>();
                    for (Node nodePut : way) put.add(nodePut);
                    
                    nodeSelected = vis(nodeSelected.connected.get(i),nodeSelected,soma,put);
                    i++;
                    
                }
            }
            delay(time);
            return after;
        }
        return after;
    }

    void preOrdem(){
        nodeSelected = Nodes.get(0);
        delay(500);
        nodeSelected = visPreOrdem(Nodes.get(0),null);
        delay(500);
        nodeSelected = null;
        println("");
    }
    Node visPreOrdem(Node node,Node after){
        if (node != null){
            nodeSelected = node;
            print(nodeSelected.id+" ");
            if (nodeSelected.connected.size() >= 2){
                delay(500);
                nodeSelected = visPreOrdem(nodeSelected.connected.get(1),nodeSelected);
                delay(500);
                nodeSelected = visPreOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() >= 1){
                delay(500);
                nodeSelected = visPreOrdem(nodeSelected.connected.get(0),nodeSelected);
            }
            delay(500);
            return after;
        }
        return after;
    }

    void emOrdem(){
        nodeSelected = Nodes.get(0);
        delay(500);
        nodeSelected = visEmOrdem(Nodes.get(0),null);
        delay(500);
        nodeSelected = null;
        println("");
    }
    Node visEmOrdem(Node node,Node after){
        if (node != null){
            nodeSelected = node;
            if (nodeSelected.connected.size() >= 2){
                delay(500);
                nodeSelected = visEmOrdem(nodeSelected.connected.get(1),nodeSelected);
                print(nodeSelected.id+" ");
                delay(500);
                nodeSelected = visEmOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() >= 1){
                delay(500);
                nodeSelected = visEmOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() == 0){
                print(nodeSelected.id+" ");
            }
            delay(500);
            return after;
        }
        return after;
    }

    void posOrdem(){
        nodeSelected = Nodes.get(0);
        delay(500);
        nodeSelected = visPosOrdem(Nodes.get(0),null);
        delay(500);
        nodeSelected = null;
        println("");
    }
    Node visPosOrdem(Node node,Node after){
        if (node != null){
            nodeSelected = node;
            if (nodeSelected.connected.size() >= 2){
                delay(500);
                nodeSelected = visPosOrdem(nodeSelected.connected.get(1),nodeSelected);
                delay(500);
                nodeSelected = visPosOrdem(nodeSelected.connected.get(0),nodeSelected);
                print(nodeSelected.id+" ");
            }else if (nodeSelected.connected.size() >= 1){
                delay(500);
                nodeSelected = visPosOrdem(nodeSelected.connected.get(0),nodeSelected);
            }else if (nodeSelected.connected.size() == 0){
                print(nodeSelected.id+" ");
            }
            delay(500);
            return after;
        }
        return after;
    }

    
    void excluir(){
        ArrayList<Node> nova = new ArrayList<Node>();
        String[] ids = {"15","14","5","4","9","8","7","6"};
        for (Node node : Nodes){
            boolean add = true;
            for (String str : ids){
                if (node.id.equals(str)){
                    nodeSelected = node;
                    ArrayList<Node> newNodes = new ArrayList<Node>();
                    for (Node node2 : Nodes){
                        if (node2.connected != null){
                            ArrayList<Node> nova2 = new ArrayList<Node>();
                            for (Node nodeFil : node2.connected){
                                if (nodeFil != nodeSelected){
                                    nova2.add(nodeFil);
                                }
                            }
                            node2.connected = nova2;
                        }
                        if (node2 != nodeSelected) newNodes.add(node2);
                    }
                    Nodes = newNodes;
                    add = false;
                }
                nodeSelected = null;
            }
            if (add) nova.add(node);
        }
        Nodes = nova;
    }
    void rename(){
        String[] names = {"a","c","b","e","d","g","f"};
        int tam=0;
        for (String c : names) tam++;
        int i = 0;
        for (Node node : Nodes){
            node.id = names[i];
            i++;
            if (tam == i){
                break;
            }
        }
    }
}
