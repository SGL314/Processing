class Sla{
    public void saveIt(){
        String filename = "nodes.txt";
        Node node = Nodes.get(0);
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(filename));
            writer.write("vasco");
        } catch (IOException e) {
            e.printStackTrace();
        }
    
    }
}
