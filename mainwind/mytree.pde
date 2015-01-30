// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Stochastic Tree
// Renders a simple tree-like structure via recursion
// Angles and number of branches are random

class mytree {

  boolean growen = false;

  float tilt = 0.1;
  float scalar = 1.2;
  float angle;

  ArrayList<Branch> branches = new ArrayList<Branch>();

  float x, y, h;

  class Branch {
    float h, t;
    Branch(float h1, float teta1) {
      h = h1;
      t = teta1;
    }
  }

  mytree() {
  }

  void wobble() {
    tilt = cos(angle) / 16;
    angle += 0.01;
    if (angle > PI/5) {
      angle = 0;
    }
  }

  void draw() {
    if (!growen) {
      growen = true;
      grow();
    }
    wobble();
    redrawme();
  }

  void redrawme() {
    println("draw a tree at: "+x+","+y);
    println("draw a tree height: "+h);
    treesLayer.pushMatrix();
    treesLayer.translate(x, y);
    // Start the recursive branching!
    rebranch(h, 0);
    treesLayer.popMatrix();
  }

  void grow() {
    y = random(200, height);
    x = random(width);
    h = y / height * 100;
    // Start the recursive branching!
    growbranch(h);
  }

  void growbranch(float h1) {
    // thickness of the branch is mapped to its length
    float teta = random(0, PI/3);
    h1 *= 0.71;
    branches.add(new Branch(h1, teta));
    if (h1 > 2) {
      growbranch(h1);
      growbranch(h1);
    }
  }

  void rebranch(float h1, int index) {
    int mframeCount = frameCount%200;
    float t1 = tilt ;
    if (mframeCount>=0 && mframeCount<=70)  {
      t1 = tilt + radians(mframeCount / 40 );
    }
    else if (mframeCount>=41 && mframeCount<=60){
      t1 = tilt + radians((80 - mframeCount)/ 50 );
    }


    // thickness of the branch is mapped to its length
    float sw = map(h1, 2, 120, 1, 5);
    treesLayer.strokeWeight(sw);
    treesLayer.rotate(t1);
    treesLayer.line(0, 0, 0, -h1);
//    treesLayer.pushMatrix();
//    treesLayer.popMatrix();
    treesLayer.translate(0, -h1);

    h1 *= 0.66;
    Branch b = branches.get(index);
    float h2 = b.h;
    float theta = b.t;
    if (h2 > 2) {
      index++;
      treesLayer.pushMatrix();    
      treesLayer.rotate(theta + t1);   
      rebranch(h2, index);
      treesLayer.popMatrix();     
      treesLayer.pushMatrix();
      treesLayer.rotate(-theta+ t1);
      rebranch(h2, index);
      treesLayer.popMatrix();
    }
  }

  void draw1() {
    // Start the tree from the bottom of the screen
    y = random(height);
    x = random(width);
    h = y / height * 60;
    treesLayer.translate(x, y);
    // Start the recursive branching!
    branch(h);
  }


  void branch(float h1) {
    // thickness of the branch is mapped to its length
    float sw = map(h1, 2, 120, 1, 5);
    treesLayer.strokeWeight(sw);
    float teta = random(0, PI/3);
    treesLayer.line(0, 0, 0, -h1);
    treesLayer.translate(0, -h1);
    h1 *= 0.66;
    branches.add(new Branch(h1, teta));
    if (h1 > 2) {
      treesLayer.pushMatrix();    
      treesLayer.rotate(teta);   
      branch(h1);
      treesLayer.popMatrix();     
      treesLayer.pushMatrix();
      treesLayer.rotate(-teta);
      branch(h1);
      treesLayer.popMatrix();
    }
  }
}

