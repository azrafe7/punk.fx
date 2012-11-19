package 
{
	import flash.system.System;
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import punk.fx.FXMan;
	
	/**
	 * ...
	 * @author azrafe7
	 */
	[SWF(width = "640", height = "480")]
	public class Main extends Engine 
	{
		public static var helloText:Text;
		
		public function Main():void 
		{
			trace("FP started!");
			super(640, 480, 60, false);
			
			//FP.console.toggleKey = Key.TAB;
			FP.console.log("punk.fx v" + FXMan.VERSION + " demo");
			FP.console.enable();
			FP.screen.scale = 1;
			FP.world = new TestWorld;
		}
		
		override public function init():void 
		{
			trace("FP init!");
			super.init();
		}
		
		override public function update():void
		{
			super.update();
			
			// press BACKSPACE to force call the GC in the debug player
			if (Input.check(Key.BACKSPACE)) {
				System.gc();
			}
			// press ESCAPE to exit debug player
			if (Input.check(Key.ESCAPE)) {
				System.exit(1);
			}
		}
	}
}