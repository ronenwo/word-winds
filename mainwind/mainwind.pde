import processing.video.*;
Movie myMovie;

int x = 200;
int y = 400;

PFont f;
String message;

boolean addSnow = false;
boolean addBlur = false;
float maxSnowTheta = HALF_PI*4/5;

int nTrees = 2;
color backgroundCol = color(200);
//initial tree properties.
float branchWidthInit;
float totalBranchLengthInit;
int nBranchDivisionsInit;
float percentBranchlessInit;
float branchSizeFractionInit;
float dThetaGrowMaxInit;
float dThetaSplitMaxInit; 
float oddsOfBranchingInit;


PGraphics treesLayer;
PGraphics lettersLayer;
PGraphics testLayer;

Letter[] letters;
String[] words;

Path path;

float tilt = 0.1;
float scalar = 1.2;
float angle;


ArrayList<Vehicle> vehicles;
ArrayList<mytree> mytrees = new ArrayList<mytree>();


int windCycle = 200;
float minBurstRatio = 0.25;
float maxBurstRation = 0.2;

PFont f1, f2, f3, f4, f5;

void setup() {
  f1 = createFont("FX_Dakar-Light", 20, true);
  f2 = createFont("FX_HadasaNewBook-Light", 20, true);
  f3 = createFont("FX_Optimum-Light", 20, true);
  f4 = createFont("FX_YamHamelach-Regular", 20, true);
  f5 = createFont("FX_Zaafran-Light", 20, true);

  textFont(f3);
  String lines[] = loadStrings("poem.txt");
  size(921, 691);
  myMovie = new Movie(this, "wind2.mov");
  myMovie.loop();

  words = split(lines[0], " ");
  background(backgroundCol);
  treesLayer = createGraphics(width, height);
  lettersLayer = createGraphics(width, height);
  testLayer = createGraphics(width, height);

//  newTrees();

  newPath();

  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < lines.length; i++) {
    newVehicle(-200+i*20, 200, lines[i]);
  }

  frameRate(30);
}

void draw() {
  image(myMovie, 0, 0);

  if (frameCount%200==0 || frameCount==0) {
    mytrees.add(new mytree());
  }


  treesLayer.beginDraw();
  treesLayer.background(255, 0);
  treesLayer.fill(0);

  for (mytree t : mytrees) {
    t.draw();
  }
  treesLayer.endDraw();

  image(treesLayer, 0, 0);

  for (Vehicle v : vehicles) {
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles, path);
    // Call the generic run method (update, borders, display, etc.)
    v.run();
  }
}


void newVehicle(float x, float y, String word) {
  float maxspeed = 0.8;
  float maxforce = 0.2;
  vehicles.add(new Vehicle(new PVector(x, y), maxspeed, maxforce, word));
}


void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path = new Path();
  float offset = 10;
  path.addPoint(-100, 200);  
  path.addPoint(50, 200);
  path.addPoint(80, 210);
  path.addPoint(120, 220);
  path.addPoint(180, 230);
  path.addPoint(280, 240);
  path.addPoint(width-80, 270);  
  path.addPoint(width+100, 250);
  path.addPoint(width+100, height+100);
  path.addPoint(-100, height+100);
  //  path.addPoint(offset,height-offset);
}


//void mouseDragged() {
//  flock.addBoid(new Boid(mouseX,mouseY,"ffff"));
//}

void mousePressed() {
}



void buildWord() {
  for (int i = 0; i < message.length (); i ++ ) {
    // Letter objects are initialized with their location within the String as well as what character they should display.
    letters[i] = new Letter(x, y, message.charAt(i)); 
    x += textWidth(message.charAt(i));
  }
}

void showWord() {
  lettersLayer.beginDraw();
  for (int i = 0; i < letters.length; i ++ ) {
    // Display all letters
    letters[i].display();
  }  
  lettersLayer.endDraw();
}


// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}



void newTrees() {
  for (int i=0; i<nTrees; i++) {
    mytrees.add(new mytree());
  }
}



void blankScreen() {
  fill(backgroundCol);
  noStroke();
  rect(0, 0, width, height);
}

void fadeScreen() {
  fill(backgroundCol, 50);
  noStroke();
  rect(0, 0, width, height);
}


int randomSign() { //returns +1 or -1
  float num = random(-1, 1);
  if (num==0)
    return -1;
  else
    return (int)(num/abs(num));
}

