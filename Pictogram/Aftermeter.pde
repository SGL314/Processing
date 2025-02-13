class Aftermeter{
    ArrayList<Figure> figures = new ArrayList<Figure>();
    Aftermeter(){

    }

    void draw(){
        ArrayList<Figure> afmt_toRemove = new ArrayList<Figure>();
        int qt = 0;
        for (Figure figure : figures){
            figure.draw();
            switch (figure.id){
                case "selection":
                    if (ui.firstIteraion_Dragged) afmt_toRemove.add(figure);
                    break;
                default:
                    afmt_toRemove.add(figure);
            }
            qt++;
        }
        for (Figure figure : afmt_toRemove){
            figures.remove(figure);
        }
        writer.texter(""+qt,#000000,width,50,15,"width-reversed-default");
        // figures = new ArrayList<Figure>();
    }

    void put(String id,String figure,float px,float py,float _width,float _height,color _color,int alpha, color stroke){
        for (Figure f_figure : figures){
            if (f_figure.id == id){
                figures.remove(f_figure);
                break;
            }
        }
        figures.add(new Figure(id,figure,px,py,_width,_height,_color,alpha,stroke));
    }
    void put(String id,String figure,float px,float py,float raw,color _color,int alpha, color stroke){
        for (Figure f_figure : figures){
            if (f_figure.id == id){
                figures.remove(f_figure);
                break;
            }
        }
        figures.add(new Figure(id,figure,px,py,raw,_color,alpha,stroke));
    }

    Figure find(String id){
        for (Figure figure : figures){
            if (figure.id == id) return figure;
        }
        return null;
    }


}