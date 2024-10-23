
int[][] tabuleiro = new int[8][8];
String[] letras = {"a","b","c","d","e","f","g","h"};
int[] numeros = {1,2,3,4,5,6,7,8};
int me = 0;
int turn = 0; // 0 branco 1 preto
int tamPeca = 70;
int border = 50;
int cpx = 0, cpy = 0;
boolean selectPiece = true,selectLocal = false;
int[][] positions = {{-1,-1},{-1,-1}};

void setup(){
    // Altere
    int _me = 1; // 1 branco, 2 preto
    int put = 1; // 0  branco 1 preto
    int teto = 3; // linhas
    // Não altere
    size(800,800);
    me = _me;
    if (_me==2) turn = 1;
    tabuleiro = setTab(_me,teto,put);
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
            }else if (i+1>8-teto){
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
    if (me==1){
        for(int i=0;i<8;i++){
            fill(#000000);
            int size=25;
            textSize(size);
            text(letras[i],border+i*(width-2*border)/8+(width-2*border)/16,border-10);
            text(letras[i],border+i*(width-2*border)/8+(width-2*border)/16,height-border+size);
            text(""+numeros[7-i],border-size,i*(width-2*border)/8+border+(height-2*border)/16+size/2);
            text(""+numeros[7-i],height-border+size/2,i*(width-2*border)/8+border+(height-2*border)/16+size/2);
        }
    }else{
        for(int i=7;i>=0;i--){
        fill(#000000);
        int size=25;
        textSize(size);
        text(letras[i],border+(7-i)*(width-2*border)/8+(width-2*border)/16,border-10);
        text(letras[i],border+(7-i)*(width-2*border)/8+(width-2*border)/16,height-border+size);
        text(""+numeros[(i)],border-size,i*(width-2*border)/8+border+(height-2*border)/16+size/2);
        text(""+numeros[(i)],height-border+size/2,i*(width-2*border)/8+border+(height-2*border)/16+size/2);
    }
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
    for(int i=7;i>=0;i--){
        for(int j=7;j>=0;j--){
            
            if (j*(width-2*border)/8 +border<= px && px <= (j+1)*(width-2*border)/8+border && i*(width-2*border)/8 +border<= py && py <= (i+1)*(width-2*border)/8+border){
                if (tabuleiro[i][j] != 0 && selectPiece){
                    selectPiece = false;
                    selectLocal = true;
                    positions[0][0] = i;
                    positions[0][1] = j;
                }else if (selectLocal && tabuleiro[i][j] == 0){
                    selectLocal = false;
                    selectPiece = true;
                    positions[1][0] = i;
                    positions[1][1] = j;
                }
                cpx = j*(width-2*border)/8+(width-2*border)/16+border;
                cpy = i*(width-2*border)/8+(width-2*border)/16+border;
            }
        }
    }
    println("");
}

void move(){
    if (positions[0][0] != -1 && positions[1][0] != -1){
        int ix = positions[0][1];
        int iy = positions[0][0];
        int fx = positions[1][1];
        int fy = positions[1][0];
        int fromX = tabuleiro[iy][ix];
        int toX = tabuleiro[fy][fx];
        boolean doIt = false;
        // Find if is possible
        if (fromX%2 != me%2){ // frente
            if (fromX <= 2 && fromX != 0){
                println(ix+":"+iy+"\n"+fx+":"+fy);
                if (fy>iy){
                    // movimento de peça normal
                    if (mod(fx-ix) == 1){
                        println("go frente: "+mod(fx-ix)+" "+(fy-iy));
                        doIt = true;
                    }else if (mod(fx-ix) == 2 && tabuleiro[(fy-iy)/2+iy][(fx-ix)/2+ix] != 0){//captura de peca normal
                        println("take frente: "+mod(fx-ix)+" "+(fy-iy));
                        tabuleiro[(fy-iy)/2+iy][(fx-ix)/2+ix] = 0;
                        doIt = true;
                    }
                }else{
                    println("try frente: "+mod(fx-ix)+" "+(fy-iy));
                }
            }
        }else if (fromX%2 == me%2){ // traz
            if (fromX <= 2 && fromX != 0){
                println(ix+":"+iy+"\n"+fx+":"+fy);
                // movimento de peça normal
                if (fy<iy){
                    if (mod(fx-ix) == 1){
                        println("go traz: "+mod(fx-ix)+" "+(fy-iy));
                        doIt = true;
                    }else if (mod(fx-ix) == 2 && tabuleiro[(fy-iy)/2+iy][(fx-ix)/2+ix] != 0){
                        println("take traz: "+mod(fx-ix)+" "+(fy-iy));
                        tabuleiro[(fy-iy)/2+iy][(fx-ix)/2+ix] = 0;
                        doIt = true;
                    }
                }else{
                    println("try traz: "+mod(fx-ix)+" "+(fy-iy));
                }
            }
        }
        if (mod(fx-ix) == 2 && tabuleiro[(fy-iy)/2+iy][(fx-ix)/2+ix] != 0){//captura de peca normal
            println("take frente: "+mod(fx-ix)+" "+(fy-iy));
            tabuleiro[(fy-iy)/2+iy][(fx-ix)/2+ix] = 0;
            doIt = true;
        }

        
        // Do it
        if (doIt){
            turn = (turn==1) ? 0 : 1;
            tabuleiro[iy][ix] = 0;
            tabuleiro[fy][fx] = fromX;
        }
        // reset
        positions[0][0] = -1;
        positions[0][1] = -1;
        positions[1][0] = -1;
        positions[1][1] = -1;
    }
}

int mod(int a){
    return (int) Math.pow(Math.pow(a,2),0.5f);
}

void calc(int[][] tab){
    println("<");
    for (int i=0;i<8;i++){
        for (int j=0;j<8;j++){
            if (me == 1){
                int v = tab[j][i];
                if (v%2 != me%2) continue;
                int ix = i;
                int iy = j;
                int fx = -1;
                int fy = -1;
                int[] ar1 = {-1,1};
                for (int p1=0;p1<2;p1++){
                    if (iy+ar1[p1]>=0 && iy+ar1[p1]<8 && ix-1>=0){
                        fy = iy+ar1[p1];
                        fx = ix-1;
                        int fromX = tab[iy][ix];
                        int toX = tab[fy][fx];
                        boolean doIt = false;
                        if (toX != 0) continue;
                        // Find if is possible
                        if (fromX%2 != me%2){ // frente
                            if (fromX <= 2 && fromX != 0){
                                println(ix+":"+iy+"\n"+fx+":"+fy+"-");
                                if (fy>iy){
                                    // movimento de peça normal
                                    if (mod(fx-ix) == 1){
                                        //println("go frente: "+mod(fx-ix)+" "+(fy-iy));
                                        doIt = true;
                                    }else if (mod(fx-ix) == 2 && tab[(fy-iy)/2+iy][(fx-ix)/2+ix] != 0){//captura de peca normal

                                        tab[(fy-iy)/2+iy][(fx-ix)/2+ix] = 0;
                                        doIt = true;
                                    }
                                }else{
                                }
                            }
                        }else if (fromX%2 == me%2){ // traz
                            if (fromX <= 2 && fromX != 0){
                                // movimento de peça normal
                                println(ix+":"+iy+"\n"+fx+":"+fy+"-");
                                if (fy<iy){
                                    if (mod(fx-ix) == 1){
                                        //println("go traz: "+mod(fx-ix)+" "+(fy-iy));
                                        doIt = true;
                                    }else if (mod(fx-ix) == 2 && tab[(fy-iy)/2+iy][(fx-ix)/2+ix] != 0){
                                        //println("take traz: "+mod(fx-ix)+" "+(fy-iy));
                                        tab[(fy-iy)/2+iy][(fx-ix)/2+ix] = 0;
                                        doIt = true;
                                    }
                                }else{
                                    //println("try traz: "+mod(fx-ix)+" "+(fy-iy));
                                }
                            }
                        }
                        if (mod(fx-ix) == 2 && tab[(fy-iy)/2+iy][(fx-ix)/2+ix] != 0){//captura de peca normal
                            println("take frente: "+mod(fx-ix)+" "+(fy-iy));
                            tab[(fy-iy)/2+iy][(fx-ix)/2+ix] = 0;
                            doIt = true;
                        }

                        
                        // Do it
                        if (doIt){
                            //turn = (turn==1) ? 0 : 1;
                            //tab[iy][ix] = 0;
                            //tab[fy][fx] = fromX;

                            fill(#00FFFF);
                            // 
                            circle(border+(7-ix)*(width-2*border)/8+(width-2*border)/16,border+(7-iy)*(width-2*border)/8+(width-2*border)/16,5);
                            line(border+(7-ix)*(width-2*border)/8+(width-2*border)/16,border+(7-iy)*(width-2*border)/8+(width-2*border)/16,border+(7-fx)*(width-2*border)/8+(width-2*border)/16,border+(7-fy)*(width-2*border)/8+(width-2*border)/16);
                            fill(#FFFF00);
                            circle(border+(7-fx)*(width-2*border)/8+(width-2*border)/16,border+(7-fy)*(width-2*border)/8+(width-2*border)/16,5);
                            // border+fx*(width-2*border)/8+(width-2*border)/16,border+fy*(width-2*border)/8+(width-2*border)/16);

                        }
                    }
                }
            }
        }
    }
    println(">");
}

void promove(){
    for (int i=0;i<8;i++){
        for (int j=0;j<8;j++){
            if (me == 2){
                if (j==7){
                    int v = tabuleiro[j][i];
                    if (v == 1){
                        tabuleiro[j][i] = 3;
                    }
                }else if (j==0){
                    int v = tabuleiro[j][i];
                    if (v == 2){
                        tabuleiro[j][i] = 4;
                    }
                }
            }else if (me == 1){
                if (j==0){
                    int v = tabuleiro[j][i];
                    if (v == 1){
                        tabuleiro[j][i] = 3;
                    }
                }else if (j==7){
                    int v = tabuleiro[j][i];
                    if (v == 2){
                        tabuleiro[j][i] = 4;
                    }
                }
            }
        }
    }
}

void draw(){
    background(#FFFFFF);
    show();
    // show positions
    if (positions[0][0] != -1 && positions[1][0] != -1){
        fill(#FF0000);
        circle(positions[0][0]*(width-2*border)/8+(width-2*border)/16+border,positions[0][1]*(width-2*border)/8+(width-2*border)/16+border,10);
        fill(#00FF00);
        circle(positions[1][0]*(width-2*border)/8+(width-2*border)/16+border,positions[1][1]*(width-2*border)/8+(width-2*border)/16+border,10);
    }

    move();
    promove();
    int[][] a = new int[8][8];
    for (int i=0;i<8;i++){
        for (int j=0;j<8;j++){
            a[i][j] = tabuleiro[i][j];
        }
    }
    calc(a);
    

}
