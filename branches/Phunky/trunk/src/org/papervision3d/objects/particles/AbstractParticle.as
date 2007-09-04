package org.papervision3d.objects.particles
{
	import flash.display.Sprite;
	
	import org.papervision3d.core.geom.Vertex3D;

	public class AbstractParticle implements IParticle
	{
		
		public var color:int;
		public var size:int;
		public var vertex3D:Vertex3D;
		
		public function AbstractParticle(color:int=0xFFFFFF, size:int=1, x:Number=0, y:Number=0, z:Number=0)
		{
			this.color = color;
			this.size = size;
			vertex3D = new Vertex3D(x,y,z);
		}
		
		public function render(container:Sprite):int
		{
			return 0;
		}
		
		public function update():void
		{
			
		}
		
		public function set x(x:Number):void
		{
			vertex3D.x = x;
		}
		
		public function get x():Number
		{
			return vertex3D.x;
		}
		
		public function set y(y:Number):void
		{
			vertex3D.y = y;
		}
		
		public function get y():Number
		{
			return vertex3D.y;
		}
		
		public function set z(z:Number):void
		{
			vertex3D.z = z;
		}
		
		public function get z():Number
		{
			return vertex3D.z;
		}
		
	}
}