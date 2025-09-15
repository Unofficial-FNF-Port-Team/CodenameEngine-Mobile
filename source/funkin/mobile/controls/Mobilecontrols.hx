package funkin.mobile.controls;

import flixel.group.FlxSpriteGroup;

class Mobilecontrols extends FlxSpriteGroup
{
	public var mode:String = 'hitbox';

	public var hitbox:HitBox;
	public var vPad:FlxVirtualPad;

	var config:Config;

	public function new() 
	{
		super();

		config = new Config();

		// load control mode num from Config.hx
		mode = getModeFromNumber(config.getcontrolmode());
		trace(config.getcontrolmode());

		switch (mode.toLowerCase())
		{
			case 'vpad_right':
				initVirtualPad(0);
			case 'vpad_left':
				initVirtualPad(1);
			case 'hitbox':
				hitbox = new HitBox();
				add(hitbox);
			case 'keyboard':
		}
	}

	function initVirtualPad(vpadMode:Int) 
	{
	  var canExtraButton:Bool = Options.extraControls >= 1;
      var canSecondExtraButton:Bool = Options.extraControls == 2;
		
		switch (vpadMode)
		{
			case 1:
			  if (canExtraButton) {
                 if (canSecondExtraButton) {
				   vPad = new FlxVirtualPad(FULL, A_B);
                 } else {
                   vPad = new FlxVirtualPad(FULL, A);
		         }
		      } else {
				vPad = new FlxVirtualPad(FULL, NONE);
		      }
			default: // 0
				if (canExtraButton) {
                 if (canSecondExtraButton) {
				   vPad = new FlxVirtualPad(RIGHT_FULL, A_B);
                 } else {
                   vPad = new FlxVirtualPad(RIGHT_FULL, A);
		         }
		      } else {
				vPad = new FlxVirtualPad(RIGHT_FULL, NONE);
			  }
		}

		vPad.alpha = 0.75;
		add(vPad);	
	}


	public static function getModeFromNumber(modeNum:Int):String {
		return switch (modeNum)
		{
			case 0: 'vpad_right';
			case 1: 'vpad_left';
			case 2: 'keyboard';
			case 3:	'hitbox';
			default: 'vpad_right';
		}
	}
}
