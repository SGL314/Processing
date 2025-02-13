class Writer{
    void Writer(){}

    void write(UI ui){
        configurations(ui);
    }

    void configurations(UI ui){
        texter(ui.mode,#000000,width,height,15,"width-reversed-default");
        // texter()
    }

    void texter(String text,color _color,float px, float py,float size,String mode){
        fill(_color);
        textSize(size);
        switch (mode) {
            case "default":
                text(text,px,py);
                break;
            case "width-reversed-default":
                text(text,px-textWidth(text),py);
                break;
            default:
                try{
                    int error = 1/0;
                }catch (Exception e){
                    println("ERROR: texter > undefined mode: '"+mode+"'");
                }
        }
    }
    
}
// lembra senhor e faz mais uma vez
