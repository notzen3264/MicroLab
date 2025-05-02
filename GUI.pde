class GUI {
   Manager man;
   Button menuButton, mouseToolButton, restartButton, newTypesButton, pauseButton, clearButton, renderTypeButton, zoomInButton, zoomOutButton;
   
   int selected = null;
   int frameIndex = 0, fps = 0, lastTime = millis(), time = 0;
   boolean running = true, justPressed = false, isSelected = false;
   
   int guiBase = 50, guiStroke = 150, guiStrokeWeight = 2;
   float guiRadius = 17.5, guiDiameter = guiRadius * 2, space = guiRadius * 2 + 10;
   float guiButtonWidth = 215, guiButtonHeight = 45;
   
   GUI(Manager man) {
      this.man = man;
      float bx = width - (guiButtonWidth + space - guiRadius);
      float bxSmall = width - (60 + space - guiRadius);
      menuButton = new Button(width - (100 + space - guiRadius), 1 * (space - guiRadius), 100, guiButtonHeight, "Menu", true);
      mouseToolButton = new Button(bx, 3 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Mouse");
      restartButton = new Button(bx, 5 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Restart Microenvironment");
      newTypesButton = new Button(bx, 7 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "New Types");
      pauseButton = new Button(bx, 9 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Pause");
      clearButton = new Button(bx, 11 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Clear Microenvironment");
      renderTypeButton = new Button(bx, 13 * (space - guiRadius), guiButtonWidth, guiButtonHeight, "Toggle Render Type");
      
      zoomInButton = new Button(bxSmall, height - 8 * (space - guiRadius), 60, 60, "+", true);
      zoomOutButton = new Button(bxSmall, height - 5 * (space - guiRadius), 60, 60, "-", true);
   }
   
   void update() {
      if (mousePressed && mouseButton == LEFT) {
         if (frameIndex++ % 2 == 0) mouseDown();
      } else if (mousePressed && mouseButton == CENTER && !mouse.isSelected && !selected && selected != 0) {
         mouseDragged();
      } else {
         frameIndex = 0;
         justPressed = false;
      }
      updateFPS();
      display();
   }
   
   void updateFPS() {
      int currentTime = millis();
      if (currentTime - lastTime > 1000) {
         fps = frameCount;
         frameCount = 0;
         lastTime = currentTime;
         time++;
      }
   }
   
   void display() {
      displayTypeSelector();
      displayMenu();
      displayStats();
   }
   
   void displayTypeSelector() {
      colorMode(HSB, 360, 100, 100);
      for (int i = 0; i < man.types.size(); i++) {
         fill(man.types.get(i).c, 100, 100);
         noStroke();
         if (selected != null && selected == i && isSelected) {
            colorMode(RGB, 255, 255, 255);
            stroke(guiStroke);
            strokeWeight(guiStrokeWeight);
         }
         colorMode(HSB, 360, 100, 100);
         ellipse(space + i * space, space, guiDiameter, guiDiameter);
         noStroke();
      }
      colorMode(RGB, 255, 255, 255);
   }
   
   void displayMenu() {
      for (Button b : new Button[]{menuButton, mouseToolButton, restartButton, newTypesButton, pauseButton, clearButton, renderTypeButton, zoomInButton, zoomOutButton})
      b.display();
   }
   
   void displayStats() {
      fill(255);
      textSize(18);
      textAlign(LEFT);
      String[] lines = {
         "Time Elapsed: " + time + "s",
         "FPS: " + fps,
         "Particles: " + man.particles.size(),
         "Types: " + man.types.size(),
         "Max Speed: " + maxSpeed,
         "'Viscosity': " + viscosity,
         "Zoom: " + round(zoom * 1000) / 1000 + "x",
         "X: " + round(offsetX * 100) / 100,
         "Y: " + round(-offsetY * 100) / 100
      };
      
      for (int i = 0; i < lines.length; i++) text(lines[i], space - guiRadius, 100 + (i + 1) * 30 - 30);

textSize(13);
      
      text("MicroLab v1.9.7 |  Download Instructions & Information: https://www.github.com/notzen3264/MicroLab", space - guiRadius, height - 30);
      textAlign(RIGHT);
      text("Blackwell Labs | Scientific Department | Software by @notzen3264", width - (space - guiRadius), height - 30);
   }
   
   void mouseDragged() {
      PVector mouseNow = man.reverseTranslateCoords(mouseX, mouseY);
      PVector mousePrev = man.reverseTranslateCoords(pmouseX, pmouseY);
      Pvector delta = PVector.sub(mouseNow, mousePrev);
      offsetX -= delta.x;
      offsetY -= delta.y;
   }
   
   void mouseDown() {
      PVector pos = new PVector(mouseX, mouseY);
      
      if (clearButton.isClicked()) { man.particles.clear(); time = 0; useInitialParticles = false; return; }
      if (pauseButton.isClicked()) { running = !running; pauseButton.label = running ? "Pause" : "Play"; return; }
      if (mouseToolButton.isClicked()) { selected = null; mouse.selected ^= true; mouseToolButton.isSelected ^= true; return; }
      if (newTypesButton.isClicked()) { man.particles.clear(); man.types.clear(); man.randomTypes(); time = 0; useInitialParticles = true; return; }
      if (restartButton.isClicked()) { man.particles.clear(); time = 0; useInitialParticles = true; return; }
      if (renderTypeButton.isClicked()) { useRect ^= true; renderTypeButton.isSelected ^= true; return; }
      if (menuButton.isClicked()) {
         for (Button b : new Button[]{mouseToolButton, restartButton, newTypesButton, pauseButton, clearButton, renderTypeButton})
         b.isDisplay ^= true;
         menuButton.isSelected ^= true;
         return;
      }
      
      for (int i = 0; i < man.types.size(); i++) {
         if (pos.dist(new PVector(space + i * space, space)) <= guiDiameter && !justPressed) {
            justPressed = true;
            isSelected = !isSelected;
            if (isSelected) {
               selected = i;
            } else {
               selected = null;
            }
            mouse.selected = false;
            mouseToolButton.isSelected = false;
            return;
         }
      }
      
      if (zoomInButton.isClicked()) { zoom *= zoomRate; return; }
      if (zoomOutButton.isClicked()) { zoom /= zoomRate; return; }
      
      if (!mouse.selected && selected != null)
      //PVector mouseCoords = man.translateCoords(mouseX, mouseY);
      man.addParticle(selected, mouseX, mouseY); 
   }
}

class Button {
   float x, y, w, h;
   String label;
   boolean isSelected = false, isDisplay = false;
   
   Button(float x, float y, float w, float h, String label) {
      this(x, y, w, h, label, false);
   }
   
   Button(float x, float y, float w, float h, String label, boolean display) {
      this.x = x;
      this.y = y;
      this.w = w;
      this.h = h;
      this.label = label;
      this.isDisplay = display;
   }
   
   void display() {
      if (!isDisplay) return;
      fill(gui.guiBase);
      if (isSelected) {
         stroke(gui.guiStroke);
         strokeWeight(gui.guiStrokeWeight);
      } else noStroke();
      rect(x, y, w, h);
      fill(255);
      if (label == gui.zoomInButton.label || label == gui.zoomOutButton.label) {
         textSize(35);
      } else {
         textSize(16);
      }
      textAlign(CENTER, CENTER);
      text(label, x + w / 2, y + h / 2);
   }
   
   boolean isMouseOver() {
      return isDisplay && mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
   }
   
   boolean isClicked() {
      if (isMouseOver() && !gui.justPressed) {
         gui.justPressed = true;
         return true;
      } else if (isMouseOver() && (this.label == gui.zoomInButton.label || this.label == gui.zoomOutButton.label)) {
         return true;
      }
      return false;
   }
}
