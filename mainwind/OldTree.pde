class OldTree{
  float x1,y1,x2,y2; //position
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

//constructor
  OldTree(float xI, float yI, float thetaI, float branchWidth0I,
  float totalBranchLengthI, int nBranchDivisionsI, 
  float percentBranchlessI, float branchSizeFractionI, 
  float dThetaGrowMaxI, float dThetaSplitMaxI,
  float oddsOfBranchingI, color colorI){
    x1 = xI;
    y1 = yI;
    x2 = xI;
    y2 = yI;
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
  }

//this does the drawing/growing!
  float lengthSoFar = 0;
  float nextSectionLength;
  void draw(){
    println("DRAW TREE at: "+x1+","+y1);
    if(branchWidth<.5)//stop growing if it's too thin to render
      lengthSoFar = totalBranchLength;
    while(lengthSoFar<totalBranchLength){
      branchWidth = branchWidth0*(1-lengthSoFar/totalBranchLength);
      //do I need to split?
      if(lengthSoFar/totalBranchLength > percentBranchless){//if i can branch
        if(random(0,1)<oddsOfBranching){//and i randomly choose to
          btreesLayer.stroke(myColor);
          //make a new branch there!
            (new OldTree(x1, y1, theta+randomSign()*dThetaSplitMax, branchWidth,
                      totalBranchLength*branchSizeFraction, nBranchDivisions, 
                      percentBranchless, branchSizeFraction, 
                      dThetaGrowMax, dThetaSplitMax,
                      oddsOfBranching, myColor)).draw();
        }
      }

      //change directions, grow forward 
      nextSectionLength = totalBranchLength/nBranchDivisions;
      lengthSoFar+=nextSectionLength;
      theta += randomSign()*random(0,dThetaGrowMax);
      x2 = x1+nextSectionLength*cos(theta);
      y2 = y1+nextSectionLength*sin(theta);
      //scale thickness by the distance it's traveled.
      btreesLayer.strokeWeight(abs(branchWidth));
      btreesLayer.stroke(myColor);
      btreesLayer.line(x1,y1,x2,y2);
      x1 = x2;
      y1 = y2;
    }
  }
}


