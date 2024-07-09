class Pack{
    String name;
    ArrayList<PImage> images = new ArrayList<PImage>();
    ArrayList<String> images_names = new ArrayList<String>();
    ArrayList<int[]> images_proportions = new ArrayList<int[]>();
    ArrayList<int[]> images_positions = new ArrayList<int[]>();
    Pack(String name){
        this.name = name;
    }
    void add(String name, int propX, int propY, int posX, int posY){
        images.add(loadImage(name));
        images_names.add(name);
        int[] props = {propX, propY};
        images_proportions.add(props);
        int[] poss = {posX, posY};
        images_positions.add(poss);
    }
    PImage getImage(int pos){
        return images.get(pos);
    }
    String getName(int pos){
        return images_names.get(pos);
    }
    int[] getProportion(int pos){
        return images_proportions.get(pos);
    }
    int[] getPosition(int pos){
        return images_positions.get(pos);
    }
    int getPropX(int pos){
        return images_proportions.get(pos)[0];
    }
    int getPropY(int pos){
        return images_proportions.get(pos)[1];
    }
    int getPosX(int pos){
        return images_positions.get(pos)[0];
    }
    int getPosY(int pos){
        return images_positions.get(pos)[1];
    }
    int len(){
        return this.images.size();
    }
    void setPosX(int pos, int value){
        int[] newPoss = {value,this.images_positions.get(pos)[1]};
        this.images_positions.set(pos,newPoss);
    }
    void setPosY(int pos, int value){
        int[] newPoss = {this.images_positions.get(pos)[0], value};
        this.images_positions.set(pos,newPoss);
    }
    void passTo(int pos, int dir){
        ArrayList<PImage> Limages = new ArrayList<PImage>();
        ArrayList<String> Limages_names = new ArrayList<String>();
        ArrayList<int[]> Limages_proportions = new ArrayList<int[]>();
        ArrayList<int[]> Limages_positions = new ArrayList<int[]>();
        if (pos-dir<0 || pos-dir>=this.len()) return; 
        if (dir == -1){
            for (int i =0;i<this.len();i++){
                if (i<pos || i>pos){
                    Limages.add(this.getImage(i));
                    Limages_names.add(this.getName(i));
                    Limages_proportions.add(this.getProportion(i));
                    Limages_positions.add(this.getPosition(i));
                }else if (i == pos && i+1 < this.len()){
                    i++;
                    Limages.add(this.getImage(i));
                    Limages_names.add(this.getName(i));
                    Limages_proportions.add(this.getProportion(i));
                    Limages_positions.add(this.getPosition(i));
                    i--;
                    Limages.add(this.getImage(i));
                    Limages_names.add(this.getName(i));
                    Limages_proportions.add(this.getProportion(i));
                    Limages_positions.add(this.getPosition(i));
                    i+=2;
                }
            }
        }else if (dir == 1){
            for (int i =0;i<this.len();i++){
                if (i<pos-1 || i>pos-1){
                    Limages.add(this.getImage(i));
                    Limages_names.add(this.getName(i));
                    Limages_proportions.add(this.getProportion(i));
                    Limages_positions.add(this.getPosition(i));
                }else if (i == pos-1){
                    i++;
                    Limages.add(this.getImage(i));
                    Limages_names.add(this.getName(i));
                    Limages_proportions.add(this.getProportion(i));
                    Limages_positions.add(this.getPosition(i));
                    i--;
                    Limages.add(this.getImage(i));
                    Limages_names.add(this.getName(i));
                    Limages_proportions.add(this.getProportion(i));
                    Limages_positions.add(this.getPosition(i));
                    i+=2;
                }
            }
        }
        this.images = Limages;
        this.images_names = Limages_names;
        this.images_positions = Limages_positions;
        this.images_proportions = Limages_proportions;
    }
}
