package funkin.mobile.backend;

import funkin.options.TreeMenuScreen;
import funkin.options.type.NumOption;
import funkin.options.type.TextOption;
import funkin.options.type.Separator;

class MobileOptions extends TreeMenuScreen {
	public function new() {
		super('optionsTree.mobileOptions-name', 'optionsTree.mobileOptions-desc', 'MobileOptions.');

		/*add(new ArrayOption(getNameID('controlsChange'), getDescID('controlsChange'), [0, 1, 2], [getID('hitbox'), getID('vpad'), getID('keyboard')],
			'quality', __changeControls, 0));*/
	
		add(new NumOption(
			getNameID('hitboxAlpha'), 
			getDescID('hitboxAlpha'),
			0.0, 1.0, 0.1,
			'hitboxAlpha', __changeHitboxAlpha
		));

		add(new Separator());
		add(new TextOption(
			getNameID('resetMobileOptions'),
			getDescID('resetMobileOptions'),
			() -> {
				Options.hitboxAlpha = 0.001;
			}
		));
	}

	/*private function __changeQuality(value:Dynamic) {
    var curSelected:Int = 0;
    curSelected == Config.getcontrolmode();
	}*/

	private function __changeHitboxAlpha(value:Float) {
		var clampedValue = Math.max(0.0, Math.min(1.0, value));
		Options.hitboxAlpha = Math.round(clampedValue * 100) / 100;
	}
}
