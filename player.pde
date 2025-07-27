class Player {
  float x, y, z;
  float vx, vy, vz;
  float size;
  float fallTime;
  World world;
  Player(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.vx = 0;
    this.vy = 0;
    this.vz = 0;
    this.size = 50;
    this.fallTime = 0;
  }
  
  void draw() {
    push();
      translate(this.x, this.y, this.z);
      fill(255, 0, 0);
      box(50);
    pop();
  }
  
  CollisionState collide() {
    for (Hitbox hitbox : world.hitboxes) {
      if  (hitbox.collide(this)) {
        if (hitbox.isDanger) return CollisionState.IN_DANGER;
        return CollisionState.IN_SURFACE;
      }
    }
    return CollisionState.IN_AIR;
  }
  
  boolean moveSteps(int numSteps) {
    this.fallTime++;
    float prevX = this.x;
    float prevY = this.y; 
    float prevZ = this.z;
    for (int i = 0; i < numSteps; i++) {
      this.x += this.vx / numSteps;
      
      if (this.collide() == CollisionState.IN_SURFACE) {
        this.x = prevX;
        this.vx = 0;
      }
      
      if (this.collide() == CollisionState.IN_DANGER) return false;
      
      prevX = this.x;
      
      this.y += this.vy / numSteps;
      
      if (this.collide() == CollisionState.IN_SURFACE) {
        this.y = prevY;
        this.fallTime = 0;
        this.vy = 0;
      }
      
      if (this.collide() == CollisionState.IN_DANGER) return false;
      
      prevY = this.y;
      
      this.z += this.vz / numSteps;
      
      if (this.collide() == CollisionState.IN_SURFACE) {
        this.z = prevZ;
        this.vz = 0;
      }
      
      if (this.collide() == CollisionState.IN_DANGER) return false;
      
      prevZ = this.z;
    }
    
    return true;
  }
  
  boolean update() {
    if (keys[65]) {
      this.vx -= cos(camYaw);
      this.vz -= sin(camYaw);
    }
    if (keys[68]) {
      this.vx += cos(camYaw);
      this.vz += sin(camYaw);
    }
    
    if (keys[87]) {
      this.vx += sin(camYaw);
      this.vz -= cos(camYaw);
    }
    if (keys[83]) {
      this.vx -= sin(camYaw);
      this.vz += cos(camYaw);
    }
    
    if (keys[32] && this.fallTime <= 4) this.vy = -10;

    this.vx *= 0.9;
    this.vz *= 0.9;
    this.vy++;
    
    return this.moveSteps(10);
  }
}
