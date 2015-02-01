import processing.video.*;
Movie myMovie;

int x = 200;
int y = 400;

PFont f;
String message;

boolean addSnow = false;
boolean addBlur = false;
float maxSnowTheta = HALF_PI*4/5;



PGraphics treesLayer;
PGraphics btreesLayer;
PGraphics lettersLayer;
PGraphics testLayer;

Letter[] letters;
String[] words;
String[] words1;
String[] words2;

Path path, path1, path2, path3;

float scalar = 1.2;


ArrayList<Vehicle> vehicles;
ArrayList<Vehicle> vehicles1;
ArrayList<Vehicle> vehicles2;
ArrayList<Vehicle> vehicles3;



int windCycle = 200;
float minBurstRatio = 0.25;
float maxBurstRation = 0.2;

float tilt = 0.1;
float angle = 0;

PFont f1, f2, f3, f4, f5;

Trees btrees;

void setup() {
  f1 = createFont("FX_Dakar-Light", 20, true);
  f2 = createFont("FX_HadasaNewBook-Light", 20, true);
  f3 = createFont("FX_Optimum-Light", 20, true);
  f4 = createFont("FX_YamHamelach-Regular", 20, true);
  f5 = createFont("FX_Zaafran-Light", 20, true);

  btrees = new Trees();

  textFont(f3);
  String lines[] = loadStrings("poem.txt");
  String lines1[] = loadStrings("poem1.txt");
  String lines2[] = loadStrings("poem2.txt");
  String lines3[] = loadStrings("poem3.txt");
  size(921, 691);
  myMovie = new Movie(this, "wind2.mov");
  myMovie.loop();

  treesLayer = createGraphics(width, height);
  btreesLayer = createGraphics(width, height);
  lettersLayer = createGraphics(width, height);

  newPath();
  newPath1();
  newPath2();
  newPath3();

  vehicles = new ArrayList<Vehicle>();
  int txtSize = 12;
  for (int i = 0; i < lines.length; i++) {
    newVehicle(-200+i*20, 200, lines[i],vehicles, txtSize + int(random(4)));
  }

  vehicles1 = new ArrayList<Vehicle>();
  for (int i = 0; i < lines1.length; i++) {
    newVehicle(-200+i*20, 200, lines1[i],vehicles1, txtSize + int(random(4)));
  }

  vehicles2 = new ArrayList<Vehicle>();
  for (int i = 0; i < lines2.length; i++) {
    newVehicle(width-400+i*20, 0, lines2[i],vehicles2, txtSize + int(random(4)));
  }

  vehicles3 = new ArrayList<Vehicle>();
  for (int i = 0; i < lines3.length; i++) {
    newVehicle(-200+i*20, 100, lines3[i],vehicles3, txtSize + int(random(-1,4)));
  }

  frameRate(30);
}

void draw() {
  image(myMovie, 0, 0);

//  text(frameCount, 30, 30);

  if (frameCount%350==0 || frameCount==0) {
    btrees.newTrees();
  }

  if (frameCount%500==0) {
    btrees.removeTrees();
  }


  wobble();


  btreesLayer.beginDraw();
  btreesLayer.background(255, 0);
  //  btreesLayer.fill(0);
  btrees.cleanUpDeadTrees();
  btrees.draw();
  btreesLayer.endDraw();

  //  image(treesLayer, 0, 0);


  image(btreesLayer, 0, 0);


  for (Vehicle v : vehicles) {
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles, path);
    // Call the generic run method (update, borders, display, etc.)
    v.run();
  }

  for (Vehicle v : vehicles1) {
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles1, path1);
    // Call the generic run method (update, borders, display, etc.)
    v.run();
  }

  for (Vehicle v : vehicles2) {
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles2, path2);
    // Call the generic run method (update, borders, display, etc.)
    v.run();
  }

  for (Vehicle v : vehicles3) {
    // Path following and separation are worked on in this function
    v.applyBehaviors(vehicles3, path3);
    // Call the generic run method (update, borders, display, etc.)
    v.run();
  }

}



void wobble() {
  tilt = cos(angle) / 4;
  if (isWindStrong()) {
    angle += 2;
  } else {
    angle += 0.2;
  }
}

void drivingSpeed() {
}

boolean isWindStrong() {
  int mFrameCount = frameCount%120;
  if (mousePressed || (mFrameCount>=0 && mFrameCount<30)) {
    return true;
  } else {
    return false;
  }
}

void newVehicle(float x, float y, String word, ArrayList<Vehicle> vs, int txtSize) {
  float maxspeed = 0.8;
  float maxforce = 0.2;
  vs.add(new Vehicle(new PVector(x, y), maxspeed, maxforce, word,txtSize));
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

void newPath1() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path1 = new Path();
  float offset = 10;
  path1.addPoint(-300, height-300);  
  path1.addPoint(50, height-300);
  path1.addPoint(80, height-270);
  path1.addPoint(120, height-220);
  path1.addPoint(180, height-190);
  path1.addPoint(280, height-100);
  path1.addPoint(width-100, height);  
  path1.addPoint(width+100, height);
  path1.addPoint(width+100, height+100);
  path1.addPoint(-100, height+100);
  //  path.addPoint(offset,height-offset);
}

void newPath2() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path2 = new Path();
  float offset = 10;
//  path2.addPoint(width-300, -300);  
  path2.addPoint(width-300, 0);
  path2.addPoint(width-280, height-400);
  path2.addPoint(width-250, height-220);
  path2.addPoint(width-200, height-190);
  path2.addPoint(width-160, height-100);
  path2.addPoint(width-100, height-80);  
  path2.addPoint(width+100, height-80);
  path2.addPoint(width+100, -100);
  //  path.addPoint(offset,height-offset);
}

void newPath3() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  path3 = new Path();
  float offset = 10;
//  path2.addPoint(width-300, -300);  
  path3.addPoint(-200, 100);
  path3.addPoint(0, 100);
  path3.addPoint(50, 120);
  path3.addPoint(100, 130);
  path3.addPoint(260, 110);
  path3.addPoint(300, 80);  
  path3.addPoint(550, -80);
  path3.addPoint(-200, -100);
  //  path.addPoint(offset,height-offset);
}


// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}

int randomSign() { //returns +1 or -1
  float num = random(-1, 1);
  if (num==0)
    return -1;
  else
    return (int)(num/abs(num));
}


//void mouseDragged() {
//  flock.addBoid(new Boid(mouseX,mouseY,"ffff"));
//}

void mousePressed() {
  angle += 2;
}

