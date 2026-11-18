
class Engine {
  static int qtAnts, qtFoods, qtSourceFoods;

  // static void putEstatistics(string type, GameObject* th) {
  //   if (type=="ant") {
  //     qtAnts++;
  //   } else if (type=="food") {
  //     qtFoods+=((Food*)th)->food;
  //     qtSourceFoods++;
  //   }
  // }
  static void putEstatistics(Ant* th) {
    qtAnts++;
  }
  static void putEstatistics(Food* th) {
    qtFoods+=th->food;
    qtSourceFoods++;
  }
}

int Engine::qtAnts = 0;
int Engine::qtFoods = 0;
int Engine::qtSourceFoods = 0;
