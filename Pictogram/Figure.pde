class Figure{
    String figure=null,id=null;
    float px=0,py=0,_width=0,_height=0,raw=0;
    int alpha = 255;
    color _color=0,stroke=0;
    boolean noStroke = false;
    Figure(String id,String figure,float px,float py,float _width,float _height,color _color,int alpha, color stroke){ // rect_ts
        this.figure = figure;
        this.id = id;
        this.px = px;
        this.py = py;
        this._width = _width;
        this._height = _height;
        this._color = _color;
        this.alpha = alpha;
        this.stroke = stroke;
    }
    Figure(String id,String figure,float px,float py,float _width,float _height,color _color,int alpha){ // rect_fs
        this.noStroke = true;
        this.figure = figure;
        this.id = id;
        this.px = px;
        this.py = py;
        this._width = _width;
        this._height = _height;
        this._color = _color;
        this.alpha = alpha;
    }
    Figure(String id,String figure,float px,float py,float raw,color _color,int alpha,color stroke){ // 
        this.noStroke = false;
        this.figure = figure;
        this.id = id;
        this.px = px;
        this.py = py;
        this.raw= raw;
        this._color = _color;
        this.alpha = alpha;
        this.stroke = stroke;
    }

    void draw(){
        switch (figure){
            case "rect":
                if (noStroke) noStroke();
                else stroke(stroke,alpha);
                fill(_color,alpha);
                rect((px-dragX)/zoom,(py-dragY)/zoom,_width,_height);
                break;
            case "circle":
                if (noStroke) noStroke();
                else stroke(stroke,alpha);
                fill(_color,alpha);
                circle(px,py,raw*2);
                break;
            default:
                println("ERROR : Figure not defined > '"+figure+"'");
        }
    }
}