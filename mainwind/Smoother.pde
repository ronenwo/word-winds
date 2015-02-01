// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// The "Smoother" class

class Smoother {
    ArrayList<PVector> history = new ArrayList<PVector>();

  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  String word;
  int txtSize;
  
  Path path;

  Smoother(float x, float y, String txt, int tSize) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,-2);
    location = new PVector(x,y);
    r = 6;
    maxspeed = 2;
    maxforce = 0.1;
    word = txt;
    txtSize = tSize;
    
  }

  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelerationelertion to 0 each cycle
    acceleration.mult(0);
    
        history.add(location.get());
    if (history.size() > 100) {
      history.remove(0);
    }
  }

  void setPath(Path p){
     path = p; 
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  void seek(){
    PVector target = path.get();
    if (target==null){
       return; 
    }
    if (PVector.dist(target,location)<=10){
      target = path.next();
    }  
    seek(target);
  }

  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target,location);  // A vector pointing from the location to the target
    
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    
    applyForce(steer);
  }
    
  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    pushMatrix();
    translate(location.x,location.y);
//    rotate(theta);
    fill(0);
    textSize(txtSize);
    text(word,0,0);
    popMatrix();
    
    
  }
  
  void run(){
    seek();
    update();
    display(); 
  }
}

