class Inventory{
	LinkedHashMap<String,Float> materials = new LinkedHashMap<String,Float>();
	public HashMap<String,Boolean> dislockedMaterials = new HashMap<String,Boolean>();
	
	Inventory() {
		for (Material mat : Cfg.materials) {
			materials.put(mat.id,0f);
			// println(mat.id);
			dislockedMaterials.put(mat.id,false);
		}
		// dislockedMaterials.add("aluminium");
	}
	
	void initialItems() {
		this.add("metal",1000f);
		this.add("aluminium",1000f);
	}
	
	void add(String mat,float qtd) {
		if (materials.containsKey(mat)) {
			materials.put(mat,materials.get(mat) + qtd);
		} else {
			materials.put(mat,qtd);
		}
	}
	
	Material getMaterial(String matId) {
		for (String mat : materials.keySet()) {
			if (mat.equals(matId)) return Cfg.getMaterial(mat);
		}
		return null;
	}
	Float getQtdMaterial(String mat) {
		return materials.get(mat);
	}
	// MATERIALS FOR CONSTRUCTION
	boolean removeMaterialsForConstruction(Construction cons) {
		for (Material mat : cons.materials.keySet()) {
			float qtd = cons.materials.get(mat);
			if (!materials.containsKey(mat.id)) return false;
			if (materials.get(mat.id) < qtd) return false;
		}
		for (Material mat : cons.materials.keySet()) {
			float qtd = cons.materials.get(mat);
			materials.put(mat.id,materials.get(mat.id) - qtd);
		}
		return true;
	}
	boolean addMaterialsForConstruction(Construction cons) {
		// for (Material mat : cons.materials.keySet()) {
		// 	float qtd = cons.materials.get(mat);
		// 	if (!materials.containsKey(mat)) return false;
		// 	if (materials.get(mat) < qtd) return false;
		// }
		// colocar o catch pra colocar materiais q n foram catalogados ainda
		for (Material mat : cons.materials.keySet()) {
			float qtd = cons.materials.get(mat);
			materials.put(mat.id,materials.get(mat.id) + qtd);
		}
		return true;
	}
}