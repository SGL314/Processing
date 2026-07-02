class Inventory{
	LinkedHashMap<Material,Float> materials = new LinkedHashMap<Material,Float>();
	Inventory() {}
	
	void initialItems() {
		materials.put(Cfg.getMaterial("metal"),1000f);
		materials.put(Cfg.getMaterial("aluminium"),1000f);
		materials.put(Cfg.getMaterial("titanium"),1000f);
	}
	
	void add(Material mat,float qtd) {
		if (materials.containsKey(mat)) {
			materials.put(mat,materials.get(mat) + qtd);
		} else {
			materials.put(mat,qtd);
		}
	}
	
	Material getMaterial(String matId) {
		for (Material mat : materials.keySet()) {
			if (mat.id.equals(matId)) return mat;
		}
		return null;
	}
	Float getQtdMaterial(Material mat) {
		return materials.get(mat);
	}
}