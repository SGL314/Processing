int[][] grid;
int[][][] grids;
int n = 250;
int tam = 900;
boolean run = false;
int grid_selected = 0;
int qt_grids = 0;

void setup(){
  size(1000,1000);
  frameRate(60);
  grid = criaGrid(1);
 
}

int[][] criaGrid(int type){
  int[][] m = new int[n][n];
  
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      m[i][j] = 0;
      if (type == 0){ 
        m[i][j] = (random(1) > 0.8)? 1 : 0;
      }
      
      //m[i][j] = 0;
      //if (j==n/2){
        //m[i][j] = 1;
      //}
      
      //m[i][j] = 0;
      //if (i==0 || i == n -1||j==0 || j == n-1){
        //m[i][j] = 1;
      //}
      
    }
  }
  return m;
}

void mostraGrid(){
  float l = width/(float)n;
  float h = height/(float)n;
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      stroke(225);
      fill(grid[i][j] == 0 ? 255 : 0);
      rect(j*l, i*h, l, h);
    }
  }
  
}

int vizinhosVivos(int i, int j){
  int soma = 0;
  int len = 1;
  for(int ki = -len; ki < len+1; ki++){
    for(int kj = -len; kj < len+1; kj++){
      //if (ki == 1 && kj == 1){
        //continue;
      //}
      soma += grid[(n+i+ki)%n][(n+j+kj)%n];
    }
  }
  
  return soma - grid[i][j];
}

void atualizaGrid(){
  int[][] novoGrid = new int[n][n];
  
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      int viz = vizinhosVivos(i,j);
      
      if(grid[i][j] == 1){
        if(viz < 2 || viz > 3) novoGrid[i][j] = 0;
        else novoGrid[i][j] = 1;
      }
      else{
        if(viz == 3) novoGrid[i][j] = 1;
        else novoGrid[i][j] = 0;
      }
    }
  }
  
  grid = novoGrid;
}

void draw(){
  mostraGrid();
  if (run){
    atualizaGrid();
  }
}

void keyReleased(){
  if (keyCode == LEFT){
    grid = criaGrid(0);
  }else if (keyCode == RIGHT){
    grid = criaGrid(1);
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
  grid[j][i] = (grid[j][i]==1) ? 0 : 1;
}
