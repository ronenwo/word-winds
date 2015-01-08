import processing.video.*;
Movie myMovie;

int x = 200;
int y = 400;

PFont f;
String message = "meaning";

boolean addSnow = false;
boolean addBlur = false;
float maxSnowTheta = HALF_PI*4/5;

int nTrees = 2;
tree[] trees;
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

Letter[] letters;

void setup() {
  f = createFont("Arial", 20, true);
  textFont(f);
  size(1024, 768);
  myMovie = new Movie(this, "wind1.mp4");
  myMovie.loop();

  letters = new Letter[message.length()];
  buildWord();
  
    
  background(backgroundCol);
//  noFill();
  treesLayer = createGraphics(width, height);
  lettersLayer = createGraphics(width, height);
  
  initializeTreeValues();
  newTrees();
}

void draw() {
//  tint(255, 20);
  image(myMovie, 0, 0);
//  fill(120);
  
  if (frameCount%200==0){
    x = int(random(0, width));
    y = int(random(0, height));
    buildWord();
//    fadeScreen();
    newTrees();
  }
  showWord();
  
  treesLayer.beginDraw();
  treesLayer.fill(0);
  for(int i=0; i<nTrees; i++){
    trees[i].draw();
  }
  treesLayer.endDraw();

  image(treesLayer,0,0);
  image(lettersLayer,0,0);
  
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


void initializeTreeValues(){
  branchWidthInit = 10;
  totalBranchLengthInit = 300;
  nBranchDivisionsInit = 30;
  percentBranchlessInit = .3;
  branchSizeFractionInit = .5;
  dThetaGrowMaxInit = PI/15;
  dThetaSplitMaxInit = PI/6; 
  oddsOfBranchingInit = .3;
}

void newTrees(){
/* tree(x, y, theta, branchWidth0,
       totalBranchLength, nBranchDivisions, 
       percentBranchless, branchSizeFraction, 
       dThetaGrowMax, dThetaSplitMax,
       oddsOfBranching, color)
*/

//  background(backgroundCol);
//  noFill();
  trees = new tree[nTrees];
  for(int i=0; i<nTrees; i++){
    float randomY = random(height);
    trees[i] = new tree(random(width), randomY, -HALF_PI, branchWidthInit,
                   totalBranchLengthInit*randomY/height, nBranchDivisionsInit, 
                   percentBranchlessInit, branchSizeFractionInit, 
                   dThetaGrowMaxInit, dThetaSplitMaxInit,
                   oddsOfBranchingInit, color(random(0,30)));
  }                 
//  for(int i=0; i<nTrees; i++)
//    trees[i].draw();
//    
//  if(addBlur)
//    filter(BLUR,1);
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

