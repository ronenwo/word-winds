class tree{
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
  tree(float xI, float yI, float thetaI, float branchWidth0I,
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
    if(branchWidth<.5)//stop growing if it's too thin to render
      lengthSoFar = totalBranchLength;
    for (int i=0; i<5 ; i++){
      if (lengthSoFar>=totalBranchLength){
        break;
      }
      branchWidth = branchWidth0*(1-lengthSoFar/totalBranchLength);
      (new tree(x1, y1, theta+randomSign()*dThetaSplitMax, branchWidth,
                totalBranchLength*branchSizeFraction, nBranchDivisions, 
                percentBranchless, branchSizeFraction, 
                dThetaGrowMax, dThetaSplitMax,
                oddsOfBranching, myColor)).draw();
      nextSectionLength = totalBranchLength/nBranchDivisions;
      lengthSoFar+=nextSectionLength;
      theta += randomSign()*random(0,dThetaGrowMax);
      x2 = x1+nextSectionLength*cos(theta);
      y2 = y1+nextSectionLength*sin(theta);
      drawText("meaning",x1,y1,x2,y2);
      x1 = x2;
      y1 = y2;
    }  
  }
}

void drawText(String str,float x1, float y1, float x2, float y2){
   float dx = x2 - x1;
   float dy = y2 - y1;
   float ratioX = dx / dy;
   float ratioY = dy / dx;
   float xFactor = dx / str.length();
   float yFactor = dy / str.length();
   float dxi = dx / str.length();
   for(int i=0; i<str.length(); i++){
      float dxx = dxi * i;
      float dyy = dxx * dy / dx ;
      treesLayer.text(str.charAt(i),x1+dxx,y1+dyy);
   } 
}
