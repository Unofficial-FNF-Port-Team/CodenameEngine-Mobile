package funkin.options.type;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import funkin.backend.utils.CoolUtil;

class NumOption extends TextOption {
    public var changedCallback:Float->Void;
    public var min:Float;
    public var max:Float;
    public var step:Float;
    public var currentValue:Float;
    public var parent:Dynamic;
    public var optionName:String;

    var leftArrow:FlxSprite;
    var rightArrow:FlxSprite;
    var valueText:Alphabet;

    public function new(text:String, desc:String, min:Float, max:Float, step:Float = 1, ?optionName:String, ?changedCallback:Float->Void = null, ?parent:Dynamic) {
        this.changedCallback = changedCallback;
        this.min = min;
        this.max = max;
        this.step = step;
        this.optionName = optionName;
        this.parent = parent = parent != null ? parent : Options;

        if (Reflect.field(parent, optionName) != null) currentValue = Reflect.field(parent, optionName);

        super(text, desc);

        leftArrow = new FlxSprite();
        leftArrow.loadGraphic(Paths.image("menus/ui/arrow_left"));
        add(leftArrow);

        rightArrow = new FlxSprite();
        rightArrow.loadGraphic(Paths.image("menus/ui/arrow_right"));
        add(rightArrow);

        valueText = new Alphabet(0, 0, Std.string(currentValue), "bold");
        add(valueText);

        positionElements();
    }

	private function positionElements():Void {
		var baseOffset = 70;
		valueText.x = __text.x + __text.width + baseOffset;
		valueText.y = __text.y + (__text.height - valueText.height)/2;

		leftArrow.x = valueText.x - leftArrow.width - 8;
		leftArrow.y = __text.y + (__text.height - leftArrow.height)/2;

		rightArrow.x = valueText.x + valueText.width + 8;
		rightArrow.y = __text.y + (__text.height - rightArrow.height)/2;

	}

    override function changeSelection(change:Int):Void {
        if (locked) return;
        currentValue = FlxMath.bound(currentValue + change * step, min, max);
        valueText.text = Std.string(currentValue);

        Reflect.setField(parent, optionName, currentValue);
        if (changedCallback != null) changedCallback(currentValue);

        CoolUtil.playMenuSFX(SCROLL);
    }

    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (leftArrow.overlapsPoint(FlxG.mouse.getWorldPosition()) && FlxG.mouse.justPressed) changeSelection(-1);
        if (rightArrow.overlapsPoint(FlxG.mouse.getWorldPosition()) && FlxG.mouse.justPressed) changeSelection(1);
    }

    override function select() {}
}
