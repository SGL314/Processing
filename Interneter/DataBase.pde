import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;

import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.IOException;
import java.util.HashMap; // Importação necessária
import java.util.List; // Importação necessária
import java.io.Serializable;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;

class DataBase {
  String path = "C:/Users/samug/OneDrive/Documentos/Scripts/ScriptsPde/Processing/Interneter/data/";
  String localComponents = "components.txt",
  localEnergysComponents = "energysComponents.txt";
  boolean formingClasss;

  void getAll() {
    formingClasss = true;
    try {
      getComponents();
      getEnergysComponents();
      assocItens();
    }
    catch(IOException e) {
      println(e);
    }
    formingClasss = false;
  }
  void saveAll() {
    try {
      saveComponents();
      saveEnergysComponents();
      println("Tudo salvo com sucesso !");
    }
    catch(IOException e) {
      println(e);
    }
  }
  
  // SAVING
  private void saveComponents() throws IOException {
    FileWriter fw = new FileWriter(path + localComponents);
    for (Component comp : components) {
      if (comp.name=="connector"||comp.name=="wire") continue;
      fw.write(comp.toString() + "\n");
    }
    fw.close();
  }
  private void saveEnergysComponents() throws IOException {
    FileWriter fw = new FileWriter(path + localEnergysComponents);
    for (Component comp : components) {
      if (comp.name!="connector"&&comp.name!="wire") continue;
      fw.write(comp.toString() + "\n");
    }
    fw.close();
  }

  // GETTING
  private void getComponents() throws IOException {
    FileReader fr = new FileReader(path + localComponents);
    int posLine = 1;
    List<String> red = Files.readAllLines(Path.of(path + localComponents));
    for (String line : red) {
      String[] split = line.split(";");
      switch (split[0]) {
        case "memory":
          components.add(
            new Memory(split[1],
            Integer.parseInt(split[2]),Float.parseFloat(split[3]),
            Float.parseFloat(split[4])));
          break;
        case "source-energy":
          components.add(new SourceEnergy(split[1],
            Integer.parseInt(split[2]),Float.parseFloat(split[3]),
            Float.parseFloat(split[4]))
          );
          break;
        default:
          println("Componente '" + split[0] + "' nao encontrado na linha "+ posLine);
      }
      posLine++;
    }
    fr.close();
  }
  private void getEnergysComponents() throws IOException {
    int posLine = 1;
    List<String> red = Files.readAllLines(Path.of(path + localEnergysComponents));
    for (String line : red) {
      String[] split = line.split(";");
      String name = split[0].split("_")[0];
      Component comp = null;
      switch (name) {
        case "wire":
            comp = new Wire(split[1],Float.parseFloat(split[2]),
            Integer.parseInt(split[3]),Float.parseFloat(split[4]),
            Float.parseFloat(split[5]));
          break;
        case "connector":
        // connector;1;2.0;1;425.0;410.0
          comp = new Connector(split[1],Float.parseFloat(split[2]),
            Integer.parseInt(split[3]),Float.parseFloat(split[4]),
            Float.parseFloat(split[5]));
          break;
        default:
          println("Componente '" + split[0] + "' nao encontrado na linha "+ posLine);
      }
      comp.id = split[0];
      components.add(comp);
      posLine++;
    }
  }

}
