import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer audio;
FFT fft;
int numeroMostres= 512;
int iteration = 0;
float mediaModuloFreq = 0.0;

static final int we = 1280;
static final int he = 720;

void setup(){
  size(we, he, P3D);
  minim = new Minim(this);
  audio = minim.loadFile("star trek.mp3",numeroMostres);
  //audio.play();
  fft = new FFT(numeroMostres,audio.sampleRate());
  audio.loop();
}

void draw(){
  background(0);
  stroke(255);
  mediaModuloFreq = 0.0;
  fft.forward(audio.mix);
  println(fft.getBand(iteration));
  for(int f=0; f < numeroMostres/2; f++){
    line(iteration, he, iteration, he - 50*fft.getBand(iteration));
    if(f<20){
      mediaModuloFreq += fft.getBand(f);
    }
  }
  mediaModuloFreq = mediaModuloFreq/19.0;
  println("Media modulo:"+mediaModuloFreq);
  iteration++; 
  pushMatrix();
    translate(we/2, he/2, 0);
    rotateY(millis()*0.001);
    rotateZ(-millis()*0.001);
    rotateX(millis()*0.001);
    fill((mediaModuloFreq*255)%255, 100, 0);
    scale(1 + mediaModuloFreq/5);
    box(40);
    pushMatrix();
      translate(0, -he/4, 0);
      if(iteration % 40 < 15 && iteration % 40 > 5){
        box(40);
      }else{
        sphere(30);
      }
    popMatrix();
    pushMatrix();
      translate(0, +he/4, 0);
      if(iteration % 40 > 10 && iteration % 40 < 20){
        box(40);
      }else{
        sphere(30);
      }
    popMatrix();
  popMatrix();
}

void keyPressed(){
  audio.rewind();
  audio.play();
}
