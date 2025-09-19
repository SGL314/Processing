var things = [];

function setup(){
    createCanvas(800,800);
    defineThings();
}

function defineThings(){
    things.push(new City("Jerusalém",50,100,100))
}

function draw(){
    background("#0a0a0a");
    showThings();
}

function showThings(){
    for (var city in things){
        city.show();
    }
}














