// import java.util.HashMap; // Importação necessária

abstract class Phisics{
	HashMap<String,Float> items(String type){
		HashMap<String,Float> configs = new HashMap<String,Float>();
		configs.put("k_trans_heat",0f);
		//
		switch (type){
			case "air":
				configs.put("k_trans_heat",0.024f);
				break;
		}
		return configs;
	}
	//Q˙​=​​A⋅(T1​−T2​)​/(k1​/L1​​+k2/​L2)
	//Q=k⋅A⋅ΔT⋅t​/L
}
