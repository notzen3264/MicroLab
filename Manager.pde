class Manager {
   ArrayList<Type> types = new ArrayList<Type>();
   ArrayList<Particle> particles = new ArrayList<Particle>();
   float collisionSoftness = 1;
   
   void show() {
      for (Particle particle: particles) {
         particle.show();
      }
   }
   
   void update() {
      background(0);
      
      for (Particle p : particles) {
         p.wrapParticles();
         p.update(particles);
         /*Experimental extremely unperformant collision handling module*/
         if (useHandleCollisions) {
            handleCollisions();
         }
      }
      
      generateInitialParticles();
      show();
   }
   
   void handleCollisions() {
      for (int i = 0; i < particles.size(); i++) {
         Particle a = particles.get(i);
         for (int j = i+1; j < particles.size(); j++) {
            Particle b = particles.get(j);
            
            PVector wrappedBPos = a.getShortestDistance(b.pos);
            PVector delta = PVector.sub(wrappedBPos, a.pos);
            float distance = delta.mag();
            float minDist = a.type.typeRadius + b.type.typeRadius;
            
            if (distance < minDist && distance > 0) {
               delta.normalize();
               
               float overlap = (minDist - distance);
               float totalMass = a.type.typeRadius + b.type.typeRadius;
               float displace = overlap  ;
               float angle = 0;
               
               delta.rotate((angle / 1000) / (a.type.typeRadius / b.type.typeRadius));
               
               a.pos.sub(PVector.mult(delta, displace * (a.type.typeRadius / totalMass)));
               b.pos.add(PVector.mult(delta, displace * (b.type.typeRadius / totalMass)));
            }
         }
      }
   }
   
   void addParticle(int type, float x, float y)
   {
      particles.add(new Particle(type, new PVector(x, y), types));
   }
   
   void addType(color c, float typeRadius, float[] attraction, float[] middle, float[] repelDist)
   {
      types.add(new Type(c, typeRadius, attraction, middle, repelDist, types));
   }  
   
   void randomParticles(int num, float rad)
   {
      for (int i = 0; i < num; i++)
      {
         float u = 1;
         float x = random(-u, u);
         float y = random(-sqrt(1 - x*x), sqrt(1 - x*x));
         addParticle((int) random(0, types.size()), width/2 + x*rad, height/2 + y*rad);
      }
   }
   
   void randomTypes()
   {
      int len = (int) random(3, 16);
      for (int i = 0; i < len; i++)
      {
         
         float[] a = makeArray(-3*worldScale, 3*worldScale, len);
         float[] m = makeArray(15*worldScale, 80*worldScale, len);

         float t = 6*worldScale;
         
         float[] r = makeArray(4*worldScale, random(25*worldScale, 128*worldScale), len);
         
         color c = color(random(35, 255), random(35, 255), random(35, 255));
         
         man.addType(c, t, a, m, r);
      }
   }
   
   float[] makeArray(float lower, float upper, int len)
   {
      float[] arr = new float[len];
      
      for (int i = 0; i < len; i++)
      {
         arr[i] = random(lower, upper);
      }
      
      return arr;
   }
   
   void generateInitialParticles() {
      if (gui.running) {
         if (currentParticles < initialParticlesNum) {
            if (useInitialParticles) {
               if (useInstant) {
                  man.randomParticles(initialParticlesNum, 425);
                  currentParticles += initialParticlesNum;
               } else {
                  int step = (int) random(0, 2);
                  man.randomParticles(step, 425);
                  currentParticles += step;
               }
            }
         } else {
            useInitialParticles = false;
         }
      }
   }
}
