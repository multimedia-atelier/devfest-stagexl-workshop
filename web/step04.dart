import 'dart:html' as html;
import 'dart:math';
import 'package:stagexl/stagexl.dart';


int STAINS_COUNT = 18;

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
  int _stainPointer = 0; 
  
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
    Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;    
    
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

    STAGE_CENTER_X = bgBitmap.bitmapData.width / 2;

    _stage.onMouseMove.listen(_placeStain);
    
  }

  /**
   * Je čas plácnout na canvas skvrnu.
   */
  void _placeStain(MouseEvent event) {

    double rotation = _randomGenerator.nextDouble() * 3.14;
    double x = event.stageX;
    double y = event.stageY;
    
    // pozice vuci stredu canvasu
    double relativeX = x - STAGE_CENTER_X;

    // prava skvrna
    _appear(STAINS[_stainPointer * 2], STAGE_CENTER_X + relativeX, y, rotation);
    _appear(STAINS[_stainPointer * 2 + 1], STAGE_CENTER_X - relativeX, y, -rotation);

    // presunem ukazatel na dalsi, coz je aktualni ocasek
    _stainPointer = (_stainPointer + 1) % STAINS_COUNT;

  }

  void _appear(DisplayObject object, double x, double y, double rotation) {
    object.visible = true;
    object.x = x;
    object.y = y;
    object.rotation = rotation;
  }
  
  /**
   * 
   * Ukol cislo: Uz nevim kolik
   * 
   * Stream onMouseMove filtrovat funkci, ktera nepusti udalost castneji nez jednou za 100ms a jen pokud doslo k posunu
   * alespon o 5% sirky stage.
   * 
   * 
   * Ukol cislo: Uz nevim kolik + 1
   * 
   * Objevovat fleky fade-in animaci (alpha = 0->1)
   * 
   * Ukol cislo: Uz nevim kolik + 2  (Bonus)
   * 
   * Mizet fleky na ocasku.
   * 
   */  

}
