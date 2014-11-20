import 'dart:html' as html;
import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';

void main() {
  _Rorschach r = new _Rorschach();
  r.runGame();
}

class _Rorschach {
  
  static const int REPEAT = 100;
  
  Stage _stage;

  runGame() {
    
    // inicializace StageXL
    var canvas = html.querySelector('#stage');
    _stage = new Stage(canvas);
    var renderLoop = new RenderLoop();
    renderLoop.addStage(_stage);    
    
    // ukazkovy objekt
    var shape = new Shape();
    shape.graphics.rect(0, 0, 50, 50);
    shape.graphics.fillColor(Color.Red);
    shape.x = 100;
    shape.y = 100;
    _stage.addChild(shape);
    
    // a nejaka ta animace
    Tween t = new Tween(shape, REPEAT * 1, TransitionFunction.linear);
    t.animate.rotation.to(REPEAT * math.PI);
    _stage.renderLoop.juggler.add(t);
    
    // shape.pivotX = 25;
    // shape.pivotY = 25;
    
    /* 
     * 
     * Ukol cislo 1:
     * 
     * Pomoci ResourceManageru stahnout obrazek "stain.png" a jako objekt Bitmap ho vlozit na stage.
     * 
     * Bude se vam hodit:
     * 
     * new ResourceManager()
     *  ..addBitmapData("jmeno", "url")
     * 
     * a
     * 
     * resourceManager.load().then( ... )
     * 
     */

  }

}