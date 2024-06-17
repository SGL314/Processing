import java.util.Stack;

int qtDiscos = 10;
int minTamanhoInicial = 40;
int largura = 20;
int variacaoTamanho = 20;
boolean colocaBuffer = true;
boolean podePegarAnterior = false;
int movimentos = 0;

Stack<Disco> bast1 = new Stack<Disco>();
Stack<Disco> bast2 = new Stack<Disco>();
Stack<Disco> bast3 = new Stack<Disco>();
Stack<Disco> buf   = new Stack<Disco>();
Stack<Disco>[][] configuracao = new Stack[2][3];

void setup(){
    size(1000,800);
    criaDiscos();
    salvaTodasConfiguracoes();
}

void criaDiscos(){
    int n = 1;
    int tam = minTamanhoInicial+(qtDiscos-1)*variacaoTamanho;
    while (n<=qtDiscos){
        bast1.push(new Disco( tam-variacaoTamanho*(n-1), largura));
        n++;
    }
}

void draw(){
    background(#FFFFFF);
    desenhaBastoes();
    desenhaDiscos();
    verificaSeVenceu();
    escreveQuantidadeMovimentos();
}

void desenhaBastoes(){
    float dist = width/4;
    int larg = 20;
    int bastao = 1;
    while (bastao < 4){
        fill(#716E6E);
        rect(bastao*dist-larg/2,height/3,larg,height*2/3);
        bastao++;
    }
    rect(0,height-30,width,30);
}

void desenhaDiscos(){
    int i =1;
    for (Disco d : bast1){
        d.desenha(i,false);
        i++;
    }
    i=1;
    for (Disco d : bast2){
        d.desenha(i,false);
        i++;
    }
    i=1;
    for (Disco d : bast3){
        d.desenha(i,false);
        i++;
    }
    i=1;
    for (Disco d : buf){
        d.desenha(i,true);
        i++;
    }
}

void colocaBuffer(){
    podePegarAnterior = false;
    if (mouseX < width/4+width/8 && bast1.size() != 0){
        buf.push(bast1.pop());
        colocaBuffer = false;
        return;
    }else if (mouseX < width/4*2+width/8 && bast2.size() != 0){
        buf.push(bast2.pop());
        colocaBuffer = false;
        return;
    }else if (bast3.size() != 0){
        buf.push(bast3.pop());
        colocaBuffer = false;
        return;
    }
}

void puxaBuffer(){
    if (mouseX < width/4+width/8){
        if (bast1.size() != 0){
            if (buf.peek().comprimento < bast1.peek().comprimento){
                bast1.push(buf.pop());
                if (bast1.peek().bastao != 1){
                    bast1.peek().bastao = 1;
                    podePegarAnterior = true;
                    salvaConfiguracao();
                    movimentos++;
                }
                colocaBuffer = true;
                return;
            }
        }else{
            bast1.push(buf.pop());
            if (bast1.peek().bastao != 1) movimentos++;
            bast1.peek().bastao = 1;
            colocaBuffer = true;
            podePegarAnterior = true;
            salvaConfiguracao();
            return;
        }
    }else if (mouseX < width/4*2+width/8){
        if (bast2.size() != 0){
            if (buf.peek().comprimento < bast2.peek().comprimento){
                bast2.push(buf.pop());
                if (bast2.peek().bastao != 2){
                    bast2.peek().bastao = 2;
                    podePegarAnterior = true;
                    salvaConfiguracao();
                    movimentos++;
                }
                colocaBuffer = true;
                return;
            }
        }else{
            bast2.push(buf.pop());
            if (bast2.peek().bastao != 2) movimentos++;
            bast2.peek().bastao = 2;
            colocaBuffer = true;
            podePegarAnterior = true;
            salvaConfiguracao();
            return;
        }
    }else{
        if (bast3.size() != 0){
            if (buf.peek().comprimento < bast3.peek().comprimento){
                bast3.push(buf.pop());
                if (bast3.peek().bastao != 3){
                    bast3.peek().bastao = 3;
                    podePegarAnterior = true;
                    salvaConfiguracao();
                    movimentos++;
                }
                colocaBuffer = true;
                return;
            }
        }else{
            bast3.push(buf.pop());
            if (bast3.peek().bastao != 3) movimentos++;
            bast3.peek().bastao = 3;
            colocaBuffer = true;
            podePegarAnterior = true;
            salvaConfiguracao();
            return;
        }
    }
}

void mousePressed(){
    if (mouseButton == LEFT){
        if (colocaBuffer && buf.size() <= 1){
            colocaBuffer();
        }else if (!(colocaBuffer) && buf.size() == 1){
            puxaBuffer();
        }
    }
}

void salvaConfiguracao(){
    for (int i =0;i<3;i++){
        configuracao[0][i] = configuracao[1][i];
    }
    configuracao[1][0] = copiaDiscos(bast1);
    configuracao[1][1] = copiaDiscos(bast2);
    configuracao[1][2] = copiaDiscos(bast3);
}

void salvaTodasConfiguracoes(){
    salvaConfiguracao();
    salvaConfiguracao();
    podePegarAnterior = false;
}

void coletaConfiguracao(){
    if (podePegarAnterior){
      bast1 = configuracao[0][0];
      bast2 = configuracao[0][1];
      bast3 = configuracao[0][2];
      colocaBuffer = true;
      podePegarAnterior = false;
      salvaConfiguracao();
      movimentos--;
    }
}

void verificaSeVenceu(){
    if (bast3.size() == qtDiscos){
        fill(#000000);
        textFont(createFont("arial",50));
        if (pow(2,qtDiscos)-1 == movimentos)
          text("Você Venceu",width/2-100,height/2-50);
        else
          text("Você Venceu\nMas da pra melhorar",width/2-100,height/2-50);
    }
}

void escreveQuantidadeMovimentos(){
    fill(#000000);
    textFont(createFont("arial",25));
    text("Movimentos: "+movimentos,width-textWidth("Movimentos: "+movimentos),25);
}

void keyPressed(){
  if (key == 'r'){
    bast1 = new Stack<Disco>();
    bast2 = new Stack<Disco>();
    bast3 =new Stack<Disco>();
    buf = new Stack<Disco>();
    movimentos = 0;
    criaDiscos();
  }else if (key == 'a'){
    coletaConfiguracao();
  }
}

Stack<Disco> copiaDiscos(Stack<Disco> stack){
    int[][] dados = new int[stack.size()][3];
    int i=0;
    for (Disco d : stack){
        dados[i][0] = d.comprimento;
        dados[i][1] = d.largura;
        dados[i][2] = d.bastao;
        i++;
    }
    Stack<Disco> copia = new Stack<Disco>();
    for (int[] dado : dados){
        copia.push(new Disco(dado[0],dado[1]));
        copia.peek().bastao = dado[2];
    }
    return copia;
}
