Universe sim;
int count = 0;

void setup(){
  size(1000,800);
  sim = new Universe();
  sim.addNRandomlyPlacedParticles(500);
}
 
void draw(){
  background(50);
  if(count % 2 == 0){
    sim.run();
  }
  else{
    sim.render();
  }
  count++;
  if(count > 1000){
    count = 0;
  }
}
 
void mouseDragged(){
  sim.addParticle(new Particle(mouseX, mouseY));
}
 
void mousePressed(){
  sim.addParticle(new Particle(mouseX, mouseY));
}
