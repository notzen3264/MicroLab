class Manager {
   ArrayList<Type> types = new ArrayList<Type>();
   ArrayList<Particle> particles = new ArrayList<Particle>();
   float collisionSoftness = 1;
   
   void display() {
      background(5);
      for (Particle particle : particles) {
         particle.display();
      }
      renderBounds();
   }
   
   void update() {
      setOrigin();
      
      for (Particle p : particles) {
         p.wrapParticles();
         p.update(particles);
      }
      display();
      initialParticles();
   }
   
   void addParticle(int type, float x, float y) {
      PVector newPos = reverseTranslateCoords(x, y);
      particles.add(new Particle(type, new PVector(newPos.x, newPos.y), types));
   }
   
   void addType(color c, float typeRadius, float[] attraction, float[] middle, float[] repelDist) {
      types.add(new Type(c, typeRadius, attraction, middle, repelDist, types));
   }
   
   void randomParticles(int num, float rad) {
      for (int i = 0; i < num; i++) {
         float u = 1;
         float x = random(-u, u);
         float y = random(-sqrt(1 - x * x), sqrt(1 - x * x));
         addParticle((int) random(0, types.size()), width / 2 + x * rad, height / 2 + y * rad);
      }
   }
   
   void randomTypes() {
      gui.selected = null;
      int len = (int) random(3, 16);
      for (int i = 0; i < len; i++) {
         float[] a = makeArray(-3 * worldScale, 3 * worldScale, len);
         float[] m = makeArray(15 * worldScale, 80 * worldScale, len);
         
         float t = random(3, 6) * worldScale;
         
         float[] r = makeArray(2 * worldScale, random(25 * worldScale, 64 * worldScale), len);
         
         float c = 360 / len * i;
         
         man.addType(c, t, a, m, r);
      }
   }
   
   float[] makeArray(float lower, float upper, int len) {
      float[] arr = new float[len];
      
      for (int i = 0; i < len; i++) {
         arr[i] = random(lower, upper);
      }
      
      return arr;
   }
   
   void initialParticles() {
      float generateRadius = (PI - 3) * initialParticlesNum * worldScale * random(3, 8);
      if (gui.running) {
         if (man.particles.size() < initialParticlesNum) {
            if (useInitialParticles) {
               if (useInstant) {
                  man.randomParticles(initialParticlesNum, generateRadius * zoom);
               } else {
                  man.randomParticles(1, generateRadius * zoom);
               }
            }
         } else {
            useInitialParticles = false;
         }
      }
   }
   
   void setOrigin() {
      originX = width / 2 + offsetX;
      originY = height / 2 + offsetY;
   }
   
   void renderBounds() {
      PVector topLeft = translateCoords(0, 0);
      noFill();
      stroke(gui.guiStroke);
      strokeWeight(gui.guiStrokeWeight);
      rect(topLeft.x, topLeft.y, width * zoom, height * zoom);
      ellipse(width / 2, height / 2, 15, 15);
   }
   
   PVector translateCoords(float x, float y) {
      float tx = ((x - originX) * zoom) + originX - offsetX;
      float ty = ((y - originY) * zoom) + originY - offsetY;
      return new PVector(tx, ty);
   }
   
   PVector reverseTranslateCoords(float x, float y) {
      float wx = ((x + offsetX - originX) / zoom) + originX;
      float wy = ((y + offsetY - originY) / zoom) + originY;
      return new PVector(wx, wy);
   }
}
