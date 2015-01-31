class Tree {
  float x1, y1, x2, y2; //position
  float theta;
  float branchWidth;
  float branchWidth0;
  float totalBranchLength;//length this branch can be.
  int nBranchDivisions; //the length of each line segment
  float percentBranchless; //it grows  at least this amount before branching more
  float branchSizeFraction;  //the branches are this much of the size at the split
  float dThetaGrowMax;
  float dThetaSplitMax;
  float oddsOfBranching; //the odds of branching at a given location.
  color myColor;
  int lifeSpan;

  ArrayList<Tree> subTrees = new ArrayList<Tree>();

  float ix1, iy1, itheta, ibranchWidth, itotalBranchLength; 


  ArrayList<Branch> branches = new ArrayList<Branch>();
  class Branch {
    float x1, y1, x2, y2, bwidth;
    Branch(float x1, float y1, float x2, float y2, float bw){
         this.x1 = x1;
         this.y1 = y1;
         this.x2 = x2;
         this.y2 = y2;
         this.bwidth = bw;
    } 
  }

  //constructor
  Tree(float xI, float yI, float thetaI, float branchWidth0I, 
  float totalBranchLengthI, int nBranchDivisionsI, 
  float percentBranchlessI, float branchSizeFractionI, 
  float dThetaGrowMaxI, float dThetaSplitMaxI, 
  float oddsOfBranchingI, color colorI, int mlifeSpan) {
    x1 = xI;
    y1 = yI;
    x2 = xI;
    y2 = yI;

    ix1 = xI;
    iy1 = yI;
    itheta = thetaI;
    ibranchWidth = branchWidth0I;
    itotalBranchLength = totalBranchLengthI;

    theta = thetaI;
    branchWidth0 = branchWidth0I;
    branchWidth = branchWidth0;
    totalBranchLength =totalBranchLengthI;
    nBranchDivisions =nBranchDivisionsI;
    percentBranchless = percentBranchlessI;
    branchSizeFraction = branchSizeFractionI;
    dThetaGrowMax = dThetaGrowMaxI;
    dThetaSplitMax = dThetaSplitMaxI;
    oddsOfBranching = oddsOfBranchingI;
    myColor = colorI;
    lifeSpan = mlifeSpan;
  }

  //this does the drawing/growing!
  float lengthSoFar = 0;
  float nextSectionLength;

  boolean growen = false;

  void grow() {
//    println("DRAW TREE at: "+x1+","+y1);
    if (branchWidth<.5)//stop growing if it's too thin to render
      lengthSoFar = totalBranchLength;
    while (lengthSoFar<totalBranchLength) {
      branchWidth = branchWidth0*(1-lengthSoFar/totalBranchLength);
      //do I need to split?
      if (lengthSoFar/totalBranchLength > percentBranchless) {//if i can branch
        if (random(0, 1)<oddsOfBranching) {//and i randomly choose to
          btreesLayer.stroke(myColor);
          //make a new branch there!
          subTrees.add(
          new Tree(x1, y1, theta+randomSign()*dThetaSplitMax, branchWidth, 
          totalBranchLength*branchSizeFraction, nBranchDivisions, 
          percentBranchless, branchSizeFraction, 
          dThetaGrowMax, dThetaSplitMax, 
          oddsOfBranching, myColor, lifeSpan)
            );
        }
      }

      //change directions, grow forward 
      nextSectionLength = totalBranchLength/nBranchDivisions;
      lengthSoFar+=nextSectionLength;
      theta += randomSign()*random(0, dThetaGrowMax);
      x2 = x1+nextSectionLength*cos(theta);
      y2 = y1+nextSectionLength*sin(theta);
      branches.add(new Branch(x1,y1,x2,y2,branchWidth));
      x1 = x2;
      y1 = y2;
    }
  }

  void draw() {
    lifeSpan --;
    if (lifeSpan <=0){
       lifeSpan = 0;
       myColor ++;  
    }
    lengthSoFar = 0;
    nextSectionLength = 0;
    if (!growen) {
      growen = true;
      grow();
    }
    doDraw();
  }
  void doDraw() {
//    println("DRAW TREE at: "+x1+","+y1);
//    lengthSoFar = totalBranchLength;
    x1 = ix1;
    y1 = iy1;
//    itheta = thetaI;
    branchWidth = ibranchWidth;
    totalBranchLength = itotalBranchLength;
//    btreesLayer.pushMatrix();
//    if (branchWidth < 3){
//      btreesLayer.rotate(tilt);
//    }
    for (Branch b : branches){
      btreesLayer.strokeWeight(abs(b.bwidth));
      btreesLayer.stroke(myColor);
      float dx = frameCount%20;
//      if (frameCount%20==0){
//        dx = 6;
//      }
//      else if (frameCount%10==0){
//        dx = 3;
//      }
      btreesLayer.pushMatrix();
      btreesLayer.translate(b.x1,b.y1);
      if (b.bwidth < 4){
        btreesLayer.rotate(tilt);
      }
//      btreesLayer.fill(200,alpha);
      btreesLayer.line(0, 0, b.x2-b.x1, b.y2-b.y1);
      btreesLayer.popMatrix();
    }
    

    for (Tree t : subTrees) {
      t.draw();
    }
  }
  
  boolean isDead(){
     if (myColor >=255){
        return true;
     } 
     return false;
  }
}


