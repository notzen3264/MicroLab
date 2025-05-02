class Mouse {
  float radius;
  boolean selected;

  Mouse() {
    radius = 75;
    selected = false;
  }

  void update() {
    if (mousePressed && selected && !gui.justPressed && mouseButton == LEFT) {
      noFill();
      stroke(gui.guiStroke);
      strokeWeight(gui.guiStrokeWeight);
      ellipse(mouseX, mouseY, radius * 2, radius * 2);
    }
  }

  boolean inMouse(Particle p) {
    PVector newParticlePos = man.translateCoords(p.pos.x, p.pos.y);
    return (dist(newParticlePos.x, newParticlePos.y, mouseX, mouseY) <= radius) && mousePressed && selected;
  }

  PVector setPos() {
    PVector worldNow = man.reverseTranslateCoords(mouseX, mouseY);
    PVector worldPrev = man.reverseTranslateCoords(pmouseX, pmouseY);
    return PVector.sub(worldNow, worldPrev);
  }
}
