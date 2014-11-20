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
  double DISTANCE_DELTA;
  double STAGE_CENTER_X;
  
  var _resourceManager = new ResourceManager();
  Stage _stage;
  
  List<Bitmap> STAINS = [];  
  int _stainPointer = 0; 
  
  int _lastEventTime = 0;
  int _nowTime = 0;
  
  Event _lastEvent;

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

    DISTANCE_DELTA = bgBitmap.bitmapData.width * 0.03;

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

    _stage.onMouseMove.where(_timeToPlaceFilter).listen(_placeStain);
    _stage.onTouchBegin.where(_timeToPlaceFilter).listen(_placeStain);
    _stage.onTouchMove.where(_timeToPlaceFilter).listen(_placeStain);

  }

  /**
   * Je čas plácnout na canvas skvrnu.
   */
  void _placeStain(Event event) {

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

    // a schovame ocasek
    _disappear(STAINS[_stainPointer * 2]);
    _disappear(STAINS[_stainPointer * 2 + 1]);

    _lastEvent = event;
    _lastEventTime = _nowTime;
  }

  /**
   * Filtr, který používáme na Stream, abychom nepokladali fleky prilis casto.
   */
  bool _timeToPlaceFilter(Event event) {
    _nowTime = new DateTime.now().millisecondsSinceEpoch;    
    return (_nowTime - _lastEventTime > MINIMUM_DELAY && _distance(_lastEvent, event) > DISTANCE_DELTA);
  }

  /**
   * Vzdalenost aktualni udalosti od posledni pozice.
   */
  double _distance(Event lastEvent, Event event) {
    if (lastEvent == null) return double.MAX_FINITE;
    return sqrt(pow(event.stageX - lastEvent.stageX, 2) + pow(event.stageY - lastEvent.stageY, 2));
  }

  void _appear(DisplayObject object, double x, double y, double rotation) {
    object.visible = true;
    object.x = x;
    object.y = y;
    object.rotation = rotation;
    object.alpha = 0;

    Tween t = new Tween(object, 0.5, TransitionFunction.easeOutQuartic);
    t.animate.alpha.to(1);
    _stage.renderLoop.juggler.add(t);
  }

  void _disappear(DisplayObject object) {
    if (object.visible) {
      object.alpha = 1;
      Tween t = new Tween(object, MINIMUM_DELAY * 0.8 / 1000, TransitionFunction.easeOutQuartic);
      t.animate.alpha.to(0);
      _stage.renderLoop.juggler.add(t);
    }
  }

}
