void SR3D(){
  strokeWeight(3);
  
  // asse x
  stroke(RED);
  line(0, 0, lenAxis, 0); 
  
  // asse y
  stroke(GREEN);
  line(0,0,0,lenAxis);
  
  //asse z
  stroke(LIGHT_BLUE);
  line(0,0,0,0,0,lenAxis);
  
  stroke(0);
  strokeWeight(1);
  
}

void drawCylinder( int sides, float r, float h)
    {
        float angle = 360 / sides;
        float halfHeight = h / 2;

        // draw top of the tube
        beginShape();
        for (int i = 0; i < sides; i++) {
            float x = cos( radians( i * angle ) ) * r;
            float y = sin( radians( i * angle ) ) * r;
            vertex( x, y, -halfHeight);
        }
        endShape(CLOSE);

        // draw bottom of the tube
        beginShape();
        for (int i = 0; i < sides; i++) {
            float x = cos( radians( i * angle ) ) * r;
            float y = sin( radians( i * angle ) ) * r;
            vertex( x, y, halfHeight);
        }
        endShape(CLOSE);

        // draw sides
        beginShape(TRIANGLE_STRIP);
        for (int i = 0; i < sides + 1; i++) {
            float x = cos( radians( i * angle ) ) * r;
            float y = sin( radians( i * angle ) ) * r;
            vertex( x, y, halfHeight);
            vertex( x, y, -halfHeight);    
        }
        endShape(CLOSE);

    }
