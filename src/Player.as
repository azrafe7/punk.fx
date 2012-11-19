package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.graphics.FXSpritemap;

	public class Player extends Entity
	{
		[Embed(source = 'assets/swordguy.png')]
		public const SWORDGUY:Class;

		public var sprSwordguy:FXSpritemap = new FXSpritemap(SWORDGUY, 48*2*1.5, 32*2*1.5);
		
		public function Player(x:Number, y:Number)
		{
			super(x, y);
						
			sprSwordguy.add("run", [6, 7, 8, 9, 10, 11], 20, true);
			sprSwordguy.play("run");
			graphic = sprSwordguy;
			width = sprSwordguy.width;
			height = sprSwordguy.height;
			sprSwordguy.scale = 1;
			sprSwordguy.rate = .5;
			sprSwordguy.centerOO();
		}
		
		private var dx:Number = 120;

		override public function update():void
		{
			moveBy(dx*FP.elapsed*.5, 0);
			
			if(x > 500) 
			{
				dx *= -1;
				sprSwordguy.flipped = true;
			}
			else if(x < 200)
			{
				dx *= -1;
				sprSwordguy.flipped = false;
			}
			moveBy(dx*FP.elapsed*.5, 0);
		}
	}
}