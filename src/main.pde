 Universe sim;
 void setup(){
   size(1000,800);
   sim = new Universe();
   for (int i = 0; i < 0; i++) {
    sim.addParticle(new Particle(random(width),random(height)));
  }
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
