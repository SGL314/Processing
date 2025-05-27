class Miriam{
    int longitude = 30;
    float tamQuadrado,
    espessuraPulpito,
    longPulpito,blocos = 60.0,
    tamCadeira,espacoAteMeridianoCentral = 1.5,
    espacoEntreFileiras,espacoEntreFileirasLaterais, // alterado em setup
    espacoEntreCadeiras=3,
    distBlocosLaterais = 3.5,
    aberturaCorredor = 3.5,
    fileiraDireita_inline_Pilastra = 5;
    /*
    Centrais:
    6 : 8b
    7 : 9.5b
    8 : 11b
    9 : 12.5b
    Abertura corredor:
    3.5b
    Cadeiras : 52 cm
    Diferença laterias pulpito, ponta primeira dileira lateral : 2b
    Diferença entre fileiras laterais : 0.5 1.5 0.333 0.8 1.5
    */

    float[] distBlocosCentrais = {10.0,10.0},
    layoutBlocosCentrais = {6,6,7,8,8,9,9,10},
    layoutBlocoLateralDireito =  {6,8,9,7,8,8,8,6},
    layoutBlocoLateralEsquerdo = {6,8,9,8,8,8,8,6},
    diferencaFileiraLateralDireitaP =  {0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0},
    diferencaFileiraLateralEsquerdaP = {0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0}; // pimeiro sempre '0';  inicial: 0,0.5,1.5,0.33333333333,0.8,1.5

    // Apresentation
    float addingDownLat = 3; // ajustado em init
    float addingDownCen = 1; // ajustado em init

    // Cores
    int corCadeirasBLs = #CB8221,
    alphaCorCadeirasBLs = 256;

    int qtCadeiras = 0;
    int loop = 0;

    void init(){
        tamQuadrado = width/blocos;
        espessuraPulpito = 2 * tamQuadrado;
        longPulpito = longitude*tamQuadrado;
        tamCadeira = 21.6666666666;
        espacoEntreFileiras = 3*tamQuadrado-tamCadeira;
        espacoEntreFileirasLaterais=espacoEntreFileiras; // -2*tamCadeira + 3*sqrt(2)*tamCadeira + tamCadeira;
        // 1px = 2.4cm
        // 1cm = 0.4166666px
        float a = tamCadeira, c = espacoEntreCadeiras, e = 3*tamQuadrado;
        float l = -2*e, k = (2*pow((c+a),2)-pow(e,2));
        espacoEntreFileirasLaterais = c +  pow(2,.5) * (-l-pow((pow(l,2)+4*k),.5))/2;

        addingDownCen = addingDownCen*3*tamQuadrado + tamQuadrado*1;
        addingDownLat = addingDownLat*3*tamQuadrado;
    }

    void draw(){
        // if (loop%1000==0){
        //     float[] def = {4.0,4.0};
        //     distBlocosCentrais[1] = def[1];
        //     distBlocosCentrais[0] = def[0];
        // }
        // else if (loop%750==0){
        //     float[] def = {5.0,5.0};
        //     distBlocosCentrais[1] = def[1];
        //     distBlocosCentrais[0] = def[0];
        // }
        // else if (loop%500==0){
        //     float[] def = {6.0,6.0};
        //     distBlocosCentrais[1] = def[1];
        //     distBlocosCentrais[0] = def[0];
        // }
        // else if (loop%250==0){
        //     float[] def = {7.0,7.0};
        //     distBlocosCentrais[1] = def[1];
        //     distBlocosCentrais[0] = def[0];
        // }
        int padding = 100;

        translate(0,padding);

        loop+=1;
        background(#ffffff);
        qtCadeiras = 0;
        grid(#ffffff);
        linhasImaginarias();
        linhasAuxiliares();
        pulpito();
        blocosCentrais();
        blocosLaterais();
        pilastras();
        dados();

        translate(0,-padding);

        title();
        position();
    }

    void title(){
        String nome = "Miriã";
        String data = "15/05\n 2025";

        // Nome
        fill(#000000);
        textSize(75);
        text(nome,width/2-textWidth(nome)/2,75);

        // Data
        fill(#000000,192);
        textSize(25);
        text(data,width-textWidth(data)-25,50);
    }

    void grid(int cor){
        stroke(1);
        for (int i = 0;i<blocos;i++){
            for (int j = 0;j<blocos;j++){
                fill(cor);
                rect(j*tamQuadrado,i*tamQuadrado,tamQuadrado,tamQuadrado);
            }
        }
    }

    void linhasImaginarias(){
        float px,py,size;
        String texto;
        strokeWeight(tamQuadrado/3);
        strokeWeight(4);

        // meridiano
        stroke(#ff0000);
        line(width/2,espessuraPulpito,width/2,height);
        fill(#ffffff);
        size = 20;
        texto = "Meio do Nobre";
        px = 510;
        py = 605+addingDownCen - 3*tamQuadrado;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#ff0000);
        text(texto,px,py);

        // pulpital
        stroke(#E8671C);
        line(width/2-longPulpito/2,espessuraPulpito+2*tamQuadrado,width/2+longPulpito/2,espessuraPulpito+2*tamQuadrado);
        fill(#ffffff);
        size = 20;
        texto = longitude+" blocos";
        px = 610;
        py = 90;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#E8671C);
        text(texto,px,py);

        // barreiraPulpital
        stroke(#AC21CB);
        fill(#ffffff);
        size = 20;
        texto = "Lateral Direita";
        px = 760;
        py = 605+addingDownCen - 3*tamQuadrado;
        noStroke();
        rect(px,py-size+3,textWidth(texto),size);
        fill(#AC21CB);
        textSize(size);
        text(texto,px,py);
        stroke(#AC21CB);
        line(width/2-longPulpito/2,espessuraPulpito,width/2-longPulpito/2,height);
        fill(#ffffff);
        size = 20;
        texto = "Lateral Esquerda";
        px = 260;
        py = 605+addingDownCen - 3*tamQuadrado;
        noStroke();
        rect(px,py-size+3,textWidth(texto),size);
        fill(#AC21CB);
        textSize(size);
        text(texto,px,py);
        stroke(#AC21CB);
        line(width/2+longPulpito/2,espessuraPulpito,width/2+longPulpito/2,height);

        // maxima pulpital
        stroke(#C4B102);
        line(width/2+tamQuadrado*2,espessuraPulpito,width/2+tamQuadrado*2,espessuraPulpito+distBlocosCentrais[0]*tamQuadrado);
        fill(#ffffff);
        size = 20;
        texto = ((int)distBlocosCentrais[0])+" blocos";
        px = 545;
        py = 125;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#C4B102);
        text(texto,px,py);

        // bloco Meridional
        stroke(#2E60E5);
        line(width/2-tamQuadrado*espacoAteMeridianoCentral,espessuraPulpito+(distBlocosCentrais[0])*tamQuadrado,width/2,espessuraPulpito+(distBlocosCentrais[0])*tamQuadrado);
        fill(#ffffff);
        size = 20;
        texto = espacoAteMeridianoCentral+" blocos";
        px = 430;
        py = 125-6*tamQuadrado + distBlocosCentrais[0]*tamQuadrado;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#2E60E5);
        text(texto,px,py);
        strokeWeight(1);


    }

    void linhasAuxiliares(){
        float centroX,centroY,
        eInitChairs,dInitChairs,
        diferencaAtual,
        posX1,posX2,posY;
        int corLinhaInterBlocos = #ff0000;
        strokeWeight(2);

        // definição de pivots
        centroX = width/2;
        centroY = espessuraPulpito+distBlocosCentrais[0]*tamQuadrado;
        eInitChairs = centroX-espacoAteMeridianoCentral*tamQuadrado;
        dInitChairs = centroX+espacoAteMeridianoCentral*tamQuadrado;

        // pivot montador
        // fill(#65C16F);
        // circle(centroX,centroY,10);

        // lateral esquerda
        diferencaAtual = 0;
        posY = centroY;
        for (int i = 0;i<layoutBlocoLateralEsquerdo.length;i++){
            float layoutA, layoutB;
            layoutA = layoutBlocoLateralEsquerdo[i];
            layoutB = layoutBlocosCentrais[i];

            posX1 = eInitChairs - layoutB*tamCadeira - (layoutB-1)*espacoEntreCadeiras;
            diferencaAtual += diferencaFileiraLateralEsquerdaP[i];
            posX2 = centroX - (longitude/2-1)*tamQuadrado + ( -(espacoEntreFileirasLaterais - espacoEntreCadeiras)/(pow(2,.5)) )*diferencaAtual; // posição fixa onde começa a ponta direita da primeira fileira do BLE
            
            stroke(corLinhaInterBlocos);
            // fill(corLinhaInterBlocos);
            line(posX1,posY,posX2,posY);

            posY += espacoEntreFileiras+tamCadeira;
        }

        // lateral direita
        diferencaAtual = 0;
        posY = centroY;
        for (int i = 0;i<layoutBlocoLateralDireito.length;i++){
            float layoutA, layoutB;
            layoutA = layoutBlocoLateralDireito[i];
            layoutB = layoutBlocosCentrais[i];

            posX1 = dInitChairs + layoutB*tamCadeira + (layoutB-1)*espacoEntreCadeiras;
            diferencaAtual += diferencaFileiraLateralEsquerdaP[i];
            posX2 = centroX + (longitude/2-1)*tamQuadrado + ( (espacoEntreFileirasLaterais - espacoEntreCadeiras)/(pow(2,.5)) )*diferencaAtual; // posição fixa onde começa a ponta direita da primeira fileira do BLE
            
            stroke(corLinhaInterBlocos);
            // fill(corLinhaInterBlocos);
            line(posX1,posY,posX2,posY);

            posY += espacoEntreFileiras+tamCadeira;
        }

        // pivot móvel
        // fill(#ff0000);
        // circle(eInitChairs,centroY,10);
        //
        strokeWeight(1);
    }

    void pulpito(){
        noStroke();
        fill(#98520B);
        rect(width/2-longPulpito/2,0,longPulpito,espessuraPulpito);
        triangle(width/2-longPulpito/2-espessuraPulpito,0,width/2-longPulpito/2,0,width/2-longPulpito/2,espessuraPulpito);
        triangle(width/2+longPulpito/2,0,width/2+longPulpito/2+espessuraPulpito,0,width/2+longPulpito/2,espessuraPulpito);
    }

    void blocosCentrais(){
        int linha = 1;
        for (float line : layoutBlocosCentrais){
            // calculo de variação
            float vari = -(distBlocosCentrais[0]-distBlocosCentrais[1])/(line-1);
            fill(#CB8221);
            // esquerda
            for (int i =0 ; i < line;i++){
                rect(width/2-espacoAteMeridianoCentral*tamQuadrado-(tamCadeira*(i+1))-(i*espacoEntreCadeiras),espessuraPulpito+(distBlocosCentrais[0]+vari*i)*tamQuadrado+(linha-1)*(tamCadeira+espacoEntreFileiras),tamCadeira,tamCadeira);
                qtCadeiras++;
            }
            // direita
            for (int i =0 ; i < line;i++){
                rect(width/2+espacoAteMeridianoCentral*tamQuadrado+(tamCadeira*(i))+(i*espacoEntreCadeiras),espessuraPulpito+(distBlocosCentrais[0]+vari*i)*tamQuadrado+(linha-1)*(tamCadeira+espacoEntreFileiras),tamCadeira,tamCadeira);
                qtCadeiras++;
            }
            linha++;
            // break;
        }
    }

    void blocosLaterais(){
        int linha = 0,variCadeiras=0,qtInitCadeiras =0;
        float ang = 45,difLateral=0; // descobrindo a reta da função : f(0) = distBlocosLaterais; f(meridiano que tange o bloco) = distsBlocosCentrais[1]; [negativo para horário]
        aberturaCorredor = ((longitude/2-1)*tamQuadrado-espacoAteMeridianoCentral*tamQuadrado-layoutBlocosCentrais[0]*tamCadeira-(layoutBlocosCentrais[0]-1)*espacoEntreCadeiras)/tamQuadrado;
        // println(aberturaCorredor);
        translate(width/2-espacoAteMeridianoCentral*tamQuadrado-layoutBlocosCentrais[0]*tamCadeira-(layoutBlocosCentrais[0]-1)*espacoEntreCadeiras-tamQuadrado*aberturaCorredor,espessuraPulpito+distBlocosCentrais[1]*tamQuadrado);
        rotate((float) ang*PI/180);
        fill(corCadeirasBLs,alphaCorCadeirasBLs);
        // fill(#ff0000,128);
        // esquerda
        for (float line : layoutBlocoLateralEsquerdo){
            if (qtInitCadeiras==0) qtInitCadeiras=(int) line;
            difLateral += diferencaFileiraLateralEsquerdaP[linha];
            for (int i = 0 ; i < line;i++){
                rect((-i)*(tamCadeira+espacoEntreCadeiras)-tamCadeira+difLateral*tamCadeira+linha*espacoEntreCadeiras,linha*(espacoEntreFileirasLaterais+tamCadeira),tamCadeira,tamCadeira);
                qtCadeiras++;
                // break;
            }
            linha++;
            variCadeiras++;
            // break;
        }
        // ajusta pra ficar reto
        rotate((float) (-ang*PI/180));
        translate(-2.0*(-espacoAteMeridianoCentral*tamQuadrado-layoutBlocosCentrais[0]*tamCadeira-(layoutBlocosCentrais[0]-1)*espacoEntreCadeiras-tamQuadrado*aberturaCorredor),0);
        rotate((float) (-ang*PI/180));
        // translate(tamQuadrado+espacoEntreCadeiras+,0);
        // reset
        linha = 0;variCadeiras=0;qtInitCadeiras=0;difLateral=0;
        // direita
        for (float line : layoutBlocoLateralDireito){
            if (qtInitCadeiras==0) qtInitCadeiras=(int) line;
            difLateral += diferencaFileiraLateralDireitaP[linha];
            for (int i = 0 ; i < line;i++){
                // marca uma especifica
                //if (i==0 && linha==3) fill(255,0,0);
                //
                rect((i)*(tamCadeira+espacoEntreCadeiras)-difLateral*tamCadeira-difLateral*espacoEntreCadeiras , linha*(espacoEntreFileirasLaterais+tamCadeira) ,tamCadeira,tamCadeira);
                qtCadeiras++;
                // break;
            }
            linha++;
            variCadeiras++;
            // break;
        }
        // volta pro normal
        rotate((float) (ang*PI/180));
        translate(-width/2+(-espacoAteMeridianoCentral*tamQuadrado-layoutBlocosCentrais[0]*tamCadeira-(layoutBlocosCentrais[0]-1)*espacoEntreCadeiras-tamQuadrado*aberturaCorredor),-(espessuraPulpito+distBlocosCentrais[1]*tamQuadrado));
        
    }

    void dados(){
        fill(#ffffff);
        textSize(20);
        String texto = qtCadeiras+" Cadeiras";
        text(texto,width/2-textWidth(texto)/2,espessuraPulpito-textAscent()/2);
        // Laterais
        // Esquerdo
        fill(#ffffff);
        float size = 20,qt=0;
        texto = "";
        int tam = 0;
        int i = 0;
        qt = 0;
        for (float item : layoutBlocoLateralDireito){
            tam++;
        }
        for (float item : layoutBlocoLateralEsquerdo){
            texto += int(item);
            if (i<tam-1){
                texto+=", ";
            }
            i++;
            qt += int(item);
        }
        texto += " ("+int(qt)+")";
        float px = 45;
        float py = 490+addingDownLat-tamCadeira-espacoEntreFileiras;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#00a000);
        text(texto,px,py);
        // Direito
        fill(#ffffff);
        size = 20;
        texto = "";
        i=0;
        qt=0;
        for (float item : layoutBlocoLateralDireito){
            texto += int(item);
            if (i<tam-1){
                texto+=", ";
            }
            i++;
            qt += int(item);
        }
        texto += " ("+int(qt)+")";
        px = width-45-textWidth(texto);
        py = 490+addingDownLat-tamCadeira-espacoEntreFileiras;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#00a000);
        text(texto,px,py);
        // Centrias
        // Esquerdo
        fill(#ffffff);
        size = 20;
        texto = "";
        tam = 0;
        i=0;
        qt=0;
        for (float item : layoutBlocosCentrais){
            tam++;
        }
        for (float item : layoutBlocosCentrais){
            texto += int(item);
            if (i<tam-1){
                texto+=", ";
            }
            i++;
            qt += int(item);
        }
        texto += " ("+int(qt)+")";
        px = 260;
        py = 575+addingDownCen-tamCadeira-espacoEntreFileiras;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#00a000);
        text(texto,px,py);
        // Direito
        fill(#ffffff);
        size = 20;
        texto = "";
        i=0;
        qt=0;
        for (float item : layoutBlocosCentrais){
            texto += int(item);
            if (i<tam-1){
                texto+=", ";
            }
            i++;
            qt += int(item);
        }
        texto += " ("+int(qt)+")";
        px = 510;
        py = 575+addingDownCen-tamCadeira-espacoEntreFileiras;
        noStroke();
        textSize(size);
        rect(px,py-size+3,textWidth(texto),size);
        fill(#00a000);
        text(texto,px,py);
        
        // Nome dos blocos
        String[] nomes = {"BLE","BCE","BCD","BLD"};
        float altCentro = 734+addingDownCen-3*tamQuadrado*3;
        float altLateral = altCentro;
        float[][] poss = {{50,altLateral},{266,altCentro},{516,altCentro},{766,altLateral}};

        for (i=0;i<nomes.length;i++){
            px = poss[i][0];
            py = poss[i][1];

            fill(#ffffff);
            size=30;
            noStroke();
            textSize(size);
            rect(px,py-size+3,textWidth(nomes[i]),size);
            fill(#000000);
            text(nomes[i],px,py);
        }

    }

    void pilastras(){
        pilastra(930,225);
    }

    void pilastra(float px,float py){
        fill(#000000);
        circle(px,py,tamCadeira);

        fill(#ffffff);
        float size = 20;
        String texto = "Pilastra";
        px = 933;
        py = 256;
        rect(px,py-size+3,textWidth(texto),size);
        fill(#000000);
        textSize(size);
        text(texto,px,py);
    }

    void position(){
        fill(#000000);
        textSize(20);
        String texto = mouseX+", "+mouseY;
        text(texto,mouseX,mouseY);
    }

}
