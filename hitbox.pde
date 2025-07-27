class Hitbox {
  float x, y, z;
  float w, h, d;
  boolean isDanger;
  
  Hitbox(float x, float y, float z, float w, float h, float d, boolean isDanger) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    this.h = h;
    this.d = d;
    this.isDanger = isDanger;
  }
  
  void draw() {
    noFill();
    push();
      translate(this.x, this.y, this.z);
      if (isDanger)
        stroke(255, 0, 0);
      else
        stroke(0, 0, 255);
      box(this.w, this.h, this.d);
    pop();
  }
  
  boolean collide(Player player) {
    return (
      player.x + 0.5 * player.size >= this.x - 0.5 * this.w &&
      player.x - 0.5 * player.size <= this.x + 0.5 * this.w &&
      player.y + 0.5 * player.size >= this.y - 0.5 * this.h &&
      player.y - 0.5 * player.size <= this.y + 0.5 * this.h &&
      player.z + 0.5 * player.size >= this.z - 0.5 * this.d &&
      player.z - 0.5 * player.size <= this.z + 0.5 * this.d
    );
  }
}
