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
  String file_prefabs = "prefabs.txt", file_saving = "save.txt", file_materials = "materials.txt";
  String[] allMaterials = new String[0];

  Configuration() {
    //_loadMaterials();
    // defineColors();
    // defineMaterials();
    //readPreFabs();
  }
  // public void save() {
  //   try {
  //     String aux = "";
  //     for (Construction cons : constructions) {
  //       aux += cons.getStringOfMe() + "\n";
  //     }
  //     Files.writeString(Path.of(localReal + file_saving), aux);
  //     println("SALVO !");
  //   }
  //   catch(Exception e) {
  //     println("ERRO ao salvar:\n\n" + e);
  //   }
  // }
  // public void loadAll() {
  //   _loadFabriquè();
  // }
  // private void _loadMaterials() {
  //   try {
  //     List<String> red = Files.readAllLines(Path.of(localReal + file_materials));
  //     allMaterials = new String[red.size()];
  //     int i = 0;
  //     for (String str : red.toArray(new String[0])) {
  //       //if (red.toArray(new String[0]).isEmpty()) return null;
  //       if (str.charAt(0) == '#') break;
  //       if (str.charAt(0) == '/') continue;
  //       allMaterials[i] = str;
  //       i++;
  //     }
  //   }
  //   catch(Exception e) {
  //     println("ERRO ao ler materials.txt:\n\n" + e);
  //   }
  // }
  // private void _loadFabriquè() {
  //   try {
  //     List<String> red = Files.readAllLines(Path.of(localReal + file_saving));
  //     // ArrayList<Construction> conss = splitter(red);
  //     // for (Construction cons : conss) {
  //     //   constructions.add(cons);
  //     // }
  //   }
  //   catch(Exception e) {
  //     println("ERRO ao ler save.txt:\n\n" + e);
  //   }
  // }
  // public void preProcessSaving(String type, Construction cons) {
  //   _preProcessSaving(type, cons);
  // }
  // private void _preProcessSaving(String type, Construction cons) {
  //   while (usingConstructions) {
  //     for (float i=0;i<10e6;i++){}
  //   }
  //   switch(type) {
  //   case "addInConstructions":
  //     constructions.add(cons);
  //     break;
  //   case "removeFromConstructions":
  //     for (Construction c : constructions) {
  //       if (c.specificId.equals(cons.specificId)) {
  //         c.disconnectAll();
  //         constructions.remove(c);
  //         break;
  //       }
  //     }
  //     break;
  //   default:
  //     println("ERRO ao processar type of command in _preProcessSaving:\n	 type nao reconhecido: '" + type + "'");
  //   }
  //   //save();
  // }
  // //PRIVATE
  // //	COLORS
  // color	getColor(String name) {
  //   if (colors.containsKey(name)) return colors.get(name);
  //   else return color(0, 0, 0);
  // }
  // private	void	defineColors() {
  //   colors.put("metal", #027EAA);
  //   colors.put("aluminium", #D8D8D6);
  //   colors.put("titanium", #4D6CFF);
  // }
  // //	MATERIALS
  // private	void	defineMaterials() {
  //   for	(String	material : allMaterials) {
  //     if (material==null) continue;
  //     // println(Character.toUpperCase(material.charAt(0)) + material.substring(1));
  //     materials.add(new Material(Character.toUpperCase(material.charAt(0)) + material.substring(1), material, getColor(material)));
  //   }
  // }
  // Material getMaterial(String id) {
  //   // put copy
  //   for	(Material	material : materials) {
  //     if	(material.id.equals(id)) return material.copy();
  //   }
  //   return	null;
  // }
}
