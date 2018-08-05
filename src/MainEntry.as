/*
    Copyright (c) 2012 milkmidi
    All rights reserved.
    http://milkmidi.com
    http://milkmidi.blogspot.com
*/
package {

  import flash.display.*;
  import flash.events.*;
  import flash.system.Capabilities;
  import milkmidi.coverflow.view.CoverFlowView;
  import net.hires.debug.Stats;
  import swc.Button_mc;
    CONFIG::air{
    import flash.desktop.NativeApplication;
  }

  [SWF(width = "960", height = "640", frameRate = "32", backgroundColor = "#ffffff")]
    public class MainEntry extends Sprite {

    [Embed(source = "copyright2009_white.png")]
    private static const COPRYRIGHT:Class;

    private var _view:CoverFlowView;


    private var _mouseDownX:int;
    private var _currentSelectIndex:int;
    private var prev:Button_mc;
    private var next:Button_mc;
    public function MainEntry() {

      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;


      addChild( new COPRYRIGHT );

      var size:Number = Math.max(1, Capabilities.screenDPI / 160);
      var s:Stats = new Stats;
      s.scaleX = size;
      s.scaleY = size;
      s.y = 44;
      addChild(s);


      CONFIG::air{
        NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE , function ():void {
          NativeApplication.nativeApplication.exit();
        });
      }


      init();
    }
    private function init():void {

      _view = new CoverFlowView();

      _view.antiAlias = 4;
      addChild( _view );
      //


      var dpi:Number = Math.max( 1 , Capabilities.screenDPI / 160 );

      prev = new Button_mc;
      addChild( prev );
      prev.fontSize = 36 * dpi;
      prev.setSize(  210 * dpi , 60 * dpi);
      prev.label = "PREV";
      prev.addEventListener(MouseEvent.CLICK , onClickHandler);


      next = new Button_mc;
      addChild( next );
      next.fontSize = 36 * dpi;
      next.setSize(  210 * dpi , 60 * dpi);
      next.label = "NEXT";
      next.addEventListener(MouseEvent.CLICK , onClickHandler);

      stage.addEventListener(MouseEvent.MOUSE_DOWN , onStageEventHandler);
      stage.addEventListener(Event.RESIZE , onResizeHAndler);
      onResizeHAndler( null );
    }
    private function onClickHandler(e:MouseEvent):void {
      if (e.currentTarget == prev) {
        _view.changeMethod( -1);
      }else {
        _view.changeMethod( 1);
      }
    }

    private function onResizeHAndler(e:Event):void {
      prev.x = 10;
      prev.y = stage.stageHeight - prev.height - 10;

      next.x = stage.stageWidth - next.width - 10;
      next.y = prev.y;
    }

    private function onStageEventHandler(e:MouseEvent):void {
      switch (e.type) {
        case MouseEvent.MOUSE_DOWN:
          _currentSelectIndex = _view.currentSelectIndex;

          _mouseDownX = stage.mouseX;
          stage.addEventListener(MouseEvent.MOUSE_MOVE , onStageEventHandler );
          stage.addEventListener(MouseEvent.MOUSE_UP , onStageEventHandler );
          break;
        case MouseEvent.MOUSE_MOVE:

          var s2:Number = stage.mouseX;
          var distanceX:Number = (_mouseDownX - s2) / 60;

          var nextIndex:Number = _currentSelectIndex + distanceX;
          _view.currentSelectIndex = nextIndex  ;
          break;
        case MouseEvent.MOUSE_UP:
          stage.removeEventListener(MouseEvent.MOUSE_MOVE , onStageEventHandler );
          stage.removeEventListener(MouseEvent.MOUSE_UP , onStageEventHandler );
          _view.validate();
          break;
      }
    }


  }
}


