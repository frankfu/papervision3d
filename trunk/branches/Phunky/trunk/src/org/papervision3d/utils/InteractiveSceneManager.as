/**
* ...
* @author John Grden
* @version 0.1
*/

package org.papervision3d.utils 
{
	import com.blitzagency.xray.logger.XrayLog;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.papervision3d.core.geom.renderables.Triangle3D;
	
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.render.hit.RenderHitData;
	import org.papervision3d.core.render.InteractiveRendererEngine;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.objects.DisplayObject3D;
	
	import org.papervision3d.utils.virtualmouse.VirtualMouse;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.proto.SceneObject3D;
	import org.papervision3d.events.RendererEvent;
	import org.papervision3d.materials.MovieMaterial;

	public class InteractiveSceneManager extends EventDispatcher
	{
		/**
		* MOUSE_IS_DOWN is a quick static property to check and is maintained by the ISM
		*/
		public static var MOUSE_IS_DOWN								:Boolean = false;
		
		/**
		* VirtualMouse is used with faceLevelMode of ISM or DO3D's.  Its a virtual mouse that causes the objects in your materials movieclip containers to fire off their mouse events such as click, over, out, release, press etc
		 * </p>
		 * <p>
		 * Using these events requires you only to do what you normally do - establish listeners with your objects like you normally would, and you'll receive them!
		*/		
		public var virtualMouse										:VirtualMouse = new VirtualMouse();
		
		public var scene											:SceneObject3D;
		
		/**
		* Main container for ISM to create the sub InteractiveSprite containers for the faces and DO3D objects passed in during the render loop
		*/		
		public var container										:Sprite;
		
		public var camera											:CameraObject3D;
		
		public var renderHitData									:RenderHitData;	
		
		public var currentDisplayObject3D							:DisplayObject3D;
		
		public var currentMaterial									:MaterialObject3D;
		
		public var debug											:Boolean = false;
		
		protected var point											:Point = new Point();
		
		/**
		* @private
		*/		
		protected var log											:XrayLog = new XrayLog();
		
		public function InteractiveSceneManager(scene:SceneObject3D, container:Sprite, camera:CameraObject3D) 
		{
			this.scene = scene;
			this.container = container;
			this.camera = camera;
			
			init();
		}
		
		public function init():void
		{		
			if( container )
			{
				if( container.stage )
				{
					initVirtualMouse();
					initListeners();
				}else
				{
					container.addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
				}				
			}
		}
		
		/**
		 * @private
		 * @param e
		 * 
		 */		
		protected function handleAddedToStage(e:Event):void
		{
			//container.stage.addEventListener(MouseEvent.MOUSE_UP, handleReleaseOutside);
			
			initVirtualMouse();			
			initListeners();
		}
		
		protected function initVirtualMouse():void
		{
			// set the virtualMouse stage
			virtualMouse.stage = container.stage;
			virtualMouse.container = container; // might set this to stage later
		}
		
		protected function initListeners():void
		{
			// setup listeners
			container.addEventListener(MouseEvent.MOUSE_DOWN, handleMousePress);
			container.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
			container.addEventListener(MouseEvent.CLICK, handleMouseClick);
			container.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			container.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			container.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			InteractiveRendererEngine(scene.renderer).addEventListener(RendererEvent.RENDER_DONE, handleRenderDone);
		}
		
		protected function handleRenderDone(e:RendererEvent):void
		{
			point.x = container.mouseX;
			point.y = container.mouseY;
			
			renderHitData = e.renderSessionData.renderer.hitTestPoint2D(point) as RenderHitData;
			
			if( renderHitData )
			{
				currentDisplayObject3D = renderHitData.displayObject3D;
				currentMaterial = renderHitData.material;
			}
		}
		
		/**
		 * Handles the MOUSE_DOWN event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMousePress(e:MouseEvent):void
		{
			MOUSE_IS_DOWN = true;
			if( virtualMouse ) virtualMouse.press();
			if( renderHitData ) dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_PRESS);
		}
		/**
		 * Handles the MOUSE_UP event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseRelease(e:MouseEvent):void
		{
			MOUSE_IS_DOWN = false;
			if( virtualMouse ) virtualMouse.release();
			if( renderHitData ) dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_RELEASE);
		}
		/**
		 * Handles the MOUSE_CLICK event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseClick(e:MouseEvent):void
		{
			if( renderHitData ) dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_CLICK);
		}
		/**
		 * Handles the MOUSE_OVER event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseOver(e:MouseEvent):void
		{
			if( renderHitData ) dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_OVER);
		}
		/**
		 * Handles the MOUSE_OUT event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseOut(e:MouseEvent):void
		{
			//if( VirtualMouse && ( faceLevelMode || DisplayObject3D.faceLevelMode ))
			if( VirtualMouse && renderHitData )
			{
				try
				{					
					var bitmap:BitmapData = currentMaterial.bitmap;
					var rect:Rectangle = new Rectangle(0, 0, bitmap.width, bitmap.height);
					var contains:Boolean = rect.contains(renderHitData.u, renderHitData.v);
					
					if (!contains) virtualMouse.exitContainer();
					
					dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_OUT);
				}catch(err:Error)
				{
					log.error("MOUSE_OUT material type is not Interactive.  If you're using a Collada object, you may have to reassign the material to the object after the collada scene is loaded", err.message);
				}
			}
			
		}
		/**
		 * Handles the MOUSE_MOVE event on an InteractiveSprite container
		 * @param e
		 * 
		 */		
		protected function handleMouseMove(e:MouseEvent):void
		{
			if( VirtualMouse && renderHitData )
			{				
				//log.debug("material type", ObjectTools.getImmediateClassPath(face3d.face3DInstance.instance.material), face3d.face3DInstance.instance.material is InteractiveMovieMaterial);
				try
				{
					// locate the material's movie
					var mat:MovieMaterial = currentMaterial as MovieMaterial;

					// set the location where the calcs should be performed
					virtualMouse.container = mat.movie as Sprite;
						
					// update virtual mouse so it can test
					if( virtualMouse.container ) virtualMouse.setLocation(renderHitData.u, renderHitData.v);
					
					dispatchObjectEvent(InteractiveScene3DEvent.OBJECT_MOVE);
				}catch(err:Error)
				{
					log.error("MOUSE_MOVE material type is not Inter active.  If you're using a Collada object, you may have to reassign the material to the object after the collada scene is loaded", err.message, currentMaterial == null);
				}
			}
			
			
			/*
			if( Mouse3D.enabled && ( faceLevelMode || DisplayObject3D.faceLevelMode ) ) 
			{
				mouse3D.updatePosition(Face3D(containerDictionary[e.currentTarget]), e.currentTarget as Sprite);
			}
			*/
		}
		
		/**
		 * @private
		 * @param event
		 * @param currentTarget
		 * 
		 */		
		
		protected function dispatchObjectEvent(event:String):void
		{
			if(debug) log.debug(event, currentDisplayObject3D.name);
			
			try
			{
				var IS3DE:InteractiveScene3DEvent = new InteractiveScene3DEvent(event, currentDisplayObject3D, container, renderHitData.renderable as Triangle3D)
				var dispatched:Boolean = currentDisplayObject3D.dispatchEvent(IS3DE);
			
				dispatchEvent(IS3DE);
			}catch(e:Error)
			{
				log.error("dispatchObjectEvent", e.message);
			}
		}
	}	
}
