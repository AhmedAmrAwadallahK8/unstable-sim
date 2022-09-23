Universe sim;
int count = 0;

void setup(){
  size(1000,800);
  sim = new Universe();
  //sim.addNRandomlyPlacedParticles(500);
}
 
void draw(){
  background(50);
  sim.run();
}
 
void mouseDragged(){
  sim.addParticle(new Particle(mouseX, mouseY));
}
 
void mousePressed(){
  sim.addParticle(new Particle(mouseX, mouseY));
}
