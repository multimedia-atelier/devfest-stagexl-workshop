import 'dart:html' as html;
import 'dart:math';
import 'package:stagexl/stagexl.dart';

void main() {
  _Rorschach r = new _Rorschach();
  r.initGame();
}

class _Rorschach {
  
  var _resourceManager = new ResourceManager();
  Stage _stage;
  
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
    _stage = new Stage(canvas);//, width: bgBitmap.bitmapData.width, height: bgBitmap.bitmapData.height);
    //_stage.scaleMode = StageScaleMode.NO_BORDER;
    //_stage.align = StageAlign.NONE;
    
    var renderLoop = new RenderLoop();
    renderLoop.addStage(_stage);    

    // setup the Stage and RenderLoop    
    _stage.addChild(bgBitmap);
    _stage.addChild(new Bitmap(stainData));
    
    /**
     * 
     * Ukol cislo 2:
     * 
     * Pripravit si pole Bitmap, ktere pak budeme vkladat do stage.
     * Liche bitmapy budeme vkladat pod mys, sude zrcadlove na druhou stranu papiru.
     * 
     * 
     * Ukol cislo 3:
     * 
     * Vyzkouset si udalosti mysi:
     * 
     * _stage.onMouseMove.listen( ... );
     * 
     * ... napriklad print souradnic do konzole. 
     * 
     */

  }

}
