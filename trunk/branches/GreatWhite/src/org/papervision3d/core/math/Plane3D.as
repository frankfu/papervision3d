/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org ? blog.papervision3d.org ? osflash.org/papervision3d
 */

/*
 * Copyright 2006 (c) Carlos Ulloa Matesanz, noventaynueve.com.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

// ______________________________________________________________________
//                                                               Plane3D

package org.papervision3d.core.math
{
import org.papervision3d.core.geom.renderables.Vertex3D;

/**
* The Plane3D class represents a plane in 3D space.
* 
* @author Tim Knip
*/
public class Plane3D
{
	public static const VERTEX_IS_BEHIND:int = 0;
	public static const VERTEX_IS_INFRONT:int = 1;
	public static const VERTEX_IS_COINCIDING:int = 2;
	
	/**
	* The plane normal (A, B, C).
	*/
	public var normal: Number3D;

	/**
	 * D.
	 */
	public var d: Number;


	/**
	 * Constructor.
	 *
	 * @param	normal		The plane normal.
	 * @param	ptOnPlane	A point on the plane.
	 */
	public function Plane3D( normal : Number3D = null, ptOnPlane : Number3D = null ) : void
	{
		if(normal && ptOnPlane) 
		{
			this.normal = normal;
			this.d = -Number3D.dot(normal, ptOnPlane);
		}
		else
		{
			this.normal = new Number3D();
			this.d = 0;	
		}
	}
	
	/**
	 * Creates a plane from coefficients.
	 *
	 * @param	a
	 * @param	b
	 * @param	c
	 * @param	d
	 *
	 * @return	The created plane.
	 */
	public static function fromCoefficients( a:Number, b:Number, c:Number, d:Number ) : Plane3D
	{
		var plane:Plane3D = new Plane3D();
		plane.setCoefficients(a, b, c, d);
		return plane;
	}
	
	/**
	 * Creates a plane from a normal and a point.
	 *
	 * @param	normal
	 * @param	point
	 *
	 * @return	The created plane.
	 */
	public static function fromNormalAndPoint( normal : *, point : * ) : Plane3D 
	{
		var n : Number3D = normal is Number3D ? normal : new Number3D(normal.x, normal.y, normal.z);
		var p : Number3D = point is Number3D ? point : new Number3D(point.x, point.y, point.z);
		return new Plane3D(n, p);
	}
	
	/**
	 * Creates a plane from three points.
	 *
	 * @param	p0	First point.
	 * @param	p1	Second point.
	 * @param	p2	Third point.
	 *
	 * @return	The created plane.
	 */
	public static function fromThreePoints( p0:*, p1:*, p2:* ):Plane3D
	{
		var plane:Plane3D = new Plane3D();
		var n0 : Number3D = p0 is Number3D ? p0 : new Number3D(p0.x, p0.y, p0.z);
		var n1 : Number3D = p1 is Number3D ? p1 : new Number3D(p1.x, p1.y, p1.z);
		var n2 : Number3D = p2 is Number3D ? p2 : new Number3D(p2.x, p2.y, p2.z);
		plane.setThreePoints(n0, n1, n2);
		return plane;
	}
	
	/**
	 * Get the closest point on the plane.
	 *
	 * @param	point		The point to 'project'.
	 * @param 	ptOnPlane	A known point on the plane.
	 */
	public function closestPointOnPlane( point : Number3D, ptOnPlane : Number3D ) : Number3D
	{
		var dist : Number = Number3D.dot(this.normal, Number3D.sub(point, ptOnPlane));
		var ret : Number3D = point.clone();
		ret.x -= (dist * this.normal.x);
		ret.y -= (dist * this.normal.y);
		ret.z -= (dist * this.normal.z);
		return ret;
	}
	
	/**
	 * distance of point to plane.
	 * 
	 * @param	v
	 * @return
	 */
	public function distance( pt:* ):Number
	{
		var p:Number3D = pt is Vertex3D ? pt.toNumber3D() : pt;
		return Number3D.dot(p, normal) + d;
	}
	
	/**
	 * normalize.
	 * 
	 * @return
	 */
	public function normalize():void
	{
		var n:Number3D = this.normal;
		
		//compute the length of the vector
		var len:Number = Math.sqrt(n.x*n.x + n.y*n.y + n.z*n.z);
		
		// normalize
		n.x /= len;
		n.y /= len;
		n.z /= len;
		this.d /= len;
	}
	
	/**
	 * Sets this plane from ABCD coefficients.
	 *
	 * @param	a
	 * @param	b
	 * @param	c
	 * @param	d
	 */
	public function setCoefficients( a:Number, b:Number, c:Number, d:Number ):void
	{
		// set the normal vector
		this.normal.x = a;
		this.normal.y = b;
		this.normal.z = c;
		this.d = d;
		
		normalize();
	}
	
	/**
	 * Sets this plane from a normal and a point.
	 *
	 * @param	normal
	 * @param	pt
	 */
	public function setNormalAndPoint( normal:Number3D, pt:Number3D ):void
	{
		this.normal = normal;
		this.d = -Number3D.dot(normal, pt);
	}
	
	/**
	 * Sets this plane from three points.
	 *
	 * @param	p0
	 * @param	p1
	 * @param	p2
	 */
	public function setThreePoints( p0:Number3D, p1:Number3D, p2:Number3D ):void
	{				
		var ab:Number3D = Number3D.sub(p1, p0);
		var ac:Number3D = Number3D.sub(p2, p0);
		this.normal = Number3D.cross(ab, ac);
		this.normal.normalize();
		this.d = -Number3D.dot(normal, p0);
	}
	
	
	/**
	 * Gets the side a vertex is on.
	 */
	 public function pointOnSide(num:Number3D):int
	 {
	 	var distance:Number = distance(num);
		if(distance < 0){
			return VERTEX_IS_BEHIND;
		}else if(distance > 0){
			return VERTEX_IS_INFRONT;
		}
		return VERTEX_IS_COINCIDING;
	 }
	
	/**
	 * Projects points onto this plane. 
	 * <p>Passed points should be in the XY-plane. If the points have Z=0 then the points are
	 * projected exactly on the plane. When however Z is greater then zero, the points are
	 * moved 'out of the plane' by a distance Z. Negative values for Z move the points 'into the plane'.</p>
	 *
	 * @param	points	Array of points (any object with x, y, z props).
	 * @param	origin	Where to move the points.
	 */
	public function projectPoints( points : Array, origin : Number3D = null ) : void {

		// use other up-vector if angle between plane-normal and up-vector approaches zero.
		var dot : Number = Number3D.dot(_yUP, this.normal);
		
		// when the dot-product approaches 1 the angle approaches 0
		var up : Number3D = Math.abs(dot) > 0.99 ? _zUP : _yUP;
		
		// get side vector
		var side:Number3D = Number3D.cross(up, normal);
		side.normalize();

		// adjust up vector
		up = Number3D.cross(normal, side);
		up.normalize();
		
		// create the matrix!
		var matrix : Matrix3D = new Matrix3D([
			side.x, up.x, normal.x, 0,
			side.y, up.y, normal.y, 0,
			side.z, up.z, normal.z, 0,
			0, 0, 0, 1]);
		
		// translate if wanted	
		if(origin)
			matrix = Matrix3D.multiply(Matrix3D.translationMatrix(origin.x, origin.y, origin.z), matrix);
		
		// project!
		var n : Number3D = new Number3D();
		for each( var point:* in points ) {
			n.x = point["x"];
			n.y = point["y"];
			n.z = point["z"];
			
			Matrix3D.multiplyVector(matrix, n);
			
			point["x"] = n.x;
			point["y"] = n.y;
			point["z"] = n.z;
		}
	}
	
	public function toString():String
	{
		return "[a:" + normal.x  +" b:" +normal.y + " c:" +normal.z + " d:" + d + "]";
	}

	private static var _yUP : Number3D = new Number3D(0, 1, 0);	
	private static var _zUP : Number3D = new Number3D(0, 0, 1);
}
}