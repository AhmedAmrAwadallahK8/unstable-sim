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
  float energy_lost_collish_constant;
  float max_heat;
  float collish_constant;
  float heat_constant;
  float min_dist;
  float heat_loss;
  float electron_size;
  float heat_share_constant;
  boolean explosionCycle;
  
  Particle(float x, float y){
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    position = new PVector(x, y);
    
    maxspeed = 20;
    maxforce = 0;
    
    r = 2.0;
    size = 5;
    electron_size =20; //20
    mass = 1;

    max_heat = 2000;
    heat_constant = 0;
    energy_lost_collish_constant = 0.3; //0.3
    collish_constant = 0.01; //0.01
    grav_constant = 120; //70 //120
    min_dist = 0.01;
    heat_share_constant = .0001;
    heat_loss = 0.02; //0.02
    explosionCycle = false;
  }
  
  void run(ArrayList<Particle> particles) {
    process_particle(particles);
    //update();
    //borders();
    //render();
   }
  
  void process_particle(ArrayList<Particle> particles) {
    for(Particle other: particles){
      if(other == this){
        //Particles do not interact with themselves
      }
      else{
        calcAndApplyGravityForce(other);
        calcAndApplyCollisionForce(other);
        calcAndApplyHeatInteractions(other);
      }
    }
  }
  
  void calcAndApplyGravityForce(Particle other){
    PVector grav = calcGravity(other);
    grav.mult(grav_constant);
    applyForce(grav);

  }
  
  void calcAndApplyCollisionForce(Particle other){
    PVector collish = calcCollision(other);
    collish.mult(collish_constant);
    applyForce(collish);
    other.applyForce(collish.rotate(PI));
  }
  
  void calcAndApplyHeatInteractions(Particle other){
    if(particleExceedsMaximumHeat()){
      explosionCycle = true;
      //print("HEAT RELEASE EVENT ");
      //print(random(10));
      //print("\n");
      explosiveReleaseHeat(other);
    }
    else if(particleAboveMinimumHeat()){
      explosionCycle = false;
      releaseHeat();
    } 
  }
  
  void releaseHeat(){
    heat -= heat_loss;
  }
  
  boolean particleAboveMinimumHeat(){
    if(heat >= 0){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean particleExceedsMaximumHeat(){
    if(heat > max_heat){
      return true;
    }
    else{
      return false;
    }
  }
  
  void explosiveReleaseHeat(Particle other){
    PVector externalAccel;
    externalAccel = new PVector(1,0);
    PVector deltaV = PVector.sub(position, other.position);
    float dist = deltaV.mag();
    if(otherParticleBelowMinimumDist(dist)){
      dist = min_dist;
    }
    if(otherParticleInCloseProximity(dist)){
      float explosionDirection = deltaV.heading();
      externalAccel.rotate(explosionDirection);
      externalAccel.div(dist);
      externalAccel.div(dist);
      externalAccel.div(dist);
      externalAccel.mult(100000);
      other.acceleration.add(externalAccel);
      other.heat += 100;
    }
    
  }
  
  boolean otherParticleBelowMinimumDist(float dist){ //Not sure i like this function
    if(dist <= min_dist){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean otherParticleInCloseProximity(float dist){
    if(dist <= 30){ //THis needs to be a constant
      return true;
    }
    else{
      return false;
    }
  }
  
  PVector calcCollision(Particle other){
    PVector collish = new PVector(0, 0);
    if(collided(other)){
      collish = inelastic_collision(other);
      shareHeat(other);
    }
    return collish;
  }
  
  void shareHeat(Particle other){
    float this_to_other_heat = heat*heat_share_constant;
    heat = heat*(1-heat_share_constant);
    other.heat += this_to_other_heat;
        
    float other_to_this_heat = other.heat*heat_share_constant;
    other.heat = other.heat*(1-heat_share_constant);
    heat += other_to_this_heat;
  }
  
  PVector inelastic_collision(Particle other){
    PVector collish = new PVector(1, 0);
    PVector delta_v = PVector.sub(position, other.position);
    PVector dv = PVector.sub(velocity, other.velocity);
    float dist = PVector.dist(position, other.position);
    if(otherParticleBelowMinimumDist(dist)){
      dist = min_dist;
    }
       
    float collisionForceDirection = delta_v.heading();
    collish.rotate(collisionForceDirection);
    
    float spring_dist = size+electron_size-dist;
    
    if (dist <= size){
      collish.mult(0);
    }
    else if (dist <= size+electron_size){
      collish.mult(spring_dist);
      collish.mult(spring_dist);
      
    }
    
    
    float angle_diff = PVector.angleBetween(velocity, other.velocity);
    float energy_mod = (1-cos(angle_diff))/2;
    PVector temp_v = new PVector(0,0);
    float mag_v = velocity.mag()/1000;
    temp_v.add(velocity);
    float energy_lost_collish = energy_lost_collish_constant*energy_mod;
    float v_lost = temp_v.mult(energy_lost_collish).mag();
    heat += mass*v_lost*v_lost/2;
    velocity.mult(1-energy_lost_collish);
    
    return collish;
  }
  
  boolean collided(Particle other){
    float distance = PVector.dist(other.position, position);
    if(distance <= size+electron_size){
      return true;
    }
    else{
      return false;
    }
    
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  PVector calcGravity (Particle other) {
    PVector gravity = new PVector(1, 0);
    PVector deltaDistance = PVector.sub(other.position, position);
    float dist = deltaDistance.mag();
    if(otherParticleBelowMinimumDist(dist)){
      dist = min_dist;
    }
    float gravityDirection = deltaDistance.heading();
    
    gravity.rotate(gravityDirection);
    gravity.mult(mass);
    gravity.mult(other.mass);
    gravity.div(dist);
    gravity.div(dist);
    
    return gravity;
  }
  
  
  
  void update() {
     

    
    updateVelocity();
    updatePosition();
    resetAcceleration();
    //borders();
    render();
  }
  
  void updateVelocity(){
    velocity = velocity.add(acceleration);
    if(explosionCycle){
      velocity.limit(maxspeed*9);
      heat = 0;
    }
    else{
      velocity.limit(maxspeed);
    }
    
  }
  
 
  
  void updatePosition(){
    position = position.add(velocity);
  }
  
  void resetAcceleration(){
    acceleration.mult(0);
  }
  
  void borders() {
    if (beyondWestBorder()) velocity.limit(1);
    if (beyondNorthBorder()) velocity.limit(1);
    if (beyondEastBorder()) velocity.limit(1);
    if (beyondSouthBorder()) velocity.limit(1);
    //if (beyondWestBorder() & (velocity.x < 0)) velocity.limit(1);
    //if (beyondNorthBorder() & (velocity.x < 0)) velocity.limit(1);
    //if (beyondEastBorder() & (velocity.x > 0)) velocity.limit(1);
    //if (beyondSouthBorder() & (velocity.x > 0)) velocity.limit(1);
  }
  
  boolean beyondNorthBorder(){
    if (position.y < -r){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean beyondSouthBorder(){
    if (position.y > height+r){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean beyondEastBorder(){
    if (position.x > width+r){
      return true;
    }
    else{
      return false;
    }
  }
  
  boolean beyondWestBorder(){
    if (position.x < -r){
      return true;
    }
    else{
      return false;
    }
  }
  
  void render() {
    int maxColorVal = 255;
    float mag_v = velocity.mag();
    float blue = heat*maxColorVal/max_heat;
    float red = mag_v*maxColorVal/30;
    float green = mag_v*maxColorVal/200;
    //float red = 0;
    //float green = 0;
    
    fill(red, green, blue);
    stroke(red, green, blue);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0,0,size,size);
    popMatrix();
  }
  
  void setVelocityRandom(){
    velocity = new PVector(0, random(8, 15));
  }
  
}
