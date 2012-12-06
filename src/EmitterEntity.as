package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.Mask;
	import net.flashpunk.utils.Ease;
	
	/**
	 * Emitter entity (it's gears all the way down).
	 * 
	 * @author azrafe7
	 */
	public class EmitterEntity extends Entity 
	{
		
		[Embed(source="assets/gears.png")]
		public var GEARS:Class;
		
		public var particles:Emitter;
		
		public function EmitterEntity(x:Number=0, y:Number=0) 
		{
			super(x, y);
			
			particles = new Emitter(FP.getBitmap(GEARS), 21, 21);
			particles.newType("big_gear", [0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2]);
			particles.setMotion("big_gear", 30, 250, 1.9, -230, 50, .2);
			particles.setGravity("big_gear", .5, .2);
			particles.setColor("big_gear", 0xD05588, 0xFF0030, Ease.quadIn);
			particles.setAlpha("big_gear", 1 ,.4);
			
			particles.newType("little_gear", [3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5, 3, 4, 5]);
			particles.setMotion("little_gear", 30, 250, 1.3, -230, 50, .2);
			particles.setGravity("little_gear", 1, .5);
			particles.setColor("little_gear", 0xFF3333, 0xDD5566, Ease.quadIn);
			particles.setAlpha("little_gear", 1 , .3);
			
			addGraphic(particles);
		}
		
		override public function update():void 
		{
			super.update();
			
			var particleType:String = Math.random() < .5 ? "big_gear" : "little_gear";
			
			if (Math.random() < .2) particles.emit(particleType, 0, 0);
		}
	}

}