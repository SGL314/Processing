class Matrix{
	String name;
	Item[][] matrix;
	int tam;

	Matrix(String name,Item[][] arraylist){
		this.name = name;
		matrix = arraylist;
		this.tam = arraylist.length;
	}

	void show(int loop){
		for (int i=0;i<matrix.length;i++){
			for (int j=0;j<matrix[i].length;j++){
				matrix[i][j].show(loop);
			}
		}
	}

	void log(){
		for (int i=0;i<matrix.length;i++){
			for (int j=0;j<matrix[i].length;j++){
				Item item = matrix[i][j];
				matrix[(i-1)%tam][j].flowHeat(item); // up
				matrix[(i+1)%tam][j].flowHeat(item); // down
				matrix[i][(j-1)%tam].flowHeat(item); // left
				matrix[i][(j+1)%tam].flowHeat(item); // right
			}
		}
	}
}