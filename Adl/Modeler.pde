class Modeler{
    int longitude = 30,
    distLadoEsquerdoAltar = 8, distLadoDireitoAltar = 7,
    altura = 39, alturaAltar = 2, // em y: do altar e do altar até a faixa perto da mesa de som
    paddingY = 100, // distância no topo pra colocar o title
    paddingX = 5; // distancia da borda até o chão do Nobre

    float tamQuadrado,
    espessuraAltar,
    longitudeAltar,blocos = 60.0,
    tamCadeira,espacoAteMeridianoCentral = 1.5,
    espacoEntreFileiras,espacoEntreFileirasLaterais, // alterado em setup
    espacoEntreCadeiras=3,
    distBlocosLaterais = 3.5,
    aberturaCorredor = 3.5,
    fileiraDireita_inline_Pilastra = 5,
    espessuraFaixa,coeCmToPx,
    fileirasLateraisAcima = 2,
    distLateralDireita = 132+22+125, distLateralEsquerda = 269;

    float[] distBlocosCentrais = {10.0,10.0},
    layoutBlocosCentrais =       {8,8,8,8,8,8,8},
    layoutBlocoLateralDireito =  {6,7,8,8,8,8},
    layoutBlocoLateralEsquerdo = {6,7,8,8,8,8},
    diferencaFileiraLateralDireitaP =  {0,-1.0,-1.0,0,0,0,0,0,0},
    diferencaFileiraLateralEsquerdaP = {0,-1.0,-1.0,0,0,0,0,0,0}; // pimeiro sempre '0';  inicial: 0,0.5,1.5,0.33333333333,0.8,1.5
    
    // Apresentation
    float addingDownLat = 2.5; // ajustado em init
    float addingDownCen = 0.5; // ajustado em init

    // Cores
    int corCadeirasBLs = #CB8221,
    corAzulejoEscuro = #272200,
    corCaixaDeSom = #434343,
    corParedes = #CECECE,
    alphaAll = 192,
    alphaCorCadeirasBLs = alphaAll, alphaCorCadeirasBCs = alphaAll;

    int qtCadeiras = 0;
    int loop = 0;
    
    // Things
    List<Thing> things = new List<Thing>();

    // Keyboard
    HashMap<String, String> keyMap = new HashMap<String, String>();

    void init(){
        coeCmToPx = 0.4166666666666;
        tamQuadrado = 1000/blocos;
        espessuraAltar = alturaAltar * tamQuadrado;
        longitudeAltar = longitude * tamQuadrado;
        tamCadeira = 21.6666666666;
        espacoEntreFileiras = 3*tamQuadrado-tamCadeira;
        espacoEntreFileirasLaterais=4*tamQuadrado-tamCadeira; // -2*tamCadeira + 3*sqrt(2)*tamCadeira + tamCadeira;
        espessuraFaixa = 17*coeCmToPx; // 17cm 
        // 1px = 2.4cm
        // 1cm = 0.4166666px
        float a = tamCadeira, c = espacoEntreCadeiras, e = 3*tamQuadrado;
        float l = -2*e, k = (2*pow((c+a),2)-pow(e,2));

        addingDownCen = addingDownCen*3*tamQuadrado + tamQuadrado*1;
        addingDownLat = addingDownLat*3*tamQuadrado;

        defineKeyMap();
    }

    void draw(){

        translate(paddingX,paddingY);

        loop+=1;
        background(#ffffff);

        fill(corParedes);
        rect(-paddingX,0,width,height);

        fill(#ffffff);
        rect(width/2 - (distLateralEsquerda*coeCmToPx+(longitude/2+distLadoEsquerdoAltar)*tamQuadrado+espessuraFaixa)
        ,0,distLateralEsquerda*coeCmToPx+(longitude+distLadoDireitoAltar+distLadoEsquerdoAltar)*tamQuadrado+2*espessuraFaixa + distLateralDireita*coeCmToPx
        ,height);
        //

        //
        qtCadeiras = 0;
        ground();
        things();
        linhasImaginarias();
        linhasAuxiliares();
        blocosLaterais();
        blocosCentrais();
        altar();
        pilastras();
        dados();
        paredes();

        translate(-paddingX,-paddingY);

        title();
        position();
    }

    void title(){
        String nome = "Davi";
        String data = "02/06\n 2025";

        // Nomes
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
        float totalLongitude = distLadoDireitoAltar+distLadoEsquerdoAltar+longitude,
        totalAltura = alturaAltar+altura;
        for (int i = 0;i<totalLongitude;i++){
            for (int j = 0;j<totalAltura;j++){
                fill(cor);
                rect(width/2+(-longitude/2-distLadoEsquerdoAltar+i)*tamQuadrado , j*tamQuadrado , tamQuadrado,tamQuadrado);
                // fill(#000000);
                // textSize(10);
                // text(j+"",width/2-(longitude/2-distLadoEsquerdoAltar-i)*tamQuadrado , j*tamQuadrado+textAscent());
            }
        }
    }

    void things(){
        //
        extintores();
        caixasDeSom();       
    }
    void blackTiles(){
        // lado direito
        superBlackTile(width/2+(1+longitude/2)*tamQuadrado,espessuraAltar); // na entrada da escada direita
        strangeTiles(); // azulejos estranhos
        int initChainDireita = 4, distRaios = 3, pivot_distSubtraidaLateralDireita = 6;
        // chain direita
        int[] chain = {1,1,2,1,1,2,1,1,2,1,1};
        int line = 0;
        for (int type : chain){
            switch (type){
                case 1: // mini
                    miniBlackTile(
                        width/2+(longitude/2-pivot_distSubtraidaLateralDireita+distLadoDireitoAltar+1)*tamQuadrado
                        ,(initChainDireita+line+alturaAltar)*tamQuadrado
                    );
                    miniBlackTile(
                        width/2+(longitude/2-pivot_distSubtraidaLateralDireita+distLadoDireitoAltar-1)*tamQuadrado
                        ,(initChainDireita+line+alturaAltar)*tamQuadrado
                    );
                    break;
                case 2: // super
                    superBlackTile(
                        width/2+(longitude/2-pivot_distSubtraidaLateralDireita+distLadoDireitoAltar)*tamQuadrado
                        ,(initChainDireita+line+alturaAltar)*tamQuadrado
                    );
                    break;
            }
            line+=distRaios;
        }
        // chain esquerda
        int chain2[] = {0,0,2,1,1,2,1,1,2,1,1}, pivot_distSubtraidaLateralEsquerda = 5;
        line = 0;
        for (int type : chain2){
            switch (type){
                case 0: // nada
                    break;
                case 1: // mini
                    miniBlackTile(
                        width/2+(-longitude/2+pivot_distSubtraidaLateralEsquerda-distLadoEsquerdoAltar-1)*tamQuadrado
                        ,(initChainDireita+line+alturaAltar)*tamQuadrado
                    );
                    miniBlackTile(
                        width/2+(-longitude/2+pivot_distSubtraidaLateralEsquerda-distLadoEsquerdoAltar+1)*tamQuadrado
                        ,(initChainDireita+line+alturaAltar)*tamQuadrado
                    );
                    break;
                case 2: // super
                    superBlackTile(
                        width/2+(-longitude/2+pivot_distSubtraidaLateralEsquerda-distLadoEsquerdoAltar)*tamQuadrado
                        ,(initChainDireita+line+alturaAltar)*tamQuadrado
                    );
                    break;
            }
            line+=distRaios;
            
        }
    }
    void caixasDeSom(){
        //direito
        float ang = 18.43494882, // atan(1/3)
        ladoCaixaDeSom = pow(pow(tamQuadrado*1.5,2)+pow(tamQuadrado/2,2),.5),
        px,py
        ;

        px = 807;py= 107;
        translate(px,py-paddingY);
        fill(corCaixaDeSom);
        rotate((float) ang*PI/180);
        rect(0,0,ladoCaixaDeSom,ladoCaixaDeSom); // direita
        rotate((float) -ang*PI/180);
        translate(-px,-py+paddingY);

        px += ladoCaixaDeSom-3;py= 120;
        translate(px,py-paddingY);
        fill(corCaixaDeSom);
        rotate((float) ang*PI/180);
        rect(0,0,ladoCaixaDeSom,ladoCaixaDeSom); //extrema direita
        rotate((float) -ang*PI/180);
        translate(-px,-py+paddingY);

        //Esquerdo
        ang = -18.43494882;

        px = 167;py= 113;
        translate(px,py-paddingY);
        fill(corCaixaDeSom);
        rotate((float) ang*PI/180);
        rect(0,0,ladoCaixaDeSom,ladoCaixaDeSom); // direita
        rotate((float) -ang*PI/180);
        translate(-px,-py+paddingY);

        px -= ladoCaixaDeSom-3;py += 13;
        translate(px,py-paddingY);
        fill(corCaixaDeSom);
        rotate((float) ang*PI/180);
        rect(0,0,ladoCaixaDeSom,ladoCaixaDeSom); //extrema direita
        rotate((float) -ang*PI/180);
        translate(-px,-py+paddingY);



    }

    void ground(){
        // 
        grid(#ffffff);
        faixas();
        blackTiles();   
    }

    void faixas(){
        fill(corAzulejoEscuro);
        rect(width/2-(longitude/2+distLadoEsquerdoAltar)*tamQuadrado-espessuraFaixa,0,espessuraFaixa,(alturaAltar+altura)*tamQuadrado+espessuraFaixa); // lado esquerdo
        rect(width/2-(longitude/2+distLadoEsquerdoAltar)*tamQuadrado,(alturaAltar+altura)*tamQuadrado,(distLadoEsquerdoAltar+distLadoDireitoAltar+longitude)*tamQuadrado+espessuraFaixa,espessuraFaixa); // longitude
        rect(width/2+(longitude/2+distLadoDireitoAltar)*tamQuadrado,0,espessuraFaixa,(alturaAltar+altura)*tamQuadrado);
    }

    void paredes(){

        // esquerda
        //curvas
        fill(corParedes);
        arc(122-paddingX,-5*tamQuadrado,7*tamQuadrado*2,7*tamQuadrado*2,0,HALF_PI); // parede
        //retas
        rect(-3,0,125,2*tamQuadrado);
        //tampa
        fill(#ffffff);
        rect(122-paddingX,-5*tamQuadrado-2,7*tamQuadrado,5*tamQuadrado+2); // tampa a parte que fica em cima da área do titulo

        // direita
        //curvas
        fill(corParedes);
        arc(872-paddingX,-5*tamQuadrado,7*tamQuadrado*2,7*tamQuadrado*2,HALF_PI,PI); // parede
        //retas
        rect(872-paddingX,0,width-872-paddingX,2*tamQuadrado);
        //tampa
        fill(#ffffff);
        rect(872-paddingX,-5*tamQuadrado-2,-7*tamQuadrado,5*tamQuadrado+2); // tampa a parte que fica em cima da área do titulo


    }

    void superBlackTile(float x, float y){
        float ang = 45;
        translate(x,y);
        rotate((float) ang*PI/180);
        fill(corAzulejoEscuro);
        rect(-tamQuadrado*pow(2,.5)/2,-tamQuadrado*pow(2,.5)/2,tamQuadrado*pow(2,.5),tamQuadrado*pow(2,.5));
        rotate((float) -ang*PI/180);
        translate(-x,-y);
    }
    void miniBlackTile(float x, float y){
        float ang = 45;
        translate(x,y);
        rotate((float) ang*PI/180);
        fill(corAzulejoEscuro);
        rect(-tamQuadrado/4,-tamQuadrado/4,tamQuadrado/2,tamQuadrado/2);
        rotate((float) -ang*PI/180);
        translate(-x,-y);
    }

    void strangeTiles(){
        fill(corParedes);
        float coe = 1.2;
        rect(width/2+(1+longitude/2)*tamQuadrado,espessuraAltar-tamQuadrado*coe,tamQuadrado*coe,tamQuadrado*coe);
        rect(width/2-(coe+1+longitude/2)*tamQuadrado,espessuraAltar-tamQuadrado*coe,tamQuadrado*coe,tamQuadrado*coe);
    }
    void extintores(){
        fill(#FF3E3E);
        circle(797,18,tamQuadrado/1.5); //direito
        circle(201,7,tamQuadrado/1.5); //esquerdo
    }    

    void linhasImaginarias(){
        float px,py,size;
        String texto;
        strokeWeight(tamQuadrado/3);
        strokeWeight(2);

        // meridiano
        stroke(#ff0000);
        line(width/2,espessuraAltar,width/2,height);
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
        line(width/2-longitudeAltar/2,espessuraAltar+2*tamQuadrado,width/2+longitudeAltar/2,espessuraAltar+2*tamQuadrado);
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
        line(width/2-longitudeAltar/2,espessuraAltar,width/2-longitudeAltar/2,height);
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
        line(width/2+longitudeAltar/2,espessuraAltar,width/2+longitudeAltar/2,height);

        // maxima pulpital
        stroke(#C4B102);
        line(width/2+tamQuadrado*2,espessuraAltar,width/2+tamQuadrado*2,espessuraAltar+distBlocosCentrais[0]*tamQuadrado);
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
        line(width/2-tamQuadrado*espacoAteMeridianoCentral,espessuraAltar+(distBlocosCentrais[0])*tamQuadrado,width/2,espessuraAltar+(distBlocosCentrais[0])*tamQuadrado);
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
        posX1,posX2,posY,
        diferencaDesrregular; // diferença quando o layout de um lado, num item especifico, passa de 1.0
        int corLinhaInterBlocos = #ff0000;
        strokeWeight(2);

        // definição de pivots
        centroX = width/2;
        centroY = espessuraAltar+distBlocosCentrais[0]*tamQuadrado;
        eInitChairs = centroX-espacoAteMeridianoCentral*tamQuadrado;
        dInitChairs = centroX+espacoAteMeridianoCentral*tamQuadrado;
        float qtFileirasLaterais = -1;
        for (float linha : layoutBlocoLateralEsquerdo){
            qtFileirasLaterais ++;
        }

        // lateral esquerda
        float diagonal = layoutBlocoLateralEsquerdo[((int) qtFileirasLaterais)]*tamCadeira + (layoutBlocoLateralEsquerdo[(int)qtFileirasLaterais]-1)*espacoEntreCadeiras;
        float varX = diagonal*pow(2,.5)/2 + tamCadeira*pow(2,.5)/2;
        float varY = diagonal*pow(2,.5)/2 - tamCadeira*pow(2,.5)/2;
        stroke(#ff0000);
        line(
            centroX-(longitude/2+2)*tamQuadrado , espessuraAltar+distBlocosCentrais[0]*tamQuadrado-tamQuadrado,
            centroX-(longitude/2+2)*tamQuadrado , espessuraAltar+distBlocosCentrais[0]*tamQuadrado+qtFileirasLaterais*tamQuadrado*4+tamQuadrado
        );
        line(
            centroX-(longitude/2+2)*tamQuadrado -varX, espessuraAltar+distBlocosCentrais[0]*tamQuadrado-tamQuadrado-varY+(2)*tamQuadrado*4,
            centroX-(longitude/2+2)*tamQuadrado -varX, espessuraAltar+distBlocosCentrais[0]*tamQuadrado+(qtFileirasLaterais)*tamQuadrado*4+tamQuadrado-varY
        );

        // lateral direita
        line(
            centroX+(longitude/2+2)*tamQuadrado , espessuraAltar+distBlocosCentrais[0]*tamQuadrado-tamQuadrado,
            centroX+(longitude/2+2)*tamQuadrado , espessuraAltar+distBlocosCentrais[0]*tamQuadrado+qtFileirasLaterais*tamQuadrado*4+tamQuadrado
        );
        line(
            centroX+(longitude/2+2)*tamQuadrado +varX, espessuraAltar+distBlocosCentrais[0]*tamQuadrado-tamQuadrado-varY+(2)*tamQuadrado*4,
            centroX+(longitude/2+2)*tamQuadrado +varX, espessuraAltar+distBlocosCentrais[0]*tamQuadrado+(qtFileirasLaterais)*tamQuadrado*4+tamQuadrado-varY
        );

        // pivot móvel
        // fill(#ff0000);
        // circle(eInitChairs,centroY,10);
        //
        strokeWeight(1);
    }

    void altar(){
        noStroke();
        fill(#98520B);
        rect(width/2-longitudeAltar/2,0,longitudeAltar,espessuraAltar);
        triangle(width/2-longitudeAltar/2-espessuraAltar,0,width/2-longitudeAltar/2,0,width/2-longitudeAltar/2,espessuraAltar);
        triangle(width/2+longitudeAltar/2,0,width/2+longitudeAltar/2+espessuraAltar,0,width/2+longitudeAltar/2,espessuraAltar);
    }

    void blocosCentrais(){
        stroke(#000000);
        int linha = 1;
        for (float line : layoutBlocosCentrais){
            // calculo de variação
            float vari = -(distBlocosCentrais[0]-distBlocosCentrais[1])/(line-1);
            fill(#CB8221,alphaCorCadeirasBCs);
            // esquerda
            for (int i =0 ; i < line;i++){
                rect(width/2-espacoAteMeridianoCentral*tamQuadrado-(tamCadeira*(i+1))-(i*espacoEntreCadeiras),espessuraAltar+(distBlocosCentrais[0]+vari*i)*tamQuadrado+(linha-1)*(tamCadeira+espacoEntreFileiras),tamCadeira,tamCadeira);
                qtCadeiras++;
            }
            // direita
            for (int i =0 ; i < line;i++){
                rect(width/2+espacoAteMeridianoCentral*tamQuadrado+(tamCadeira*(i))+(i*espacoEntreCadeiras),espessuraAltar+(distBlocosCentrais[0]+vari*i)*tamQuadrado+(linha-1)*(tamCadeira+espacoEntreFileiras),tamCadeira,tamCadeira);
                qtCadeiras++;
            }
            linha++;
            // break;
        }
    }

    void blocosLaterais(){
        stroke(#000000);
        int linha = 0,variCadeiras=0,qtInitCadeiras =0;
        float ang = 45,difLateral=4*tamQuadrado*pow(2,.5)/2, // descobrindo a reta da função : f(0) = distBlocosLaterais; f(meridiano que tange o bloco) = distsBlocosCentrais[1]; [negativo para horário]
        correcaoLinearLateral = 2*(tamCadeira+espacoEntreCadeiras),
        varX_E = (paddingX+distLateralEsquerda+espessuraFaixa)*coeCmToPx+(distLadoEsquerdoAltar-2)*tamQuadrado-tamCadeira*pow(2,.5)/2,
        varX_D = varX_E+(2+longitude+2)*tamQuadrado + tamCadeira*pow(2,.5)/2,
        varY = espessuraAltar+distBlocosCentrais[1]*tamQuadrado-tamCadeira*pow(2,.5)/2;
        
        translate(varX_E,varY);
        rotate((float) ang*PI/180);
        fill(corCadeirasBLs,alphaCorCadeirasBLs);
        // fill(#ff0000,128);
        // esquerda
        for (float line : layoutBlocoLateralEsquerdo){
            if (qtInitCadeiras==0) qtInitCadeiras=(int) line;
            for (int i = 0 ; i < line;i++){
                rect(-i*(tamCadeira+espacoEntreCadeiras) + linha*difLateral,linha*(difLateral), tamCadeira,tamCadeira);
                qtCadeiras++;
                // break;
            }
            linha++;
            variCadeiras++;
            // break;
        }

        // ajusta pra ficar reto
        rotate((float) (-ang*PI/180));
        translate(-varX_E+varX_D,tamQuadrado);
        rotate((float) (-ang*PI/180));
        // translate(tamQuadrado+espacoEntreCadeiras+,0);
        // reset
        linha = 0;variCadeiras=0;qtInitCadeiras=0;

        // direita
        for (float line : layoutBlocoLateralDireito){
            if (qtInitCadeiras==0) qtInitCadeiras=(int) line;
            for (int i = 0 ; i < line;i++){
                // marca uma especifica
                //if (i==0 && linha==3) fill(255,0,0);
                //
                rect(i*(tamCadeira+espacoEntreCadeiras) - linha*difLateral,linha*(difLateral), tamCadeira,tamCadeira);
                qtCadeiras++;
                // break;
            }
            linha++;
            variCadeiras++;
            // break;
        }
        // volta pro normal
        rotate((float) (ang*PI/180));
        translate(-varX_D,-varY-tamQuadrado);
        
    }

    void dados(){
        fill(#ffffff);
        textSize(20);
        String texto = qtCadeiras+" Cadeiras";
        text(texto,width/2-textWidth(texto)/2,espessuraAltar-textAscent()/2);
        int pivotPx = 100;

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
            if (item == 0){
                continue;
            }
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
            if (item == 0){
                continue;
            }
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
            if (item == 0){
                continue;
            }
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
        float[][] poss = {{pivotPx,altLateral},{pivotPx+216,altCentro},{pivotPx+466,altCentro},{pivotPx+716,altLateral}};

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
        float fimFaixaDireita = width/2+(longitude/2+distLadoDireitoAltar)*tamQuadrado+espessuraFaixa,
        distParedeFrontal_1pilastra = (56+17)*coeCmToPx+7*pow(2,.5)*tamQuadrado,
        dist1pilastra_2pilastra = (8+12)*coeCmToPx+9*pow(2,.5)*tamQuadrado,
        dist2pilastra_3pilastra = (12+51.5)*coeCmToPx+8*pow(2,.5)*tamQuadrado,
        ladoPilastra = 32*coeCmToPx;

        pilastra(fimFaixaDireita+125*coeCmToPx,alturaAltar*tamQuadrado+distParedeFrontal_1pilastra);
        pilastra(fimFaixaDireita+125*coeCmToPx,alturaAltar*tamQuadrado+distParedeFrontal_1pilastra+ladoPilastra+dist1pilastra_2pilastra);
        pilastra(fimFaixaDireita+125*coeCmToPx,alturaAltar*tamQuadrado+distParedeFrontal_1pilastra+ladoPilastra*2+dist1pilastra_2pilastra+dist2pilastra_3pilastra);
    }

    void pilastra(float px,float py){
        fill(#5A5A5A);
        rect(px,py,32*0.41666666666,32*0.41666666666);

        fill(#ffffff);
        float size = 20;
        String texto = "Pilastra";
        px += -10;
        py += 31;
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

    // modeler

    private void saveModel(){

    }
    private void defineKeyMap(){
        keyMap.put("quit","q");
        keyMap.put("save","s");
        keyMap.put("new-chair","c");
    }

    public void keyPressed(){
        switch 
    }

}
