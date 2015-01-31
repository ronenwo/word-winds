// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Path Following
// Vehicle class


boolean debug = false; 

class Vehicle {

  // All the usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

  PVector burstvelocity;
  PVector burstacceleration;
  float maxburstforce;    // Maximum steering force
  float maxburstspeed;    // Maximum speed


  String text;
  String[] words;
  int[] offset;
  
  int sign = 1; 
  int degrees = 0;
  int pivot = 0;

    // Constructor initialize all values
  Vehicle( PVector l, float ms, float mf, String t) {
    location = l.get();
    r = 6;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(maxspeed, 0);

    maxburstspeed = ms * 3;
    maxburstforce = mf * 2;
    burstacceleration = new PVector(1.5, random(-0.1,0.3));
    burstvelocity = new PVector(maxburstspeed, random(-0.05,0.05));

    text = t;
    words = split(text," ");
    offset = new int[words.length];
    for (int i=0; i<words.length; i++){
       offset[i] = Math.round(i*40); 
    }
  }

  // A function to deal with path following and separation
  void applyBehaviors(ArrayList vehicles, Path path) {
    // Follow path force
    PVector f = follow(path);
    // Separate from other boids force
    PVector s = separate(vehicles);
    // Arbitrary weighting
    f.mult(1.5);
    s.mult(2);
    // Accumulate in acceleration
    applyForce(f);
    applyForce(s);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
//    burstacceleration.add(force);
  }



  // Main "run" function
  public void run() {
    update();
    borders();
    render();
  }


  // This function implements Craig Reynolds' path following algorithm
  // http://www.red3d.com/cwr/steer/PathFollow.html
  PVector follow(Path p) {

    // Predict location 25 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(25);
    PVector predictLoc = PVector.add(location, predict);

    // Now we must find the normal to the path from the predicted location
    // We look at the normal for each line segment and pick out the closest one
    PVector normal = null;
    PVector target = null;
    float worldRecord = 1000000;  // Start with a very high worldRecord distance that can easily be beaten

    // Loop through all points of the path
    for (int i = 0; i < p.points.size(); i++) {

      // Look at a line segment
      PVector a = p.points.get(i);
      PVector b = p.points.get((i+1)%p.points.size()); // Note Path has to wraparound

      // Get the normal point to that line
      PVector normalPoint = getNormalPoint(predictLoc, a, b);

      // Check if normal is on line segment
      PVector dir = PVector.sub(b, a);
      // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
      //if (da + db > line.mag()+1) {
      if (normalPoint.x < min(a.x,b.x) || normalPoint.x > max(a.x,b.x) || normalPoint.y < min(a.y,b.y) || normalPoint.y > max(a.y,b.y)) {
        normalPoint = b.get();
        // If we're at the end we really want the next line segment for looking ahead
        a = p.points.get((i+1)%p.points.size());
        b = p.points.get((i+2)%p.points.size());  // Path wraps around
        dir = PVector.sub(b, a);
      }

      // How far away are we from the path?
      float d = PVector.dist(predictLoc, normalPoint);
      // Did we beat the worldRecord and find the closest line segment?
      if (d < worldRecord) {
        worldRecord = d;
        normal = normalPoint;
        
        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        dir.normalize();
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.mult(25);
        target = normal.get();
        target.add(dir);
        
      }
    }


    // Only if the distance is greater than the path's radius do we bother to steer
    if (worldRecord > p.radius) {
      return seek(target);
    } 
    else {
      return new PVector(0, 0);
    }
  }


  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList boids) {
    float desiredseparation = r*2;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (int i = 0 ; i < boids.size(); i++) {
      Vehicle other = (Vehicle) boids.get(i);
      float d = PVector.dist(location, other.location);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }


  // Method to update location
  void update() {
    // Update velocity
    int mframeCount = frameCount%windCycle;
    if ((mframeCount>=0 && mframeCount<=20) || (mframeCount>=27 && mframeCount<=35)){
//      acceleration.mult(2);
//      maxspeed *= 2;
//      PVector burstFuzz = new PVector(random());
      velocity.add(burstacceleration);
      // Limit speed
      velocity.limit(maxburstspeed);
    }
    else{
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
    }
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocationity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

      return steer;
  }


  void render() {
    // Simpler boid is just a circle
    fill(75);
    stroke(0);
    pushMatrix();
    translate(location.x, location.y);
    int counter = frameCount%90;    
    
    if (counter==89){
      sign = -1;
      pivot = 45;  
    }
    if (counter==0){
       sign = 1;
       pivot = 90; 
    }
    degrees = pivot + sign * counter;
    
//    rotate(radians(degrees));
    
    for(int i=0; i<words.length ; i++){
      textSize(12);
      text(words[i],offset[i],i*15);
    }
//    ellipse(0, 0, r, r);
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (location.x < -r) location.x = width+r;
    //if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    //if (location.y > height+r) location.y = -r;
  }
}



