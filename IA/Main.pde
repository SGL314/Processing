int qt_persons = 10;
int qt_pocos = 3;
int profTerreno = 200;
int posFuncUsingPersons = 1;
boolean runningDownPersons = false;

ArrayList<Person> Persons = new ArrayList<Person>();
ArrayList<Poco> Pocos = new ArrayList<Poco>();

void setup(){
    size(800,800);
    createPersons();
    createPocos();
    thread("downPersons");
    thread("living");
}

void createPersons(){
    int i = 1;
    while (i<= qt_persons){
        Persons.add(new Person("aleatr"));
        i++;
    }
}
void createPocos(){
    int i = 1;
    while (i<= qt_pocos){
        Pocos.add(new Poco((int) random(width)));
        i++;
    }
}

void draw(){
    ambiente();
    objects();
}

void ambiente(){
    background(#7CC1D3);
    fill(#522E0B);
    rect(0,width-profTerreno,width,profTerreno);
}

void objects(){
    int dist = 50;
    for (Person person : Persons){
        person.move();
        person.show();
        for (Poco poco : Pocos){
            if (person.px > poco.px-dist && person.px < poco.px+dist){
                person.water += person.consumWater/frameRate;
            }
        }
    }

    for (Poco poco : Pocos){
        poco.show();
    }
}

void downPersons(){
    while (true){
        runningDownPersons = false;
        if (Persons.size() >= 1 && posFuncUsingPersons == 1){
            runningDownPersons = true;
            for (Person person : Persons){
                if (person.py > height-profTerreno){
                    person.py -= 0.5;
                }
                if (person.py < height-profTerreno){
                    person.py += 0.5;
                }
                if (person.px > width){
                    person.px -= 1;
                }
                if (person.px < 0){
                    person.px += 1;
                }

            }
            

        }
        runningDownPersons = false;
        delay(16);
    }
}

void living(){
    while (true){
        ArrayList<Person> removePersons = new ArrayList<Person>();
        if (Persons.size() >= 1 && posFuncUsingPersons == 2 && runningDownPersons == false){
            for (Person person : Persons){
                person.live();
                if (person.life <= 0){
                    removePersons.add(person);
                }
            }
            for (Person p1 : removePersons){
                for (Person p2 : Persons){
                    if (p1 == p2){
                        Persons.remove(p2);
                        break;
                    }
                }
            }
        }
        posFuncUsingPersons = 1;
        delay(1000);
        posFuncUsingPersons = 2;
    }
}
