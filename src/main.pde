Universe sim;
int count = 0;

void setup(){
  size(1000,800);
  sim = new Universe();
  sim.addNRandomlyPlacedParticles(500); //500
}
 
void draw(){
  //background(50);
  //noStroke();
  fill(100, 140); //140
  rect(0,0,width,height);
  sim.run();
}
 
void mouseDragged(){
  sim.addParticle(new Particle(mouseX, mouseY));
}
 
void mousePressed(){
  sim.addParticleWithRandomV(new Particle(mouseX, mouseY));
  //sim.addParticle(new Particle(mouseX, mouseY));
}
