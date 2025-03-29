int longitude = 30;
float tamQuadrado,
espessuraPulpito,
longPulpito,blocos = 60.0,
tamCadeira,espacoAteMeridianoCentral = 1.5,
espacoEntreFileiras=25,espacoEntreCadeiras=3,
distBlocosLaterais = 3.5,
aberturaCorredor = 3.5;
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

float[] distBlocosCentrais = {6.0,6.0},
layoutBlocosCentrais = {6,6,7,7,8,8,9,9,10,10},
layoutBlocosLaterais = {4,6,7,8,8,8,8,7,6}, // default: 4,7,8,9,7,7
diferencaFileiraLateralDireitaP =  {0,1.5,1.5,1.5,1.0,1.0,1.0,1.0,1.0},
diferencaFileiraLateralEsquerdaP = {0,1.0,1.0,1.0,1.0,1.5,1.0,1.5,1.0}; // pimeiro sempre '0';  inicial: 0,0.5,1.5,0.33333333333,0.8,1.5

// Apresentation
int addingDownLat = 170;
int addingDownCen = 50*2;
/*
{0,1.5,0.5,0.5,0.5,0.5}
Ld: p: 0,1.5,0.5,2.5,1.5,0.5 -> 0,1.5,0.5,2.5,0.5,0.5
Le: p: 0,1.5,0.5,0.5,0.5,0.5

E:
In: 0,1.5,0.5,0.5,0.5,0.5,
Out: 0,0.5,0.5,0.5,-0.5,-1.5
D:
In: 0,1.5,0.5,1.5,0.5,0.5
Out: 0,0.5,0.5,0.5,-2.5,-0.5
*/

int qtCadeiras = 0;
int loop = 0;

void setup(){
    size(1000,1000);
    tamQuadrado = width/blocos;
    espessuraPulpito = 2 * tamQuadrado;
    longPulpito = longitude*tamQuadrado;
    tamCadeira = 21.6666666666;
    // 1px = 2.4cm
    // 1cm = 0.4166666px
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
    loop+=1;
    espacoEntreFileiras = 3*tamQuadrado-tamCadeira;
    background(#ffffff);
    qtCadeiras = 0;
    grid(#ffffff);
    linhasImaginarias();
    pulpito();
    blocosCentrais();
    blocosLaterais();
    pilastra(930,225);
    dados();
    position();
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
    strokeWeight(5);
    // meridiano
    stroke(#ff0000);
    line(width/2,espessuraPulpito,width/2,height);
    fill(#ffffff);
    size = 20;
    texto = "Meio do Nobre";
    px = 510;
    py = 605+addingDownCen;
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
    texto = "30 blocos";
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
    py = 605+addingDownCen;
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
    py = 605+addingDownCen;
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
    texto = "6 blocos";
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
    texto = "1.5 blocos";
    px = 430;
    py = 125;
    noStroke();
    textSize(size);
    rect(px,py-size+3,textWidth(texto),size);
    fill(#2E60E5);
    text(texto,px,py);
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
    // 3.75/(layoutBlocosLaterais[0]*tamCadeira+(layoutBlocosLaterais[0]-1)*espacoEntreCadeiras)
    float ang = 45,difLateral=0; // descobrindo a reta da função : f(0) = distBlocosLaterais; f(meridiano que tange o bloco) = distsBlocosCentrais[1]; [negativo para horário]
    aberturaCorredor = (14*tamQuadrado-espacoAteMeridianoCentral*tamQuadrado-layoutBlocosCentrais[0]*tamCadeira-(layoutBlocosCentrais[0]-1)*espacoEntreCadeiras)/tamQuadrado;
    // println(aberturaCorredor);
    translate(width/2-espacoAteMeridianoCentral*tamQuadrado-layoutBlocosCentrais[0]*tamCadeira-(layoutBlocosCentrais[0]-1)*espacoEntreCadeiras-tamQuadrado*aberturaCorredor,espessuraPulpito+distBlocosCentrais[1]*tamQuadrado);
    rotate((float) ang*PI/180);
    fill(#CB8221);
    // fill(#ff0000,128);
    // esquerda
    for (float line : layoutBlocosLaterais){
        if (qtInitCadeiras==0) qtInitCadeiras=(int) line;
        difLateral += diferencaFileiraLateralEsquerdaP[linha];
        for (int i = 0 ; i < line;i++){
            rect((-i)*(tamCadeira+espacoEntreCadeiras)-tamCadeira+difLateral*tamCadeira+linha*espacoEntreCadeiras,linha*(espacoEntreFileiras+tamCadeira),tamCadeira,tamCadeira);
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
    for (float line : layoutBlocosLaterais){
        if (qtInitCadeiras==0) qtInitCadeiras=(int) line;
        difLateral += diferencaFileiraLateralDireitaP[linha];
        for (int i = 0 ; i < line;i++){
            fill(#CB8221);
            // marca uma especifica
            //if (i==0 && linha==3) fill(255,0,0);
            //
            rect((i)*(tamCadeira+espacoEntreCadeiras)-difLateral*tamCadeira-linha*espacoEntreCadeiras,linha*(espacoEntreFileiras+tamCadeira),tamCadeira,tamCadeira);
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
    float size = 20;
    texto = "";
    int tam = 0;
    int i = 0;
    for (float item : layoutBlocosLaterais){
        tam++;
    }
    for (float item : layoutBlocosLaterais){
        texto += int(item);
        if (i<tam-1){
            texto+=", ";
        }
        i++;
    }
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
    for (float item : layoutBlocosLaterais){
        texto += int(item);
        if (i<tam-1){
            texto+=", ";
        }
        i++;
    }
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
    for (float item : layoutBlocosCentrais){
        tam++;
    }
    for (float item : layoutBlocosCentrais){
        texto += int(item);
        if (i<tam-1){
            texto+=", ";
        }
        i++;
    }
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
    for (float item : layoutBlocosCentrais){
        texto += int(item);
        if (i<tam-1){
            texto+=", ";
        }
        i++;
    }
    px = 510;
    py = 575+addingDownCen-tamCadeira-espacoEntreFileiras;
    noStroke();
    textSize(size);
    rect(px,py-size+3,textWidth(texto),size);
    fill(#00a000);
    text(texto,px,py);
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
