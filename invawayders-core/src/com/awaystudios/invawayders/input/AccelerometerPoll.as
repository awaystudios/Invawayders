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
	import flash.sensors.*;
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
	public class AccelerometerPoll
	{
		private var _accelerometer:Accelerometer = new Accelerometer();
		
		public var isAccelerometer : Boolean;
		
		public var accelerometerX : Number;
		
		public var accelerometerY : Number;
		
		public var centerY : Number;
		
		/**
		 * Constructor
		 * 
		 * @param displayObj a display object on which to test listen for keyboard events. To catch all key events use the stage.
		 */
		public function AccelerometerPoll()
		{
			isAccelerometer = Accelerometer.isSupported;
			
			_accelerometer.addEventListener(AccelerometerEvent.UPDATE, onAccelerometerUpdate);
		}
		
		private function onAccelerometerUpdate( event:AccelerometerEvent ):void
		{
			// Update position.
			accelerometerX = event.accelerationX;
			accelerometerY = event.accelerationY;
		}
	}
}