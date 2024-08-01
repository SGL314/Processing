class Fazenda extends Object{
    float
    larguraTerreno = 25,
    larguraCasa = 20,
    alturaCasa = 10,
    alturaTelhado = 5,
    alturaPlantacao = 3;

    Fazenda(int px){
        this.px = px;
        this.py = height-profTerreno;
    }

    void show(){
        //Pantacao
        fill(#E0D783);
        rect(px-this.larguraTerreno-this.larguraCasa/2,py-this.alturaPlantacao,this.larguraTerreno*2+this.larguraCasa,this.alturaPlantacao);
        //Cerca
        float largCerca = 3,
        altCerca = 6;
        fill(#6C3E0F);
        rect(px-this.larguraTerreno-this.larguraCasa/2-largCerca,py-altCerca,largCerca,altCerca);
        rect(px+this.larguraTerreno+this.larguraCasa/2,py-altCerca,largCerca,altCerca);
        //Telhado
        float tamCalha = 2;
        triangle(px-this.larguraCasa/2-tamCalha,py-this.alturaCasa,px+this.larguraCasa/2+tamCalha,py-this.alturaCasa,px,py-this.alturaCasa-this.alturaTelhado);
        //Casa
        fill(#D3A16F);
        rect(px-this.larguraCasa/2,py-this.alturaCasa,this.larguraCasa,this.alturaCasa);
        //Porta e Janelas
        fill(#000000);
        float largJanela = 4,
        altJanela = 4,
        altPorta = 7,
        largPorta = 4,
        distChaoJanela = 4,
        dist = 3;
        rect(px-largPorta/2-dist-largJanela,py-distChaoJanela-altJanela,largJanela,altJanela);
        rect(px-largPorta/2,py-altPorta,largPorta,altPorta);
        rect(px+largPorta/2+dist,py-distChaoJanela-altJanela,largJanela,altJanela);
    }
}