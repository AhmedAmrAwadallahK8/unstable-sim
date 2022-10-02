class Universe{
  ArrayList<Particle> particles;
  IntList usedParticlesIndices;
  
  Universe(){
    particles = new ArrayList<Particle>();
    usedParticlesIndices = new IntList();
  }
  
  void run(){
    //shuffleParticles();
    for(Particle p: particles){
      p.run(particles);
    }
    for(Particle p: particles){
      p.update();
    }
  }
  
  void render(){
    for(Particle p: particles){
      p.render();
    }
  }
  
  void shuffleParticles(){
    ArrayList<Particle> shuffledParticles = new ArrayList<Particle>();
    int randIndex;
    
    for(int i = 0; i < particles.size(); i++){
      randIndex = getValidRandomIndex();
      usedParticlesIndices.append(randIndex);
      Particle randParticle = particles.get(randIndex);
      shuffledParticles.add(randParticle);
    }
    
    particles = shuffledParticles;
    usedParticlesIndices.clear();
  }
  
  
  int getValidRandomIndex(){
    int randIndex;
    randIndex = getRandomValueFromZeroToX(particles.size());
    while(indexUsedAlready(randIndex)){
      randIndex = getRandomValueFromZeroToX(particles.size());
    }
    return randIndex;
  }
  
  boolean indexUsedAlready(int ind){
    return usedParticlesIndices.hasValue(ind);
    
  }
  
  int getRandomValueFromZeroToX(int x){
    return int(random(x));
  }
  
  void addParticle(Particle p){
    particles.add(p);
    
  }
  
  void addParticleWithRandomV(Particle p){
    p.setVelocityRandom();
    particles.add(p);
  }
  
  void addNRandomlyPlacedParticles(int n_particles){
    for (int i = 0; i < n_particles; i++) {
      Particle newParticle = new Particle(random(width),random(height));
      addParticle(newParticle);
    }
  }

}
