/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.2
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.awaystudios.invawayders.input
{
	import flash.display.*;
	import flash.events.*;
	
	/**
	 * <p>Games often need to get the current state of various keys in order to respond to user input. 
	 * This is not the same as responding to key down and key up events, but is rather a case of discovering 
	 * if a particular key is currently pressed.</p>
	 * 
	 * <p>In Actionscript 2 this was a simple matter of calling Key.isDown() with the appropriate key code. 
	 * But in Actionscript 3 Key.isDown no longer exists and the only intrinsic way to react to the keyboard 
	 * is via the keyUp and keyDown events.</p>
	 * 
	 * <p>The KeyPoll class rectifies this. It has isDown and isUp methods, each taking a key code as a 
	 * parameter and returning a Boolean.</p>
	 */
	public class MousePoll
	{
		private var _displayObj : DisplayObject;
		
		public var isOnStage : Boolean;
		
		public var leftMouseDown : Boolean;
		
		public var mouseX : Number;
		
		public var mouseY : Number;
		
		/**
		 * Constructor
		 * 
		 * @param displayObj a display object on which to test listen for keyboard events. To catch all key events use the stage.
		 */
		public function MousePoll( displayObj:DisplayObject )
		{
			_displayObj = displayObj;
			
			displayObj.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown );
			displayObj.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			displayObj.stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			displayObj.stage.addEventListener( Event.MOUSE_LEAVE, onMouseLeave );
		}
		
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse moves.
		 */
		private function onMouseMove( event:MouseEvent ):void
		{
			isOnStage = true;
			
			mouseX = _displayObj.mouseX;
			mouseY = _displayObj.mouseY;
		}
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse leaves the stage area.
		 */
		private function onMouseLeave( event:Event ):void
		{
			isOnStage = false;
		}
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse button is pressed.
		 */
		private function onMouseDown( event:MouseEvent ):void
		{
			leftMouseDown = true;
		}
		
		/**
		 * Stage handler for mouse events, broadcast when the mouse button is released.
		 */
		private function onMouseUp( event:MouseEvent ):void
		{
			leftMouseDown = false;
		}
	}
}