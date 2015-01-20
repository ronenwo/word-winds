// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Stochastic Tree
// Renders a simple tree-like structure via recursion
// Angles and number of branches are random

//void setup() {
//  size(800, 200);
//  newTree();
//}

//void draw() {
//  noLoop();
//}
//
//void mousePressed() {
//  pushMatrix();
//  newTree();
//  popMatrix();
//  redraw();
//}


class mytree {

  mytree(){
  }

void draw() {
//  treesLayer.background(255);
//  treesLayer.fill(0);
////  text("Click mouse to generate a new tree", 10, height-10);
//
//  treesLayer.stroke(0);
  // Start the tree from the bottom of the screen
  float randomY = random(height);
  float randomX = random(width);
  float tHeight = randomY / height * 60;
  treesLayer.translate(randomX, randomY);
  // Start the recursive branching!
  branch(tHeight);
}

  
  void branch(float h) {
    // thickness of the branch is mapped to its length
    float sw = map(h, 2, 120, 1, 5);
    treesLayer.strokeWeight(sw);
     float theta = random(0,PI/3);
    
    treesLayer.line(0, 0, 0, -h);
    treesLayer.translate(0, -h);
    h *= 0.66;
    if (h > 2) {
      treesLayer.pushMatrix();    
      treesLayer.rotate(theta);   
      branch(h);
      treesLayer.popMatrix();     
      treesLayer.pushMatrix();
      treesLayer.rotate(-theta);
      branch(h);
      treesLayer.popMatrix();
    }
  }


}

