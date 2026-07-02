import java.nio.file.Files;
import java.nio.file.Path;

import java.util.*;

class Configuration {
	
  boolean showPosition = false;
  boolean running = true;
  boolean usingConstructions = false;
  Menu menu_putting = null;
  private HashMap<String, Integer> colors = new HashMap<String, Integer>();
  private ArrayList<Material> materials = new ArrayList<Material>();
  public ArrayList<Construction> prefabs = new ArrayList<Construction>();
  
  String localReal = "../../../OneDrive/Documentos/Scripts/ScriptsPde/Processing/Robodustry/";
  String file_prefabs = "prefabs.txt",file_saving = "save.txt",file_materials = "materials.txt";
  String[] allMaterials = new String[0];
  
  Configuration() {
    _loadMaterials();
    defineColors();
    defineMaterials();
    readPreFabs();
  }
  public void save() {
    try{
      String aux = "";
      for (Construction cons : constructions) {
        aux += cons.getStringOfMe() + "\n";
      }
      Files.writeString(Path.of(localReal + file_saving), aux);
      println("SALVO !");
    } catch(Exception e) {
      println("ERRO ao salvar:\n\n" + e);
    }
  }
  public void loadAll() {
    _loadFabriquè();
  }
  private void _loadMaterials() {
    try{
      List<String> red = Files.readAllLines(Path.of(localReal + file_materials));
      allMaterials = new String[red.size()];
      int i = 0;
      for (String str : red.toArray(new String[0])) {
				if (line.isEmpty()) return null;
        if (str.charAt(0) == '#') break;
        if (str.charAt(0) == '/') continue;
        allMaterials[i] = str;
        i++;
      }
    } catch(Exception e) {
      println("ERRO ao ler materials.txt:\n\n" + e);
    }
  }
  private void _loadFabriquè() {
    try{
      List<String> red = Files.readAllLines(Path.of(localReal + file_saving));
      ArrayList<Construction> conss = splitter(red);
      for (Construction cons : conss) {
        constructions.add(cons);
      }
    } catch(Exception e) {
      println("ERRO ao ler save.txt:\n\n" + e);
    }
  }
  public void preProcessSaving(String type, Construction cons) {
    _preProcessSaving(type,cons);
  }
  private void _preProcessSaving(String type,Construction cons) {
    while(usingConstructions) {
      sleep(10);
    }
    switch(type) {
      case "addInConstructions":
        constructions.add(cons);
        break;
      case "removeFromConstructions":
        for (Construction c : constructions) {
          if (c.specificId.equals(cons.specificId)) {
            c.disconnectAll();
            constructions.remove(c);
            break;
          }
        }
        break;
      default:
      println("ERRO ao processar type of command in _preProcessSaving:\n   type nao reconhecido: '" + type + "'");
    }
    save();
  }
  //PRIVATE
  private ArrayList<Construction> splitter(List<String> red) {
    ArrayList<Construction> conss = new ArrayList<Construction>();
    LinkedHashMap<String,ArrayList<String>> pos_connects = new LinkedHashMap<>();
    int numberLine = 0;
    try{
      for (String line : red) {
        numberLine ++;
        String[] parts = line.split(";");
        Construction cons = null;
        // P;Connector;connector;metal;tam;px;py;metal,10_aluminium,4;
        // specificId;id_id_id/---;modusLin.;effect.ModusLin.;istypeofpipe;
        switch(parts[0]) {
          case"P":
          // String name,String id,float tam,Material material, float px,float py,LinkedHashMap<Material,Float> materials
          LinkedHashMap<Material,Float> mats = new LinkedHashMap<Material,Float>();
          String[] aux = parts[7].split("_");
          for (int i = 0;i < aux.length; i++) {
            Material mat = this.getMaterial(aux[i].split(",")[0]).copy();
            if (mat != null) {
              mats.put(mat,Float.parseFloat(aux[i].split(",")[1]));
            } else{
              println("ERRO ao processar prefab:\n   material nao reconhecido: '" + aux[i] + "' in line " + numberLine);
            }
          }
          cons = new Piece(parts[1],parts[2],Float.parseFloat(parts[4]),getMaterial(parts[3]),Float.parseFloat(parts[5]),Float.parseFloat(parts[6]),mats);
          cons.specificId = parts[8];
          
          cons.modusLinearis = parts[10].equals("true");
          cons.effectiveModusLinearis = parts[11].equals("true");
          cons.isTypeOfPipe = parts[12].equals("true");
          // connects
          pos_connects.put(parts[8],new ArrayList<String>());
          if (!parts[9].equals("---")) {
            aux = parts[9].split("_");
            for (String str : aux) {
              pos_connects.get(parts[8]).add(str);
            }
          }
          break;
          default:
          println("ERRO ao processar construction:\n   type of construction nao reconhecido: '" + parts[0] + "'");
          return null;
        }
        conss.add(cons);
      }
    } catch(Exception e) {
      println("ERRO ao processar prefab 1:\n   " + e);
    }
    // put connects
    try{
      for (String key : pos_connects.keySet()) {
        for (Construction c1 : conss) {
          if (c1.specificId.equals(key)) {
            for (String str : pos_connects.get(key)) {
              for (Construction c2 : conss) {
                if (c2.specificId.equals(str)) {
                  c1.connections.add(c2);
                  // println(c1.specificId + " -> " + c2.specificId);
                }
              }
            }
            if (c1.isTypeOfPipe) {
              // println(c1.specificId + " " + c1.connections.size());
              c1.effectiveModusLinearis();
            }
            // println(c1.getStringOfMe());
          }
        }
      }
    } catch(Exception e) {
      println("ERRO ao processar prefab 2:\n   " + e);
    }
    //
    return conss;
  }
  private void readPreFabs() {
    List<String> red;
    Construction prefab;
    try{
      red   = Files.readAllLines(Path.of(localReal + file_prefabs));
      //  Files.writeString(Path.of(localReal + file_prefabs), "Olá");
      for  (String line : red) {
        prefab = process(line);
        if  (prefab != null) {
          //  println(prefab);
          prefabs.add(prefab);
        }
      }
    }   catch(Exception e) {
      println("ERRO ao ler prefabs:\n\n" + e);
    }
    
  }
  private  Construction process(String line) {
		if  (line.isEmpty()) return null;
    if  (line.charAt(0) == '/') return null;
    Construction cons = disformatter(line);
    //  println(cons.name);
    return  cons;
  }
  private  Construction disformatter(String form) {
    ArrayList<String> formatter = new ArrayList<String>();
    LinkedHashMap<Material,Float> mats = new LinkedHashMap<Material,Float>();;
    String  name,id;Material material;
    float  px,py;
    String[]  parts = form.split(";");
    for  (String part : parts) {
      formatter.add(part);
    }
    //  associate
    //  P;Connector;connector;metal;init;0;0;metal,10 + aluminium,4
    name   =   formatter.get(1);
    id   =   formatter.get(2);
    material   =   this.getMaterial(formatter.get(3));
    //  println(formatter.get(3) + " " + material);
    float  tam   =   100;
    //  defining  tam
    switch(formatter.get(4)) {
      case  "init":
      tam   =   initialTamSquare;
      break;
      case  "init/2":
      tam   =   initialTamSquare / 2;
      break;
      case  "tamSquare":
      tam   =   tamSquare;
      break;
      default:
      tam   =   Float.parseFloat(formatter.get(4));
      break;
    }
    px   =   Float.parseFloat(formatter.get(5));
    py   =   Float.parseFloat(formatter.get(6));
    
    //  forma  materials
    String[]  aux   = formatter.get(7).split("_");
    for  (int  i   =   0;i < aux.length; i++) {
      Material  mat = this.getMaterial(aux[i].split(",")[0]);
      if  (mat  !=   null) {
        mats.put(mat,Float.parseFloat(aux[i].split(",")[1]));
        
      }   else{
        println("ERRO ao processar prefab:\n   material nao reconhecido: '" + aux[i] + "' in:\n'" + form + "'");
      }
    }
    //  type
    switch(formatter.get(0)) {
      case  "P":
      //  println(material.name);
      return  new  Piece(name,id,tam,material,px,py,mats);
      default:
      println("ERRO ao processar prefab : \n   type nao reconhecido : '" + form + "'");
    }
    return  null;
  }
  //  COLORS
  color  getColor(String name) {
    if (colors.containsKey(name)) return colors.get(name);
    else return color(0,0,0);
  }
  private  void  defineColors() {
    colors.put("metal",#027EAA);
    colors.put("aluminium",#D8D8D6);
    colors.put("titanium",#4D6CFF);
  }
  //  MATERIALS
  private  void  defineMaterials() {
    for  (String  material : allMaterials) {
      if (material==null) continue;
      // println(Character.toUpperCase(material.charAt(0)) + material.substring(1));
      materials.add(new Material(Character.toUpperCase(material.charAt(0)) + material.substring(1),material,getColor(material)));
    }
  }
  Material getMaterial(String id) {
    // put copy
    for  (Material  material : materials) {
      if  (material.id.equals(id)) return material.copy();
    }
    return  null;
  }
}
