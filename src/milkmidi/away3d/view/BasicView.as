/**
 * @author milkmidi
 * @see http://milkmidi.blogspot.com
 * @version 1.0.1
 * @date created 2012/03/01/
 */
package milkmidi.away3d.view {
  import away3d.containers.View3D;
  import flash.display.Sprite;
  import flash.events.Event;
  public class BasicView extends View3D {

    public function BasicView()  {
      super();
      addEventListener(Event.ADDED_TO_STAGE , _addedToStageHandler);

    }

    private function _addedToStageHandler(e:Event):void {
      stage.align = "tl";
      stage.scaleMode = "noScale";
      removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
      addEventListener(Event.ENTER_FRAME , _onRenderHandler);
      init();

    }

    protected function init():void{

    }

    private function _onRenderHandler(e:Event):void {
      this.render();
      extraRender();
    }

    protected function extraRender():void{

    }
    public function destroy():void {
      removeEventListener(Event.ENTER_FRAME , _onRenderHandler);
    }
    //__________________________________________________________________________________ Private Function
    //__________________________________________________________________________________ EventHandler
    //__________________________________________________________________________________ Get Set
    //__________________________________________________________________________________ Interface
  }//__________________________________________________________________________________ End Class
}//__________________________________________________________________________________ End Package