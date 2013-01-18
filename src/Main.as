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
	 * punk.fx demo entry point
	 * 
	 * @author azrafe7
	 */
	[SWF(width = "640", height = "480")]
	public class Main extends Engine 
	{
		public var CAMERA_SPEED:Number = 100;
		
		public static var helloText:Text;
		
		public function Main():void 
		{
			trace("FP " + FP.VERSION + " started!");
			super(640, 480, 60, false);
			
			//FP.console.toggleKey = Key.TAB;
			FP.console.log("                           punk.fx v" + FXMan.VERSION + " demo (build date: " + FXMan.BUILD_DATE + ")");
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
			
			// move camera with WASD
			if (Input.check(Key.D)) FP.camera.x -= CAMERA_SPEED * FP.elapsed;
			if (Input.check(Key.A)) FP.camera.x += CAMERA_SPEED * FP.elapsed;
			if (Input.check(Key.S)) FP.camera.y -= CAMERA_SPEED * FP.elapsed;
			if (Input.check(Key.W)) FP.camera.y += CAMERA_SPEED * FP.elapsed;

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