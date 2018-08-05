/**
 * @author milkmidi
 * @see $(See)
 * @version $(Version)
 * @date created 2011/11/02/
 */
package milkmidi.coverflow.view {
  import away3d.containers.ObjectContainer3D;
  import away3d.entities.Mesh;
  import away3d.events.MouseEvent3D;
  import away3d.materials.TextureMaterial;
  import away3d.primitives.PlaneGeometry;
  import away3d.textures.BitmapTexture;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Loader;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  public class ReflectionPlane extends ObjectContainer3D {

    //__________________________________________________________________________________ Constructor
    private var _material:TextureMaterial;
    public function ReflectionPlane( pTexture:Bitmap ) {

      var originBmd:BitmapData = pTexture.bitmapData;

      var bmd:BitmapData = new BitmapData( 256, 256, false );
      bmd.copyPixels( originBmd, new Rectangle( 0, 0, 256, 256 ), new Point );
      _material = new TextureMaterial( new BitmapTexture( bmd ) )

      var geo:PlaneGeometry = new PlaneGeometry( 256, 256, 1, 1, false );
      //geo.doubleSided = true;
      //Bug?

      var plane:Mesh = new Mesh( geo, _material );
      plane.mouseEnabled = true;

      plane.addEventListener( MouseEvent3D.CLICK, dispatchEvent );
      addChild( plane );

      plane = plane.clone() as Mesh;
      plane.rotationY = 180;
      addChild( plane );
    }



    public function get alpha():Number {	return _material.alpha;		}
    public function set alpha( value:Number ):void {
      _material.alpha = value;
    }



  } //__________________________________________________________________________________ End Class
} //__________________________________________________________________________________ End Package