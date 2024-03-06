int[][] grid;
char[][] gridD;
int[][][] grids;
int[][] gridI;
int n = 200;

float probN = 0.001;
int tam = 500;
boolean run = false;
int grid_selected = 0;
int qt_grids = 0;
int numNeu = 5;
int numr1 = 1;
int numr2 = 2;
int numr3 = 3;
int numr4 = 4;
int corNeu = #FF0000;
int numInf = 6;
int[] corRetas = {#E35763,#66B0EA,#87E87E,#DFE87E};
int corInf = #000000;
Info[] infos;
int qt_infos = 0;

public class Info{
    int v = numInf,i,j;
    char d;
    public void Info(char D,int I,int J){
        d = D;
        i = I;
        j = J;
    }
}

void setup(){
  size(1000,1000);
  frameRate(5);
  grid = criaGrid(0);
  gridI = criaGrid(1);
 
}

int[][] criaGrid(int type){
  int[][] m = new int[n][n];
  
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      m[i][j] = 0;
      if (type == 0){ 
        m[i][j] = (random(1) <= probN)? numNeu : 0;
      }
      
    }
  }
  return m;
}

int vizNeu(int i,int j){
  // int a = j;
  // j = i;
  // i = a;
  int len = 1;
  if (grid[(n+(i-1))%n][j]==numNeu || grid[(n+(i+1))%n][j]==numNeu){
    return numr1;
  }else if (grid[i][(n+(j-1))%n]==numNeu || grid[i][(n+(j+1))%n]==numNeu){
    return numr2;
  }

  if ((grid[(n+(i-1))%n][j]==numr1 && grid[i][j] == 0) || (grid[(n+(i+1))%n][j]==numr1 && grid[i][j] == 0)){
    return numr1;
  }else if (grid[i][(n+(j-1))%n]==numr2&& grid[i][j] == 0 || grid[i][(n+(j+1))%n]==numr2&& grid[i][j] == 0){
    return numr2;
  }

  if ((grid[(n+(i-1))%n][j]==numr1 && grid[i][j] == 0) || (grid[(n+(i+1))%n][j]==numr1 && grid[i][j] == 0)){
    return numr1;
  }
  return 0;
}

void grow(){
  int[][] novoGrid = new int[n][n];
  
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      int vizN = vizNeu(i,j);
      if (vizN != 0){
        novoGrid[i][j] = vizN;
      }else{
        novoGrid[i][j] = grid[i][j];
      }
      if (i == j){
        //novoGrid[i][j] = 2;
      }
    }
  }
  grid = novoGrid;
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      if (gridI[i][j] == numInf && grid[j][i] == numNeu){
        // int a = j;
        // j = i;
        // i = j;
        //grid[10][10] = numr3;
        
        //gridI[(n+i-1)%n][j] = grid[(n+i-1)%n][j];
        gridI[(n+i-1)%n][j] = numInf;
        //gridI[(n+i+1)%n][j] = grid[i+1][(n+j+1)%n];
        gridI[(n+i+1)%n][j] = numInf;
        //gridI[i][(n+j-1)%n] = grid[i][(n+j-1)%n];
        gridI[i][(n+j-1)%n] = numInf;
        //gridI[i][(n+j+1)%n] = grid[i][(n+j+1)%n];
        gridI[i][(n+j+1)%n] = numInf;
        gridI[i][j] = grid[i][j];
        qt_infos += 4;

        Info[] infos_new = new Info[qt_infos];
        int p = 0;
        if (qt_infos>4){
          for (Info inf : infos){
            infos_new[p] = inf;
            p++;
          }
        }
        char[] chrs = {'n','s','o','l'};
        int[] vis = {i-1,i+1,i,i};
        int[] vjs = {j,j,j-1,j+1};
        for (int k=0;k<4;k++){
          infos_new[p] = new Info(chrs[k],vis[k],vjs[k]);
          p++;
        }
        infos = infos_new;
        
      }
      
    }
  }
  gridI = new int[n][n];
  gridD = new char[n][n];
  if (qt_infos>0){
    for (Info inf : infos){
      gridI[(n+inf.i)%n][(n+inf.j)%n] = 0;
      switch (inf.d){
        case 'n':
          inf.i-=1;
          break;
        case 's':
          inf.i-=-1;
          break;
        case 'o':
          inf.j-=1;
          break;
        case 'l':
          inf.j-=-1;
          break;
      }
      if (gridI[(n+inf.i)%n][(n+inf.j)%n] != 3.14){
        if ((inf.d == 's' || inf.d == 'n')&&grid[(n+inf.j)%n][(n+inf.i)%n]==numr2 || (inf.d == 'l' || inf.d == 'o')&&grid[(n+inf.j)%n][(n+inf.i)%n]==numr1 || grid[(n+inf.j)%n][(n+inf.i)%n]==numNeu){
          gridI[(n+inf.i)%n][(n+inf.j)%n] = inf.v;
          
        }else if (grid[(n+inf.j)%n][(n+inf.i)%n] ==numr1){
          if (gridD[(n+inf.j)%n][(n+inf.i)%n] != 0){
            inf.d = gridD[(n+inf.j)%n][(n+inf.i)%n];
          }else{
            inf.d = (random(1) >= 0.5) ? 'l' :'o';
          }
        }else if (grid[(n+inf.j)%n][(n+inf.i)%n] == numr2){
          if (gridD[(n+inf.j)%n][(n+inf.i)%n] != 0){
            inf.d = gridD[(n+inf.j)%n][(n+inf.i)%n];
          }else{
            inf.d = (random(1) >= 0.5) ? 'n' :'s';
          }
        }
        if (gridD[(n+inf.j)%n][(n+inf.i)%n] != 0){
          inf.d = gridD[(n+inf.j)%n][(n+inf.i)%n];
        }
        gridI[(n+inf.i)%n][(n+inf.j)%n] = inf.v;
        gridD[(n+inf.i)%n][(n+inf.j)%n] = inf.d;
        // if (grid[(n+inf.i)%n][(n+inf.j)%n] == 0){
        //   inf.v = 0;
        // }
        if (inf.i<0){
          inf.i+=n;
        }
        if (inf.j<0){
          inf.j+=n;
        }
        
      }

    }
  }
  
}

void mostraGrid(){
  float l = width/(float)n;
  float h = height/(float)n;
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      stroke(225);
      if (gridI[j][i] == numInf){
        fill(corInf);
      }else if (grid[i][j] == numr1 || grid[i][j] == numr2 || grid[i][j] == numr3 || grid[i][j] == numr4){
        fill(corRetas[grid[i][j]-1]);
      }else if (grid[i][j] == numNeu){
        fill(corNeu);
      }else{
        fill(255);
      }
      rect(j*l, i*h, l, h);
    }
  }
  
}

void draw(){
  mostraGrid();
  if (run){
    grow();
  }
}

void keyReleased(){
  if (keyCode == LEFT){
    grid = criaGrid(0);
  }else if (keyCode == RIGHT){
    grid = criaGrid(1);
    gridI = criaGrid(1);
    infos = new Info[0];
  }else if (keyCode == DOWN){
    run = (run) ? false: true;
    grid_selected = 0;
  }else if (keyCode == ALT){ // Salva
    int[][][] save = grids;
    qt_grids += 1;
    grids = new int[qt_grids][n][n];
    for (int i=0;i<1;i++){
        for (int j=0;j<n;j++){
            for (int k=0;k<n;k++){
                grids[i][j][k] = grid[j][k];
            }
        }
    }
    for (int i=1;i<qt_grids;i++){
        for (int j=0;j<n;j++){
            for (int k=0;k<n;k++){
                grids[i][j][k] = save[i-1][j][k];
            }
        }
    }
    
  }else if (keyCode == CONTROL){ // Seleciona de trás pra frente
    grid_selected += 1;
    if (grid_selected >= qt_grids){
        grid_selected -= qt_grids;
    }
    grid = grids[qt_grids-grid_selected-1];
  }else if (keyCode == SHIFT){ // Seleciona de frente para trás
    grid_selected -= 1;
    if (grid_selected < 0){
        grid_selected += qt_grids;
    }
    grid = grids[qt_grids-grid_selected-1];
  }
}

void mouseClicked(){
  int px,py;
  px = mouseX;
  py = mouseY;
  int i,j,ki,kj;
  ki = px%(width/n);
  i = (int) ((px-ki)/(width/n));
  if (px-ki <= 0){
    i += 1;
  }
  kj = py%(height/n);
  j = (int) ((py-kj)/(width/n));
  if (py-kj <= 0){
    j += 1;
  }
  if (i<0){
    i+=n;
  }
  if (j<0){
    j+=n;
  }
  if (grid[j][i]==numNeu){
    gridI[i][j] = numInf;
  }else{
    grid[j][i] = numNeu;
  }
}
