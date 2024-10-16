
int[][] tabuleiro = new int[8][8];
String[] letras = {"a","b","c","d","e","f","g","h"};
int[] numeros = {1,2,3,4,5,6,7,8};
int me = 0;
int turn = 1; // 0 branco 1 preto
int tamPeca = 70;
int border = 50;

void setup(){
    // Altere
    int _me = 1; // 1 branco, 2 preto
    int put = 1; // 0  branco 1 preto
    // Não altere
    size(800,800);
    me = _me;
    tabuleiro = setTab(_me,3,put);
}

int[][] setTab(int me,int teto,int put){
    int you = 2;
    if (me == 2){
        you = 1;
    }
    int[][] n_tab = new int[8][8];
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            if (i+1<=teto){
                if ((j+i%2)%2 == put){
                    n_tab[i][j] = you;
                }
            }else if (i+1>=8-teto){
                if ((j+i%2)%2 == put){
                    n_tab[i][j] = me;
                }
            }
        }
    }
    return n_tab;
}

void show(){
    int[] cores = {#DEB887,#957A56};
    int cor = 0;
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            // Tabuleiro
            fill(cores[cor]);
            rect(j*(width-2*border)/8+border,i*(height-2*border)/8+border,(width-2*border)/8,(height-2*border)/8);
            if (j!= 7){
            if (cor == 0) cor = 1;
            else cor=0;
            }
            // Peças
            if (tabuleiro[i][j] !=0 ){
                int corP = #FFFFFF;
                if (tabuleiro[i][j]%2 == 0){
                    corP = #000000;
                }
                int corPrev = (#FFFFFF == corP) ? #000000 : #FFFFFF;
                fill(corPrev);
                circle(border+j*(width-2*border)/8+(width-2*border)/16,border+i*(width-2*border)/8+(width-2*border)/16,tamPeca+5);
                fill(corP);
                circle(border+j*(width-2*border)/8+(width-2*border)/16,border+i*(width-2*border)/8+(width-2*border)/16,tamPeca);
                if (tabuleiro[i][j]>=3){
                    fill(corPrev);
                    circle(border+j*(width-2*border)/8+(width-2*border)/16,border+i*(width-2*border)/8+(width-2*border)/16,15);
                    fill(corP);
                    circle(border+j*(width-2*border)/8+(width-2*border)/16,border+i*(width-2*border)/8+(width-2*border)/16,10);
                }
            }
        }
    }
    // Letras e Numeros
    for(int i=0;i<8;i++){
        fill(#000000);
        int size=25;
        textSize(size);
        text(letras[i],border+i*(width-2*border)/8+(width-2*border)/16,border-10);
        text(letras[i],border+i*(width-2*border)/8+(width-2*border)/16,height-border+size);
        text(""+numeros[7-i],border-size,i*(width-2*border)/8+border+(height-2*border)/16+size/2);
        text(""+numeros[7-i],height-border+size/2,i*(width-2*border)/8+border+(height-2*border)/16+size/2);
    }
    // Turno
    int hTurn = 25,wTurn = 25,borderTurn = 5,borderTurnSelect=5;
    if (me == 1){
        if (turn == 0){
            fill(#000000);
            rect(borderTurn,height/2-hTurn,wTurn,hTurn);
            fill(#FF0000);
            rect(borderTurn-borderTurnSelect,height/2-borderTurnSelect,wTurn+borderTurnSelect*2,hTurn+borderTurnSelect*2);
            
            fill(#FFFFFF);
            rect(borderTurn,height/2,wTurn,hTurn);
        }else{
            fill(#FFFFFF);
            rect(borderTurn,height/2,wTurn,hTurn);
            fill(#FF0000);
            rect(borderTurn-borderTurnSelect,height/2-hTurn-borderTurnSelect,wTurn+borderTurnSelect*2,hTurn+borderTurnSelect*2);
            
            fill(#000000);
            rect(borderTurn,height/2-hTurn,wTurn,hTurn);
        }
    }else{
        if (turn == 0){
            fill(#FFFFFF);
            rect(borderTurn,height/2-hTurn,wTurn,hTurn);
            fill(#FF0000);
            rect(borderTurn-borderTurnSelect,height/2-borderTurnSelect,wTurn+borderTurnSelect*2,hTurn+borderTurnSelect*2);
            fill(#000000);
            rect(borderTurn,height/2,wTurn,hTurn);
        }else{
            fill(#000000);
            rect(borderTurn,height/2,wTurn,hTurn);
            fill(#FF0000);
            rect(borderTurn-borderTurnSelect,height/2-hTurn-borderTurnSelect,wTurn+borderTurnSelect*2,hTurn+borderTurnSelect*2);
            fill(#FFFFFF);
            rect(borderTurn,height/2-hTurn,wTurn,hTurn);
        }
    }
    

}

void mousePressed(){
    int px = mouseX,py = mouseY;
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            if (tabuleiro[i][j] != 0){
                if (dist(j*(width-2*border)/8+(width-2*border)/16,i*(width-2*border)/8+(width-2*border)/16,px,py) <= tamPeca){
                    println(numeros[i]+":"+letras[j]);
                }
            }
        }
    }
}

// float dist(float a ,float b,float c,float d){
//     float dx = pow(a-c,2);
//     float dy = pow(b-d,2);
//     float d = pow(dx+dy,0.5f);
//     return d;
// }

void draw(){
    background(#FFFFFF);
    show();
}
