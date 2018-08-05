package milkmidi.coverflow.utils {
  import flash.filters.ColorMatrixFilter;
  public class MethodUtil {

    private static const WIDTH	:int = 960;
    private static const HEIGHT	:int = 960;
    private static const EXTRA_SCALE	:Number = 1;
    private static const FOCAL_LENGTH	:Number = 250;

    private static var radius	:int = 450;
    private static const SPACE	:int = 120;

    public static const RADIAN_2_DEGREE:Number = 57.29577951308232;
    public static const DEGREE_2_RADIAN:Number = 0.017453292519943295;



    public static function curveView(i:Number, selected:Number, tot:Number):Object {
      var obj			:Object = getBaseObject();
      var distance	:Number = getDistance(i, selected, tot);
      var f			:Number = getFraction(i, selected, tot);

      var z			:Number = -(Math.cos(f * Math.PI) * 60);
      var angleUtil	:Number = Math.PI * 2 / tot;

      var f2			:Number = distance * angleUtil + ( -90 * DEGREE_2_RADIAN);


      obj.x = Math.cos( f2 ) * radius;
      obj.y = Math.sin( f2 ) * radius;
      obj.z = z;


      obj.scaleX = 0.5 * (1-Math.abs(f));
      obj.scaleY = obj.scaleX;



      obj.rotationZ = distance * angleUtil * 180 / Math.PI;
      if (Math.abs(distance) > 1) {
        //obj.alpha += (1 - Math.abs(distance)) * 0.3;
      }
      if (Math.abs(distance) < 1) {
        obj.scaleX += (1 - Math.abs(distance)) * 0.7;
        obj.scaleY = obj.scaleX;
      }
      return obj;
    }
    private static function getBaseObject():Object{
      return {
        x:0,
        y:0,
        z:0,
        rotationX:0,
        rotationY:0,
        rotationZ:0,
        scaleX:1,
        scaleY:1,
        alpha	:1,
        visible:true
      };
    }
    public static function spiralView(i:Number, selected:Number, tot:Number):Object {
      // 3d spiral view, based on the circle view
      var obj			:Object = getBaseObject();
      var distance:Number = getDistance(i, selected, tot);
      var f:Number = getFraction(i, selected, tot);
      var generalScale:Number = 5;
      var x:Number = (Math.sin(f * Math.PI) * 60);
      var y:Number = f * 90;
      var z:Number = -(Math.cos(f * Math.PI) * 60) + 180;
      var scaleRatio:Number = (FOCAL_LENGTH / z) * generalScale;
      obj.x = x * scaleRatio;
      obj.y = y * scaleRatio;

      obj.scaleX = (1 - Math.abs(f)) * 0.7;
      obj.scaleY = obj.scaleX;
      obj.rotationZ = 0;
      obj.rotationY = f *180;
      obj.z = (1 - Math.abs(f)) * 2.5 * -100;

      if (Math.abs(distance) < 1) {
        obj.scaleX += (1 - Math.abs(distance)) * 0.7;
        obj.scaleY = obj.scaleX;
      }
      return obj;
    }

    public static function coverFlowStyle1(i:Number, selected:Number, tot:Number):Object {
      var obj			:Object = getBaseObject();
      var distance	:Number = getDistance(i , selected, tot);
      var absDistance	:Number = Math.abs( distance );
      var f			:Number = getFraction( i , selected, tot);

      var angleUtil	:Number = Math.PI * 2 / (tot);

      var f2			:Number = distance * angleUtil + ( -90 * DEGREE_2_RADIAN);

      //var fPI			:Number = f * Math.PI;
      var x:Number = Math.sin( distance * angleUtil ) * radius;
      var y:Number = 0;
      var z:Number = Math.cos( distance * angleUtil ) * radius;

      obj.rotationY = distance * angleUtil * RADIAN_2_DEGREE + 90;
      obj.x = x;
      obj.y = y;
      obj.z = z;

      if ( absDistance > 3) {
        //obj.visible = false;
      }else {
        //obj.visible = true;
      }
      if ( absDistance < 1) {
        obj.rotationY += ((1 - Math.abs(distance)) * 90);
        //obj.scaleX = (1 - absDistance) * 2;
        //obj.scaleY = obj.scaleX;
        obj.z += (1 - absDistance) * -550;
      }


      return obj;
    }

    public static function coverFlowStyle2(i:Number, selected:Number, tot:Number):Object {
      var obj			:Object = getBaseObject();
      var distance	:Number = getDistance(i , selected, tot);
      var absDistance	:Number = Math.abs( distance );
      var f			:Number = getFraction( i , selected, tot);
      var angleUtil	:Number = Math.PI * 2 / tot;

      var f2			:Number = distance * angleUtil + ( 180 * DEGREE_2_RADIAN);

      var x:Number = Math.sin( f2 ) * radius;
      var y:Number = 0;
      var z:Number = Math.cos( f2 ) * radius;
      obj.rotationY = f2 * RADIAN_2_DEGREE + 90;
      obj.x = x;
      obj.y = y;
      obj.z = z;
      obj.alpha = 1 - Math.abs(f);
      if ( absDistance > 3) {
        //obj.visible = false;
      }else {
        //obj.visible = true;
      }
      if ( absDistance < 1) {
        obj.rotationY += ((1 - Math.abs(distance)) * 90);
        obj.z += (1 - absDistance) * -200;
      }


      return obj;
    }

    public static function coverFlowStyle3(i:Number, selected:Number, tot:Number):Object {
      var obj			:Object = getBaseObject();
      var distance	:Number = getDistance(i, selected, tot);
      var absDis		:Number = Math.abs(distance);
      var resDis		:Number = 1 - absDis;
      var f			:Number = getFraction( i , selected, tot);
      obj.x = 200 * distance;
      if (distance > 0) 		obj.x += SPACE;
      else if (distance < 0) 	obj.x -= SPACE;

      obj.y = 0;
      obj.z = Math.abs(distance) * 150;
      obj.scaleX = 1;
      obj.scaleY = 1
      obj.rotationY = (distance > 0) ? 45 : -45;
      obj.alpha = 1 - Math.abs(f);
      if (absDis < 1) {
        obj.scaleX += resDis * .6;
        obj.scaleY = obj.scaleX;
        obj.z += resDis * -300;

        if (distance > 0) 	{
          obj.rotationY -= resDis * 45;
          //obj.rotationY += resDis * 180;
          obj.x -= resDis * SPACE
        }else if (distance <0) {
          obj.rotationY += resDis * 45
          obj.rotationY -= resDis * 180;
          obj.x += resDis * SPACE
        }else {
          obj.rotationY += resDis * 45;
        }

      }
      return obj;

    }


    private static function getFraction(i:Number, selected:Number, tot:Number):Number {
      // Based on the current position, returns the F (-1 to 1) of the current item (i) which is its distance to the selected item
      var f:Number;
      f = i - selected;
      f /= tot / 2;
      while (f < -1) f += 2;
      while (f > 1)  f -= 2;
      return f;
    }
    private static function getDistance(i:Number, selected:Number, tot:Number):Number {
      // Normalized distance from the current item (i) to the selected item
      var _distance:Number = i - selected;
      if (_distance > tot / 2) 	_distance -= tot;
      if (_distance < -tot / 2) 	_distance += tot;
      return _distance;
    }
  }
}