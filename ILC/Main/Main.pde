
ArrayList<int[]> ls = new ArrayList<int[]>();
ArrayList<int[]> new_ls = new ArrayList<int[]>();
int t = 0;
float tam = 10;


void setup() {
  int[] a = {0,0};
  ls.add(a);
  new_ls.add(a);
  size(800,800);
}

void draw() {
  background(128);
  text("t: " + t,20,20);
  //
  formIt();
  showAll();
  println(ls.size()+" "+t);
//   delay(200);
}

void formIt(){
	t++;
	int s1=2,s2=3;
	ArrayList<int[]> ns = new ArrayList<int[]>();
	for (int[] v : new_ls){
		int[] k = new int[]{v[0]+s1,v[1]+s2};
		boolean doIt = true;
		// for (int[] v2 : ls){
		// 	if (v2[0] == k[0] && v2[1] == k[1]){
		// 		doIt = false;
		// 		break;
		// 	}
		// }
		for (int[] v2 : ns){
			if (v2[0] == k[0] && v2[1] == k[1]){
				doIt = false;
				break;
			}
		}
		if (doIt) ns.add(k);
		// //
		k = new int[]{v[0]+s2,v[1]+s1};
		doIt = true;
		// for (int[] v2 : ls){
		// 	if (v2[0] == k[0] && v2[1] == k[1]){
		// 		doIt = false;
		// 		break;
		// 	}
		// }
		for (int[] v2 : ns){
			if (v2[0] == k[0] && v2[1] == k[1]){
				doIt = false;
				break;
			}
		}
		if (doIt) ns.add(k);
		//
	}
	new_ls.clear();
	for (int[] v : ns){
		ls.add(v);
	}
	for (int[] v : ns){
		new_ls.add(v);
	}
	
}

void showAll(){
	float ceil=25,here=0;
	for (int[] v : ls){
		fill(255,0,0);
		circle(tam+v[0]*tam,height-tam-v[1]*tam,tam);
		here = (here>tam+v[0]*tam)?here:tam+v[0]*tam;
	}
	if (here+tam*2>width) tam /=2;
}
