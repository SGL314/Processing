import java.nio.file.Files;
import java.nio.file.Path;

import java.util.*;


String localImage = "../../../OneDrive/Documentos/Scripts/ScriptsPde/Processing/Imager/files/";
String imageFilePNG = "step001", // big001
  imageFileIPD = "-ipd", // imagem propriamente dita
  imageFileCLS = "-cls", // compressao linha-segmentada
  imageFilecicov = "-cicov";// compressao invertida criptogafada orientada a variavel, uses
//
final int mx_width=1720, mx_height=920, mn_width=50, mn_height=75;
int menuW=50, menuH=50;
boolean jumpLines = true;
//
int loop = 0;
long tamFileSaved = 0;
float progress  = -1;
boolean ctrl = false;
String nameImageGenerated = "";
PImage img = null;

void setup() {
  size(800, 600);
  // else size(800,800);
}

void draw() {
  fill(0);
  if (img != null) {
    int grow = processBigImage(img);
    if (grow==1) {
      int w = max(img.width+menuW, mn_width+menuW), h = max(img.height, mn_height);
      w = min(w, mx_width);
      h = min(h, mx_height);
      surface.setSize(w, h);
      image(img, 0, 0, w, h);
    } else {
      int w = max(img.width*grow+menuW, mn_width+menuW), h = max(img.height*grow, mn_height);
      surface.setSize(w, h);
      showBigImage(img, grow);
    }
  }
  menu();
  loop++;
}

int processBigImage(PImage img) {
  int grow = 10;
  while (grow > 1) {
    if (img.width*grow <= mx_width && img.height*grow <= mx_height) {
      for (int i = 0; i < img.pixels.length; i++) {
        int x = (i%img.width)*grow, y = (i/img.width)*grow;
        fill(img.pixels[i]);
        noStroke();
        rect(x, y, grow, grow);
      }
      return grow;
    } else {
      grow--;
    }
  }
  return 1;
}
void showBigImage(PImage img, int grow) {
  for (int i = 0; i < img.pixels.length; i++) {
    int x = (i%img.width)*grow, y = (i/img.width)*grow;
    fill(img.pixels[i]);
    noStroke();
    rect(x, y, grow, grow);
  }
}

void menu() {
  fill(#FFBC74);
  rect(width-menuW, 0, menuW, height);
  fill(0);
  textSize(12);
  text("Menu ", width-menuW+2, textAscent()+textDescent()+2);
  text(loop, width-menuW+2, textAscent()+textDescent()+22);
  //
  int pos = 2, tamToPos = 20;
  text((round(tamFileSaved*1000.0/1024.0))/1000.0+" Kb", width-menuW+2, textAscent()+textDescent()+2+pos*tamToPos);
  pos++;
  if (progress >= 0) {
    text((round(progress*1000))/1000.0+" %", width-menuW+2, textAscent()+textDescent()+2+pos*tamToPos);
    pos++;
  }
  // if (tamFileSaved) {
  // }
}
//
void keyPressed() {

  if (keyCode == CONTROL) ctrl = true;
  String[] comps = {"ipd", "cls", "cicov"};
  switch (key) {
  case 'l': // load image png
    load("png");
    break;
  case 'i': // save png generated
    img.save("files/"+nameImageGenerated+".png");
    println("Imagem "+nameImageGenerated+".png salva com sucesso!");
    break;
  case '1': // save image ipd
  case '2': // save image cls
  case '3': // save image cicov

    if (ctrl) {
      new Thread(() -> {
        load(comps[int(key)-49]);
      }
      ).start();
    } else {
      new Thread(() -> {
        save(comps[int(key)-49]);
      }
      ).start();
    }
    break;
  }
}
void keyReleased() {
  if (keyCode == CONTROL) ctrl = false;
}
//


void load(String local) {
  try {
    println("Carregando by "+local+"...");
    switch (local) {
    case "png":
      img = loadImage(localImage + imageFilePNG+".png");
      break;
    case "ipd":
      img = convertToImage(Files.readString(Path.of(localImage + imageFilePNG+imageFileIPD+".txt")), "ipd");
      break;
    case "cls":
      img = convertToImage(Files.readString(Path.of(localImage + imageFilePNG+imageFileCLS+".txt")), "cls");
      break;
    case "cicov":
      img = convertToImage(Files.readString(Path.of(localImage + imageFilePNG+imageFilecicov+".txt")), "cicov");
      break;
    default:
      println("ERRO ao carregar: formato nao reconhecido! > load("+local+")");
    }

    // List<String> red = Files.readAllLines(Path.of(localImage + imageFilePNG+".png"));
  }
  catch(Exception e) {
  }
}

void save(String format) {
  try {
    String aux = convertToTxt(img, format), name="";
    boolean save = false;

    switch (format) {
    case "ipd":
      name = localImage + imageFilePNG+imageFileIPD+".txt";
      Files.writeString(Path.of(name), aux);
      File arq = new File(dataPath("../files/"+imageFilePNG+imageFileIPD+".txt"));
      println(arq);
      tamFileSaved = arq.length();
      save = true;
      break;
    case "cls":
      name = localImage + imageFilePNG+imageFileCLS+".txt";
      Files.writeString(Path.of(name), aux);
      File arq2 = new File(dataPath("../files/"+imageFilePNG+imageFileCLS+".txt"));
      println(arq2);
      tamFileSaved = arq2.length();
      save = true;
      break;
    case "cicov":
      name = localImage + imageFilePNG+imageFilecicov+".txt";
      Files.writeString(Path.of(name), aux);
      File arq3 = new File(dataPath("../files/"+imageFilePNG+imageFilecicov+".txt"));
      println(arq3);
      tamFileSaved = arq3.length();
      save = true;
      break;
    default:
      println("ERRO ao salvar: formato nao reconhecido! > save("+format+")");
    }
    if (save) println("SALVO com sucesso!");
  }
  catch(Exception e) {
    println("ERRO ao salvar:\n\n" + e);
  }
}

PImage convertToImage(String buffer, String format) {
  PImage aux = null;
  switch (format) {
  case "ipd":
    aux = convertFromIPD(buffer);
    break;
  case "cls":
    aux = convertFromCLS(buffer);
    break;
  case "cicov":
    aux = convertFromCICOV(buffer);
    break;
  default:
    println("ERRO ao converter: formato nao reconhecido! > convertTxt("+format+")");
  }
  nameImageGenerated = imageFilePNG+"-"+format;
  return aux;
}

String convertToTxt(PImage img, String format) {
  String aux = "";
  switch (format) {
  case "ipd":
    aux = convertToIPD(img);
    break;
  case "cls":
    aux = convertToCLS(img);
    break;
  case "cicov":
    aux = convertToCICOV(img);
    break;
  default:
    println("ERRO ao converter: formato nao reconhecido! > convert("+format+")");
  }
  return aux;
}

String convertToIPD(PImage img) {
  img.loadPixels();
  String aux = img.width+"<";
  for (int i = 0; i < img.pixels.length; i++) {
    aux += img.pixels[i] + "";
  }
  aux+=">";
  return aux;
}
PImage convertFromIPD(String buffer) {
  int wid = int(split(buffer, "<")[0]);
  List<String> aux = Arrays.asList(split(buffer, "<")[1].split("-"));
  PImage img_ = createImage(wid, aux.size()/wid, ARGB);
  img_.loadPixels();
  println("Processing IPD "+wid+"x"+(aux.size()/wid)+" ... ");
  for (int i = 0; i < aux.size()-1; i++) {
    img_.pixels[i] = -int(aux.get(i+1));
    progress = (float(i)/float(aux.size()-1))*100.0;
  }
  img_.pixels[aux.size()-2] = -int(aux.get(aux.size()-1).split(">")[0]);
  progress=-1;
  println("Updating pixels ...");
  img_.updatePixels();
  println("Processing IPD ... done!");
  return img_;
}

String convertToCLS(PImage img) {
  img.loadPixels();
  String aux = img.width+"x"+img.height+"<";
  int prev = img.pixels[0];
  int qtd = 1;
  //
  for (int i = 1; i < img.pixels.length; i++) {
    int now = img.pixels[i];
    if (now == prev) {
      qtd++;
    } else {
      if (qtd!=1) {
        aux += prev+"."+qtd;
      } else {
        aux += prev;
      }
      prev = now;
      qtd = 1;
    }
  }
  if (qtd != 1) aux+=prev+"."+qtd;
  else aux+=prev;
  return aux;
}
PImage convertFromCLS(String buffer) {
  // 7x8<-15198184.21-6261564-6261597-10938344-15198184.11-9089902.4-9088639-12380136
  //-15198184.2-14932623-10272661-13166056-12629870
  //-10938344-15198184-15198129-9738556-6261564-7716801-12629870-10938344>
  int wid = int(split(split(buffer, "<")[0], "x")[0]);
  int hei = int(split(split(buffer, "<")[0], "x")[1]);
  println("Processing CLS "+wid+"x"+hei+" ... ");
  //
  PImage img_ = createImage(wid, hei, ARGB);
  img_.loadPixels();
  List<String> blks = Arrays.asList(split(buffer, "<")[1].split("-"));
  // dis-blocks
  List<String> ds_blks = new ArrayList<String>();
  // 15198184.21 6261564
  // println(blks);
  for (int i = 1; i < blks.size(); i++) {
    if (blks.get(i).contains(".")) {
      String[] aux = split(blks.get(i), ".");
      String val = aux[0];
      int qtd = int(aux[1]);
      for (int j = 0; j < qtd; j++) {
        ds_blks.add(val);
      }
    } else {
      ds_blks.add(blks.get(i));
    }
  }
  // println(ds_blks.size());
  // put
  for (int i = 0; i < wid*hei; i++) {
    img_.pixels[i] = -int(ds_blks.get(i));
    progress = (float(i)/float(ds_blks.size()-1))*100.0;
  }
  //
  progress=-1;
  println("Updating pixels ...");
  img_.updatePixels();
  println("Processing CLS ... done!");
  return img_;
}

String cicov_encript(int n,boolean signal) {
  // return ""+n;
  String BASE = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  int tam = BASE.length();
  boolean rev = false;
  if (n < 0) {
    n = -n;
    rev=true;
  }
  // n = (-n)+(int)pow(256,3);


  if (n == 0) return "0";

  StringBuilder sb = new StringBuilder();

  while (n > 0) {
    sb.append(BASE.charAt((int)(n % tam)));
    n /= tam;
  }

  return ((signal)?((rev) ?"-":"+"):"")+sb.reverse().toString();
}
int cicov_decript(String s) {
  String BASE = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  int tam = BASE.length();
  boolean rev = false;
  if (s.charAt(0) == '-') {
    rev=true;
    s = s.substring(1);
  } else if (s.charAt(0) == '+') {
    s = s.substring(1);
  }
  int n = 0;

  for (int i = 0; i < s.length(); i++) {
    n = n * tam + BASE.indexOf(s.charAt(i));
  }

  return ((rev) ?-n:n);
}

String convertToCICOV(PImage img) {
  img.loadPixels();
  String init = img.width+":"+img.height+"<", aux="";
  ArrayList<String> blocks_color = new ArrayList<String>();
  ArrayList<Integer> blocks_qtd = new ArrayList<Integer>();
  ArrayList<String> frags = new ArrayList<String>();
  ArrayList<Integer> frags_qtd = new ArrayList<Integer>();
  int prev = img.pixels[0];
  int qtd = 1;
  println("Compressing to CICOV "+img.width+"x"+img.height+" ... ");
  progress = 0;
  //
  for (int i = 1; i < img.pixels.length; i++) {
    int now = img.pixels[i];
    if (now == prev) {
      qtd++;
    } else {
      String frag = cicov_encript(prev, true);
      if (frags.contains(frag)) {
        int ind = frags.indexOf(frag);
        frags_qtd.set(ind, frags_qtd.get(ind)+1);
      } else {
        frags.add(frag);
        frags_qtd.add(1);
      }
      // if (qtd!=1) {
      //   aux += frag+"."+qtd;
      // } else {
      //   aux += frag;
      // }
      blocks_color.add(frag);
      blocks_qtd.add(qtd);
      prev = now;
      qtd = 1;
    }
    progress = (float(i)/float(img.pixels.length-1)*1000.0)*100.0/1000.0;
    // println(i);
  }
  // end
  String frag = cicov_encript(prev, true);
  if (frags.contains(frag)) {
    int ind = frags.indexOf(frag);
    frags_qtd.set(ind, frags_qtd.get(ind)+1);
  } else {
    frags.add(frag);
    frags_qtd.add(1);
  }
  blocks_color.add(frag);
  blocks_qtd.add(qtd);
  // replace by frags
  HashMap<String, String> frags_map = new HashMap<String, String>();
  for (int i=0; i<frags.size(); i++) {
    boolean subs = false;
    if (frags_qtd.get(i) > 1) {
      for (int j=0; j<blocks_color.size(); j++) {
        if (blocks_color.get(j).equals(frags.get(i))) {
          String variable = "_"+cicov_encript(i,false);
          frags_map.put(blocks_color.get(j), variable);
          blocks_color.set(j, variable);
        }
      }
    }
  }
  // define variables
  aux+=init;
  for (int i=0; i<frags_map.size(); i++) {
    aux += frags_map.get(frags.get(i))+frags.get(i);
  }
  aux+="<";
  // put replaced
  for (int i=0; i<blocks_color.size(); i++) {
    if ((i+1)%28==0 && jumpLines) aux+="\n";
    if (blocks_qtd.get(i) != 1) {
      aux += blocks_color.get(i)+"."+blocks_qtd.get(i);
    } else {
      aux += blocks_color.get(i);
    }
    // if (i != blocks_color.size()-1) aux+="-";
  }
  //
  progress=-1;
  println("Compressing to CICOV ... done!");
  return aux;
}
PImage convertFromCICOV(String buffer) {
  // 7x8<-15198184.21-6261564-6261597-10938344-15198184.11-9089902.4-9088639-12380136
  //-15198184.2-14932623-10272661-13166056-12629870
  //-10938344-15198184-15198129-9738556-6261564-7716801-12629870-10938344>
  int wid = int(split(split(buffer, "<")[0], ":")[0]);
  int hei = int(split(split(buffer, "<")[0], ":")[1]);
  println("Processing cicov "+wid+"x"+hei+" ... ");
  // read variables definitions
  String[] blocks_variables = split(split(buffer, "<")[1], "_");
  HashMap<String, Integer> variables = new HashMap<String, Integer>();
  for (int i=0; i<blocks_variables.length; i++) {
    // 0 h7d  _1 -yeo
    if (blocks_variables[i].equals("")) continue;
    String vari = "_"+split(blocks_variables[i], "-")[0];
    int number = int(cicov_decript("-" + split(blocks_variables[i], "-")[1]));
    variables.put(vari,number);
  }
  //
  PImage img_ = createImage(wid, hei, ARGB);
  img_.loadPixels();
  List<String> blks = Arrays.asList(split(buffer, "<")[2].split("-"));
  // dis-blocks
  List<String> ds_blks = new ArrayList<String>();
  // 15198184.21 6261564
  // println(blks);
  for (int i = 1; i < blks.size(); i++) {
    if (blks.get(i).contains(".")) {
      String[] aux = split(blks.get(i), ".");
      String val = aux[0];
      int qtd = int(aux[1]);
      for (int j = 0; j < qtd; j++) {
        ds_blks.add(val);
      }
    } else {
      ds_blks.add(blks.get(i));
    }
  }
  // println(ds_blks.size());
  // put
  for (int i = 0; i < wid*hei; i++) {
    boolean isVariable = false;
    for (String key : variables.keySet()) {
      if (ds_blks.get(i).equals(key)) {
        img_.pixels[i] = variables.get(key);
        isVariable = true;
        break;
      }
    }
    if (!isVariable) img_.pixels[i] = -int(cicov_decript(ds_blks.get(i)));
    progress = (float(i)/float(ds_blks.size()-1))*100.0;
  }
  //
  progress=-1;
  img_.updatePixels();
  println("Processing cicov ... done!");
  return img_;
}
