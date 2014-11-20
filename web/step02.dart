import 'dart:html' as html;
import 'dart:math';
import 'package:stagexl/stagexl.dart';


int STAINS_COUNT = 18;
int MINIMUM_DELAY = 100;


void main() {
  _Rorschach r = new _Rorschach();
  r.initGame();
}

class _Rorschach {
  
  Random _randomGenerator = new Random();
  double STAGE_CENTER_X;
  
  var _resourceManager = new ResourceManager();
  Stage _stage;
  
  List<Bitmap> STAINS = [];  

  initGame() {       
    _resourceManager
        ..addBitmapData("bg", "bg.jpg")
        ..addBitmapData("stain", "stain.png");
    _resourceManager.load().then(_runGame);
  }

  _runGame(_) {

    var bgBitmap = new Bitmap(_resourceManager.getBitmapData("bg"));
    var stainData = _resourceManager.getBitmapData("stain");
    
    var canvas = html.querySelector('#stage');
    _stage = new Stage(canvas, width: bgBitmap.bitmapData.width, height: bgBitmap.bitmapData.height);
    _stage.scaleMode = StageScaleMode.NO_BORDER;
    _stage.align = StageAlign.NONE;
    
    var renderLoop = new RenderLoop();
    renderLoop.addStage(_stage);        

    // setup the Stage and RenderLoop    
    _stage.addChild(bgBitmap);

    double stainPx = stainData.width / 2;
    double stainPy = stainData.height / 2;

    for (int a = 0; a < 2 * STAINS_COUNT; a++) {
      Bitmap stain = new Bitmap(stainData);
      stain.visible = false;
      stain.pivotX = stainPx;
      stain.pivotY = stainPy;

      if (a % 2 == 1) {
        // zrcadlove prevracene skrvrny na druhe strane
        stain.scaleX = -1;
      }

      STAINS.add(stain);
      _stage.addChild(stain);
    }
    
    /**
     * Ukol cislo 4:
     * 
     * Poslouchat udalosti mysi a pod kurzor vzdy placnout bitmapu a nahodne ji natocit.
     * 
     */
    
  }

}
