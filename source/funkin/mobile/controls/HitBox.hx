package funkin.mobile.controls;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * ...
 * @author Idklool
 */
class HitBox extends FlxSpriteGroup
{
    public var buttonLeft:FlxButton;
    public var buttonDown:FlxButton;
    public var buttonUp:FlxButton;
    public var buttonRight:FlxButton;

    public function new()
    {
        super();
        buttonLeft = buttonDown = buttonUp = buttonRight = new FlxButton(0, 0);
        
        addButtons();
        scrollFactor.set();
    }

    function addButtons() {
        var x:Int = 0;
        var y:Int = 0;

        add(buttonLeft = createHitbox(x, y, Std.int(FlxG.width / 4), FlxG.height, '0xC24B99'));
        add(buttonDown = createHitbox(FlxG.width / 4, y, Std.int(FlxG.width / 4), FlxG.height, '0x00FFFF'));
        add(buttonUp = createHitbox(FlxG.width / 2, y, Std.int(FlxG.width / 4), FlxG.height, '0x12FA05'));
        add(buttonRight = createHitbox(FlxG.width * 3 / 4, y, Std.int(FlxG.width / 4), FlxG.height, '0xF9393F'));
    }

    function createHitbox(x:Float, y:Float, width:Int, height:Int, color:String)
    {
        var button:FlxButton = new FlxButton(x, y);
        button.makeGraphic(width, height, FlxColor.fromString(color));
        
        var baseAlpha = Options.hitboxAlpha;
        var pressedAlpha = Math.min(baseAlpha + 0.149, 1.0);
        
        button.alpha = baseAlpha;

        button.onDown.callback = () -> button.alpha = pressedAlpha;
        button.onUp.callback = () -> button.alpha = baseAlpha;
        button.onOut.callback = button.onUp.callback;

        return button;
    }
    
    public function updateAlpha() {
        var baseAlpha = Options.hitboxAlpha;
        
        if (buttonLeft != null) buttonLeft.alpha = baseAlpha;
        if (buttonDown != null) buttonDown.alpha = baseAlpha;
        if (buttonUp != null) buttonUp.alpha = baseAlpha;
        if (buttonRight != null) buttonRight.alpha = baseAlpha;
    }

    override public function destroy()
    {
        super.destroy();
        buttonLeft = buttonDown = buttonUp = buttonRight = null;
    }
}