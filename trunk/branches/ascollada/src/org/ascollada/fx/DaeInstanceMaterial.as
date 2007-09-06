/*
 * Copyright 2007 (c) Tim Knip, ascollada.org.
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
 
package org.ascollada.fx
{	
	import org.ascollada.ASCollada;
	import org.ascollada.core.DaeEntity;
	import org.ascollada.utils.Logger;
	
	/**
	 * 
	 */
	public class DaeInstanceMaterial extends DaeEntity
	{		
		/** symbol - required */
		public var symbol:String;
		
		/** target - required */
		public var target:String;
		
		/**
		 * 
		 */
		public function DaeInstanceMaterial( node:XML = null )
		{
			super( node );
		}
		
		/**
		 * 
		 * @param	node
		 */
		override public function read( node:XML ):void
		{
			super.read( node );
			
			this.symbol = getAttribute(node, ASCollada.DAE_SYMBOL_ATTRIBUTE);
			
			this.target = getAttribute(node, ASCollada.DAE_TARGET_ATTRIBUTE);
			
			var bindList:XMLList = getNodeList(node, ASCollada.DAE_BIND_ELEMENT);
			var bindVertList:XMLList = getNodeList(node, ASCollada.DAE_BIND_VERTEX_INPUT);
			var extraList:XMLList = getNodeList(node, ASCollada.DAE_EXTRA_ELEMENT);
			
			// 0 or more
			if( bindList != new XMLList() )
			{
				
			}
			
			// 0 or more
			if( bindVertList != new XMLList() )
			{
				
			}
			
			// 0 or more
			if( extraList != new XMLList() )
			{
				
			}
		}
	}
}