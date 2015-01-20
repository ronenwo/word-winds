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
mytree[] trees;
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

void setup() {
  f = createFont("Arial", 20, true);
  textFont(f);
  String lines[] = loadStrings("poem.txt");
  size(921, 691);
  myMovie = new Movie(this, "wind2.mov");
  myMovie.loop();
  
  words = split(lines[0]," ");
  message = words[0];
  
  letters = new Letter[message.length()];
  buildWord();
  
    
  background(backgroundCol);
  treesLayer = createGraphics(width, height);
  lettersLayer = createGraphics(width, height);
  testLayer = createGraphics(width, height);
  
    newTrees();
}

void draw() {
  image(myMovie, 0, 0);

  boolean drawTrees = false;  
  if (frameCount%200==0 || frameCount==0){
    x = int(random(0, width));
    y = int(random(0, height));
    buildWord();
    newTrees();
    drawTrees = true;
  }
  showWord();


    image(lettersLayer,0,0);
//  image(testLayer,0,0);
//  if (drawTrees){
    treesLayer.beginDraw();
    treesLayer.fill(0);
    if (trees != null){
      for(int i=0; i<trees.length; i++){
        trees[i].draw();
      }
      trees = null;
    }
    treesLayer.endDraw();
//  }
   image(treesLayer,0,0);

  
}


void buildWord(){
  for (int i = 0; i < message.length(); i ++ ) {
    // Letter objects are initialized with their location within the String as well as what character they should display.
    letters[i] = new Letter(x,y,message.charAt(i)); 
    x += textWidth(message.charAt(i));
  }  
}

void showWord(){
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



void newTrees(){

  trees = new mytree[nTrees];
  for(int i=0; i<nTrees; i++){
//    float randomY = random(height);
    trees[i] = new mytree();
  }                 
}



void blankScreen(){
  fill(backgroundCol);
  noStroke();
  rect(0,0,width,height);
}

void fadeScreen(){
  fill(backgroundCol,50);
  noStroke();
  rect(0,0,width,height);
}


int randomSign(){ //returns +1 or -1
  float num = random(-1,1);
  if(num==0)
    return -1;
  else
    return (int)(num/abs(num));
}

