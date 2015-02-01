


class Trees {



  boolean addBlur = false;

  int nTrees = 2;

  color backgroundCol = color(200);
  //color treeColor = color(0,255,0);

  //initial tree properties.
  float branchWidthInit;
  float totalBranchLengthInit;
  int nBranchDivisionsInit;
  float percentBranchlessInit;
  float branchSizeFractionInit;
  float dThetaGrowMaxInit;
  float dThetaSplitMaxInit; 
  float oddsOfBranchingInit;

  int minLifeSpanBeforeFade;
  int maxLifeSpanBeforeFade;


  ArrayList<Tree> trees = new ArrayList<Tree>();

  Trees() {
    initializeTreeValues();
    newTrees();
  }


  void initializeTreeValues() {
    branchWidthInit = 9;
    totalBranchLengthInit = 300;
    nBranchDivisionsInit = 30;
    percentBranchlessInit = .3;
    branchSizeFractionInit = .5;
    dThetaGrowMaxInit = PI/15;
    dThetaSplitMaxInit = PI/6; 
    oddsOfBranchingInit = .3;
    minLifeSpanBeforeFade = 200;
    maxLifeSpanBeforeFade = 400;
  }

  void newTrees() {

    addBlur = false;
    for (int i=0; i<2; i++) {
      float y = random(height-300,height);
      float ht = y / height * totalBranchLengthInit;
      trees.add(
        new Tree(random(100,width), y, -HALF_PI, branchWidthInit, 
        ht, nBranchDivisionsInit, 
        percentBranchlessInit, branchSizeFractionInit, 
        dThetaGrowMaxInit, dThetaSplitMaxInit, 
        oddsOfBranchingInit, 0, int(random(minLifeSpanBeforeFade,maxLifeSpanBeforeFade)))
        );
    }

    if (addBlur)
      btreesLayer.filter(BLUR, 1);
  }

  void draw() {
//    alpha ++;
//    if (alpha == 255) {
//      alpha = 0;
//    }

    for (Tree t : trees) {
      t.draw();
    }
  }
  
  void cleanUpDeadTrees(){
    for (int i=0; i<trees.size() ; i++){
      Tree tr = trees.get(i);
      if (tr.isDead()){
        trees.remove(i);
        break;
      }  
    }      
  }


  void blankScreen() {
    fill(backgroundCol);
    noStroke();
    rect(0, 0, width, height);
  }

  void fadeScreen() {
    btreesLayer.beginDraw();
    btreesLayer.fill(backgroundCol, 50);
    btreesLayer.noStroke();
    btreesLayer.rect(0, 0, width, height);
    btreesLayer.endDraw();
  }


  int randomSign() { //returns +1 or -1
    float num = random(-1, 1);
    if (num==0)
      return -1;
    else
      return (int)(num/abs(num));
  }
}

