class Particle{
  ArrayList<PVector> forces;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;
  float maxspeed;
  float size;
  float mass;
  float grav_constant;
  float heat;
  float energy_lost_collish;
  float max_heat;
  float collish_constant;
  float heat_constant;
  float min_dist;
  float heat_loss;
  float electron_size;
  
  Particle(float x, float y){
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
    
    maxspeed = 20000;
    maxforce = 0;
    
    r = 2.0;
    size = 5;
    electron_size = 10;
    mass = 1;

    max_heat = 10000;
    heat_constant = 0;
    energy_lost_collish = 0.2;
    collish_constant = 40;
    grav_constant = 100;
    min_dist = 0.0000001;
    heat_loss = 5;
  }
  
  void run(ArrayList<Particle> particles) {
    process_particle(particles);
    update();
    borders();
    render();
   }
  
  void process_particle(ArrayList<Particle> particles) {   
    heat(particles);
    
    PVector grav = gravity(particles);
    grav.mult(grav_constant);
    applyForce(grav);
    
    PVector collish = collision(particles);
    collish.mult(collish_constant);
    applyForce(collish);
    
  }
  
  void heat(ArrayList<Particle> particles){
    if(heat > max_heat){
      print("HEAT RELEASE EVENT\n");
      releaseHeat(particles);
    }
    else{
      if(heat >= 0){
        heat -= heat_loss;
      }
    } 
  }
  
  void releaseHeat(ArrayList<Particle> particles){
    PVector externalAccel;
    for(Particle other: particles){
      externalAccel = new PVector(1,0);
      PVector deltaV = PVector.sub(position, other.position);
      float dist = PVector.dist(position, other.position);
      if(dist <= min_dist){
        dist = min_dist;
      }
      float theta = deltaV.heading();
      externalAccel.rotate(theta);
      externalAccel.div(dist);
      externalAccel.div(dist);
      //externalAccel.div(dist);
      externalAccel.mult(heat);
      
      other.acceleration.add(externalAccel);
    }
    heat -= max_heat;
  }
  
  PVector collision(ArrayList<Particle> particles){
    PVector collish = new PVector(0, 0);
    for (Particle other: particles){
      if(other == this){
        collish.mult(0);
      }
      else if(collided(other)){
        collish = inelastic_collision(other);
      }
    }
    return collish;
  }
  
  PVector inelastic_collision(Particle other){
    PVector collish = new PVector(1, 0);
    PVector delta_v = PVector.sub(position, other.position);
    float dist = PVector.dist(position, other.position);
    if(dist <= min_dist){
      dist = min_dist;
    }
       
    float theta = delta_v.heading();
    collish.rotate(theta);
    
    if(dist <= 1){
      
      collish.div(dist);
      collish.div(dist);
      collish.div(dist);
    }
    else if (dist <= size*electron_size){
      collish.div(dist);

    }
    
    
    PVector v_lost = velocity.mult(energy_lost_collish);
    heat += mass*v_lost.mag()*v_lost.mag()/2;
    velocity.mult(1-energy_lost_collish);
    
    return collish;
  }
  
  boolean collided(Particle other){
    float distance = PVector.dist(other.position, position);
    if(distance <= size*electron_size){
      return true;
    }
    else{
      return false;
    }
    
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  PVector gravity (ArrayList<Particle> particles) {
    PVector gravity_total = new PVector(0, 0);
    for (Particle other : particles) {
      
      
      if(other == this){
        
      }
      else{
        float distance = PVector.dist(other.position, position);
        if(distance <= 2*size){
          distance = 2*size;
        }
        PVector distance_vec = PVector.sub(other.position, position);
        float theta = distance_vec.heading();
        PVector gravity = new PVector(1, 0);
        gravity.rotate(theta);
        gravity.mult(mass);
        gravity.mult(other.mass);
        gravity.div(distance);
        gravity.div(distance);
        gravity_total.add(gravity);
        
        
      }
    }
    
    return gravity_total;
  }
  
  void update() {
    updateVelocity();
    updatePosition();
    updateAcceleration();
  }
  
  void updateVelocity(){
    velocity.add(acceleration);
    velocity.limit(maxspeed);
  }
  
  void updatePosition(){
    position.add(velocity);
  }
  
  void updateAcceleration(){
    acceleration.mult(0);
  }
  
  void borders() {
    float escapeVelocityReduction = 0.5;
    //if (position.x < -r) position.x = width+r;
    //if (position.y < -r) position.y = height+r;
    //if (position.x > width+r) position.x = -r;
    //if (position.y > height+r) position.y = -r;
    if (position.x < -r) velocity.mult(escapeVelocityReduction);
    if (position.y < -r) velocity.mult(escapeVelocityReduction);
    if (position.x > width+r) velocity.mult(escapeVelocityReduction);
    if (position.y > height+r) velocity.mult(escapeVelocityReduction);
  }
  
  void render() {
    float mag_v = velocity.mag();
    float red = heat;
    float green = 0;
    float blue = mag_v*20;
    
    fill(red, green, blue);
    stroke(red, green, blue);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0,0,size,size);
    popMatrix();
  }
  
}
