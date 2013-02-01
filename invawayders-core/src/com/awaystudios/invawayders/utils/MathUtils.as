package com.awaystudios.invawayders.utils
{
	/**
	 * A static utility class containing custom maths functions. 
	 */
	public class MathUtils
	{
		/**
		 * Retuns a ramdon number value within a specified range.
		 * 
		 * @param min The minimum desired value of the random number returned.
		 * @param max The maximum desired value of the random number returned.
		 * 
		 * @return The calculated random number.
		 */
		public static function rand(min:Number, max:Number):Number
		{
		    return (max - min)*Math.random() + min;
		}
	}
}
