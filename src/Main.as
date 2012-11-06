package 
{
	import flash.system.System;
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
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
			//FP.console.log("TAB - toggle console");
			FP.console.enable();
			FP.screen.scale = 1;
			FP.world = new TestWorld;
		}
		
		override public function init():void 
		{
			trace("FP init!");
			super.init();

			helloText = new Text("Hello FlashPunk World!", 0, 0, {size: 32, color: 0xFF3366});
			helloText.centerOrigin();
	
			FP.world.add(new Entity(FP.screen.width/2, FP.screen.height/2, helloText));
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