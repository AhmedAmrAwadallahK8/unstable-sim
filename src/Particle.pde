class Particle{
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector impulse;
  float r;
  float maxforce;
  float maxspeed;
  float size;
  float mass;
  float grav_constant;
  float impulse_time;
  float current_impulse_time;
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
    impulse = new PVector(0,0);
    
    float angle = random(TWO_PI);
    velocity = new PVector(0, 0);
    //velocity = new PVector(cos(angle), sin(angle));

    position = new PVector(x, y);
    r = 2.0;
    maxspeed = 20000;
    maxforce = 0;
    size = 5;
    electron_size = 10;
    mass = 1;
    current_impulse_time = 0;
    impulse_time = 6;
    max_heat = 20000;
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
    //borders();
    render();
  }
  
  void process_particle(ArrayList<Particle> particles) {
    PVector heatForce = heat();
    heatForce.mult(heat_constant);
    applyForce(heatForce);
    
    PVector grav = gravity(particles);
    grav.mult(grav_constant);
    applyForce(grav);
    
    PVector collish = collision(particles);
    collish.mult(collish_constant);
    applyForce(collish);
    
  }
  
  PVector heat(){
    if(heat > max_heat){
      print("HEAT RELEASE EVENT\n");
      float angle = random(TWO_PI);
      PVector heatRelease = new PVector(cos(angle), sin(angle));
      heatRelease.mult(heat);
      heat -= max_heat;
      return heatRelease;
    }
    else{
      if(heat >= 0){
        heat -= heat_loss;
      }
      return new PVector(0, 0);
    }
    
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
    //PVector collish = new PVector(1, 0);
    //PVector v_initial = velocity;
    //PVector v_final = velocity.rotate(180);
    //PVector delta_v = PVector.add(v_final, v_initial);
    //float theta = delta_v.heading();
    //float mag_v = PVector.dist(v_final, v_initial);
    //collish.rotate(theta);
    //collish.mult(mag_v);
    //collish = delta_v.mult(mass).div(impulse_time);
    
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
    // Update velocity
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    // Limit speed
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }
  
  void borders() {
    PVector invert_x = new PVector(-1, 0);
    PVector invert_y = new PVector(0, -1);
    
    //if (position.x < -r) velocity.dot(invert_x);
    //if (position.y < -r) velocity.dot(invert_y);
    //if (position.x > width+r) velocity.dot(invert_x);
    //if (position.y > height+r) velocity.dot(invert_y);
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }
  
  void render() {
    // Draw a triangle rotated in the direction of velocity
    //float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    float mag_v = velocity.mag();
    //fill(200, 100);
    //stroke(255);
    float red = heat;
    float green = 0;
    float blue = mag_v*50;
    
    fill(red, green, blue);
    stroke(red, green, blue);
    pushMatrix();
    translate(position.x, position.y);
    ellipse(0,0,size,size);
    popMatrix();
  }
  
}
