class Universe{
  ArrayList<Particle> particles;
  int sample_size;
  
  Universe(){
    particles = new ArrayList<Particle>();
    sample_size = 10;
  }
  
  void run(){
    ArrayList<Particle> particles_sample = random_sample();
    for(Particle p: particles_sample){
      p.run(particles_sample);
    }
  }
  
  ArrayList<Particle> random_sample(){
    ArrayList<Particle> sample = new ArrayList<Particle>();
    IntList used_particles = new IntList();
    
    for(int i = 0; i < particles.size(); i++){
      
      int index = int(random(particles.size()));
      while(used_particles.hasValue(index)){
        index = int(random(particles.size()));
      }
      used_particles.append(index);
      sample.add(particles.get(index));
    }
    return sample;
  }
  
  void addParticle(Particle p){
    particles.add(p);
  }
  
  void addNRandomlyPlacedParticles(int n_particles){
    for (int i = 0; i < n_particles; i++) {
      addParticle(new Particle(random(width),random(height)));
    }
  }

}
