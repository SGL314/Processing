class Connection{
    String filename;

    Connection(String filename){
        this.filename = filename;
    }

    public void setIt(){
        String texto;
        PrintWriter writer = createWriter(this.filename);
        for (Node node : Nodes){
            texto = node.toString();
            writer.println(texto);
        }
        writer.flush();
        writer.close();

        println("Texto salvo com sucesso!");
    }
    public void getIt(){
        String[] lines = loadStrings(sketchPath(filename));
        ArrayList<String> ids = new ArrayList<String>();
        ArrayList<ArrayList<String>> cons = new ArrayList<ArrayList<String>>(), mins = new ArrayList<ArrayList<String>>();;
        for (String line : lines){
            boolean get = false;
            String cache = "";
            ArrayList<String> caches = new ArrayList<String>();
            for (char c : line.toCharArray()){
                if (c == '\''){
                    get = (get) ? false : true;
                    if (!(get)){
                        caches.add(cache);
                        cache = "";
                    }
                }
                if (get) {
                    if (c != '\'') cache += ""+c;
                }
                
            }
            int identificator = 0,
            x = 1,
            y = 2,
            raw = 3,
            id = 4,
            cor = 5,
            connected = 6,
            minorisWay = 7;
            // adicionando
            Node adding = new Node(new ArrayList<Node>(),Integer.parseInt(caches.get(x)),Integer.parseInt(caches.get(y)),Integer.parseInt(caches.get(raw)),Integer.parseInt(caches.get(cor)));
            adding.identificator = caches.get(identificator);
            Nodes.add(adding);
            // println(adding.toString());
            // arrays
            // println(caches.get(connected));
            ids.add(caches.get(identificator));
            ArrayList<String> connecteds = new ArrayList<String>();
            for (String put : caches.get(connected).split(" ")){
                connecteds.add(put);
            }
            cons.add(connecteds);

            ArrayList<String> minorisWays = new ArrayList<String>();
            for (String put : caches.get(minorisWay).split(" ")){
                minorisWays.add(put);
            }
            mins.add(minorisWays);
        }
        int i = 0;
        for (Node nodeA : Nodes){
            for (String id : cons.get(i)){
                for (Node nodeB : Nodes){
                    if (nodeB.identificator.equals(id)){
                        // println("C:> "+id);
                        nodeA.connected.add(nodeB);
                    }
                    
                }
            }
            for (String id : mins.get(i)){
                for (Node nodeB : Nodes){
                    if (nodeB.identificator.equals(id)){
                        nodeA.minorisWay.add(nodeB);
                        // println("M:> "+id);
                    }
                }
            }
            i++;
        }
    }
}
