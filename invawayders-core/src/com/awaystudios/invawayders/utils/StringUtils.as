package com.awaystudios.invawayders.utils
{
	/**
	 * A static utility class containing custom string functions. 
	 */
	public class StringUtils
	{
		
		/**
		 * Converts unsigned integers to same-length strings.
		 * 
		 * @param value Unsigned integer value to convert
		 * @param length Desired length of the resulting string
		 * @return The resulting string representing the unsigned integer.
		 */
		public static function uintToSameLengthString(value:uint, length:uint):String
		{
			var str:String = value.toString();
			
			while( str.length < length )
				str = "0" + str;
			
			return str;
		}
	}
}
