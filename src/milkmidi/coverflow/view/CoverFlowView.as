package milkmidi.coverflow.view {	
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.events.MouseEvent3D;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import milkmidi.away3d.view.BasicView;
	import milkmidi.coverflow.utils.Assets;
	
	
	public class CoverFlowView extends BasicView {			
		public var currentPlaneIndex:Number = 0.0;
		
		private var _currentSelectIndex		:Number = -1;
		public function set currentSelectIndex( val:Number ):void {
			this._currentSelectIndex = val;

			shiftToItem( this._currentSelectIndex );
		}
		public function get currentSelectIndex():Number {		return _currentSelectIndex;		}		
	
		public var currentDrawingMethodFraction:Number = 0.0;		
		
		private var _indexMax		:int;
		
		private var _planes			:Vector.<Object3D>;
		private var _container3D	:ObjectContainer3D;
		private var _tweenMax		:TweenMax;	
		private var _method			:MyMethod;
		public function CoverFlowView()  {			
			
			
			super();
			this.addEventListener(Event.ADDED_TO_STAGE , onAddedToStageHandler);
			this.backgroundColor = 0xffffff;		
			
		}
	
		
		private function onAddedToStageHandler(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);		
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN  , onStageKeyDownHandler);
			
			this._container3D = new ObjectContainer3D();
			this.scene.addChild( _container3D );			
			
			this._planes = new Vector.<Object3D>();			
			this._method = new MyMethod();			
		
			var length:int = 15;
			for (var i:int = 0; i < length; i++) {
				var _radian	:Number = (2 * Math.PI) / 10 * (10 - i);						
				var _plane:ReflectionPlane = new ReflectionPlane(  new Assets["Texture" + i]);								
				_plane.name = i + "";								
				_plane.addEventListener( MouseEvent3D.MOUSE_DOWN , mouseDownHandler);
				_container3D.addChild(_plane );
				
				_planes.push( _plane );
			}
			
			this._indexMax = length-1;			
			this.currentSelectIndex = 0;
		}
			
		public function changeMethod( pCount:int ):void {
			_method.method += pCount;							
			updateMethod();
			_method.lock = true;
		}
		private function onStageKeyDownHandler(e:KeyboardEvent):void {
			var k:Boolean = false;
			if (e.keyCode == Keyboard.RIGHT) {
				k = true;
				_method.method++;
			}else if( e.keyCode == Keyboard.LEFT ){
				k = true;
				_method.method--;
			}
			if (k) {
				updateMethod();
			}			
		}
		private function updateMethod():void {
			if (_method.lock) {
				return;
			}
			currentDrawingMethodFraction = 0;
			if (_tweenMax != null) {				
				_tweenMax.kill();					
			}			
			_tweenMax = TweenMax.to(this, .8, 
			{ 
				overwrite			:true,
				currentDrawingMethodFraction:1.0, 					
				ease				:Cubic.easeOut,
				onUpdate			:redraw,
				onComplete			:function ():void {
					_method.lock = false;
				}
			} );			
		}
		
		
		public function validate():void {
			this.currentSelectIndex = Math.round( currentSelectIndex);			
			trace( "CoverFlowView.validate" );	
		
		}
	
		
		private function mouseDownHandler(e:MouseEvent3D):void {
			var index:int = e.currentTarget.name / 1;
			this.currentSelectIndex = index;
		}
		private function shiftToItem( pIndex:Number):void {			
			trace( "CoverFlowView.shiftToItem > pIndex : " + pIndex );		
			if (_tweenMax != null) {				
				_tweenMax.kill();					
			}			
			_tweenMax = TweenMax.to(this, .8, 
			{ 
				overwrite			:true,
				currentPlaneIndex	:pIndex, 					
				ease				:Cubic.easeOut,
				onUpdate			:redraw ,
				onComplete			:function ():void {
					_method.lock = false;
				}
			} );			
		}
	
		
		private function redraw():void {			
			var newObj:Object;	
			var oldObj:Object;
			var length:int = _planes.length;
			
			
			var _selectedIcon:Number = currentPlaneIndex;	
			while (_selectedIcon < 0) {							
				_selectedIcon += length;
			}
			_selectedIcon = _selectedIcon % length;	
			var c	:Number = currentDrawingMethodFraction;
			var a	:String;
			var mc	:Object3D;
			var i	:int;
			var equals:Boolean = _method.method == _method.prev;
			
			if (equals) {
				for (i = 0; i < length; i++) {		
					mc = _planes[i];	
					newObj = _method.currentMethod( i , _selectedIcon, length);	
					for (a in newObj) {
						mc[a] = newObj[a];
					}					
				}			
			}else {
				for (i = 0; i < length; i++){
					mc = _planes[i];																			
					newObj = _method.currentMethod( i , _selectedIcon, length);	
					if (c == 1) {
						for (a in newObj) {
							mc[a] = newObj[a];						
						}	
					}else {
						
						oldObj = _method.prevMethod( i , _selectedIcon , length );
						for (a in newObj) {
							mc[a] = fractionValue( c , newObj[a],oldObj[a] );												
						}					
					}				
				}			
			}
			
		
		}
		
		private static function fractionValue (pC:Number ,pNew:Number , pOld:Number):Number {
			return (pC * pNew) + ((1 - pC) * pOld);
		}
	
		
		
	}	
}
import milkmidi.coverflow.utils.MethodUtil;

class MyMethod {
	
	
	public var lock:Boolean = false;
	
	public function get currentMethod():Function {	return METHOD[_method];	}	
	public function get prevMethod():Function {	return METHOD[_prev];	}		
	
	private var _prev:int = 0;	
	public function get prev():int {	return _prev;	}	
	
	private var _method:int = 0;
	public function get method():int {	return _method;	}	
	public function set method(value:int):void {
		
		if (lock) {
			return;
		}
		
		_prev = _method;
		
		_method = value;
		
		if (_method < 0) {
			_method = METHOD.length - 1;
		}
		else if ( _method > METHOD.length - 1) {
			_method = 0;
		}
	}
	
	private static const METHOD:Array = [
		MethodUtil.curveView,
		MethodUtil.coverFlowStyle1,
		MethodUtil.coverFlowStyle2,
		MethodUtil.coverFlowStyle3,
		MethodUtil.spiralView
	];
	
}