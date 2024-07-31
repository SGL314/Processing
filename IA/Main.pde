int qt_persons = 100;
int qt_pocos = 3;
int profTerreno = 200;
int posFuncUsingPersons = 1;
boolean runningDownPersons = false;
Person lastDied = null;
Object objectSelected = null;
int geration = 1;
int pop = 100;

Control controle = new Control();
boolean runThreads = true;

ArrayList<Person> Persons = new ArrayList<Person>();
ArrayList<Poco> Pocos = new ArrayList<Poco>();

void setup(){
    size(1400,800);
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
    logic();
    mouse();
    texts();
}

void ambiente(){
    background(#7CC1D3);
    fill(#522E0B);
    rect(0,height-profTerreno,width,profTerreno);
}

void objects(){
    int dist = 50;
    for (Person person : Persons){
        if (person.died) continue;
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

void logic(){
    if (pop == 0 || pop == 1){
        controle.runThreads = false;
        runThreads = false;
        print("Strange");
        while (controle.runningDownPersons || controle.runningLiving){
           print("");
        }
        print("hhhh");
        ArrayList<Person> add = new ArrayList<Person>();
        for (Person person : Persons){
            if (!(person.died)) add.add(person);
        }
        Persons = new ArrayList<Person>();
        for (Person p1 : add){
            Persons.add(p1);
        }
        lastDied.life += 3;
        lastDied.water += 3;
        Persons.add(lastDied);
        //add
        int i = 1;
        if (pop == 0)
        while (i<= qt_persons-1){
            Persons.add(new Person(lastDied));
            i++;
        }
        else
        while (i<= qt_persons-2){
            Persons.add(new Person(lastDied));
            i++;
        }
        //embaralha
        for (Person person : Persons){
            person.died = false;
            person.px = (int) random(width);
            person.py = height-profTerreno;
        }
        //print
        print(":> ");
        for (float coe : lastDied.coes){
            print(coe+" ");
        }
        print("\n");
        geration++;
        pop = qt_persons;
        controle.runThreads = true;
        controle.re_runThreads();
        print("reset");
        posFuncUsingPersons = 1;
        // delay(2000);
    }
}

void texts(){
    String texto = "rt: "+runThreads+"\nRunningAll: "+controle.runningAllThreads()+"\nRunThreads: "+controle.runThreads+"\nRunningAny: "+controle.runningAnyThreads()+"\nGeration "+geration+"\nPop.: ";
    int  qt = 0;
    for (Person person : Persons){
        if (person.died == false) qt++;
    }
    pop = qt;
    texto += ""+pop;
    
    textSize(50);
    text(texto,25,40);
    textSize(12.5f);
}

void downPersons(){
    controle.runningDownPersons = true;
    while (controle.runThreads){
        runningDownPersons = false;
        if (Persons.size() >= 1 && posFuncUsingPersons == 1){
            runningDownPersons = true;
            for (Person person : Persons){
                if (person.died) continue;
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
    println("out_dp");
    controle.runningDownPersons = false;
    println(controle.runningDownPersons);
}

void living(){
    controle.runningLiving = true;
    while (controle.runThreads){
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
                        p2.died = true;
                        lastDied = p2;
                        break;
                    }
                }
            }
        }
        posFuncUsingPersons = 1;
        delay(1000);
        posFuncUsingPersons = 2;
    }
    println("out_lv");
    controle.runningLiving = false;
}

void mousePressed(){
    for (Poco poco : Pocos){
        if (poco.px-poco.largura/2<= mouseX && mouseX <= poco.px+poco.largura/2){
            if (poco!=objectSelected) objectSelected = poco;
            else objectSelected = null;
            return;
        }
    }
    for (Person person : Persons){
        if (person.px-person.largura/2<= mouseX && mouseX <= person.px+person.largura/2){
            if (person!=objectSelected) objectSelected = person;
            else objectSelected = null;
            return;
        }
    }
}

void mouse(){
    if (objectSelected != null){
        objectSelected.px = mouseX;
    }
}
