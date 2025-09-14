package funkin.mobile.backend;

import funkin.options.TreeMenuScreen;
import funkin.options.type.NumOption;
import funkin.options.type.TextOption;
import funkin.options.type.Separator;
import funkin.options.type.ArrayOption;
import funkin.mobile.controls.Mobilecontrols;
import funkin.mobile.backend.Config;

class MobileOptions extends TreeMenuScreen {
	var config:Config;
	public function new() {
		super('optionsTree.mobileOptions-name', 'optionsTree.mobileOptions-desc', 'MobileOptions.');

		add(new ArrayOption(getNameID('controlsChange'), 
		getDescID('controlsChange'),
		 [0, 1, 2],
		[getID('hitbox'), getID('vpad'), getID('keyboard')],
        'controlsChange',
		__changeControls));
	
		add(new NumOption(
			getNameID('hitboxAlpha'), 
			getDescID('hitboxAlpha'),
			0.0, 1.0, 0.1,
			'hitboxAlpha', __changeHitboxAlpha
		));

		add(new NumOption(
			getNameID('extraControls'),
			getDescID('extraControls'),
			0, 2, 1,
			'extraControls', __toggleExtraButton
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

	private function __changeControls(value:Dynamic) {
    switch(value) {
    case 0: Mobilecontrols.getModeFromNumber(4);
    case 1: Mobilecontrols.getModeFromNumber(0);
    case 2: Mobilecontrols.getModeFromNumber(2);
    }
	 config = new Config();
	 config.setcontrolmode(value);
   }

	private function __changeHitboxAlpha(value:Float) {
		var clampedValue = Math.max(0.0, Math.min(1.0, value));
		Options.hitboxAlpha = Math.round(clampedValue * 100) / 100;
	}

	private function __toggleExtraButton() {
        Options.extrabutton = (Options.extraControls + 1) % 3;
        FlxG.resetState();
	}
}
