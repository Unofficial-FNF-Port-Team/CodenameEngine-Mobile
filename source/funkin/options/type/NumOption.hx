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

	var valueBoxWidth:Float = 0;

	var spacing:Int = 24;
	var innerPad:Int = 8;

	public function new(text:String, desc:String, min:Float, max:Float, step:Float = 1, ?optionName:String, ?changedCallback:Float->Void = null, ?parent:Dynamic) {
		this.changedCallback = changedCallback;
		this.min = min;
		this.max = max;
		this.step = step;
		this.optionName = optionName;
		this.parent = parent = parent != null ? parent : Options;

		if (Reflect.field(parent, optionName) != null) currentValue = Reflect.field(parent, optionName);

		super(text, desc);

		var measure = new Alphabet(0, 0, Std.string(Std.int(max)), "bold");
		valueBoxWidth = measure.width;
		measure.destroy();

		leftArrow = new FlxSprite();
		leftArrow.loadGraphic(Paths.image("menus/ui/arrow_left"));
		add(leftArrow);

		rightArrow = new FlxSprite();
		rightArrow.loadGraphic(Paths.image("menus/ui/arrow_right"));
		add(rightArrow);

		valueText = new Alphabet(0, 0, Std.string(currentValue), "bold");
		add(valueText);
	}

	private function positionElements():Void {
		var baseX = __text.x + __text.width + spacing;

		var textMidY = __text.y + (__text.height * 0.5);

		leftArrow.x = baseX;
		leftArrow.y = textMidY - (leftArrow.height * 0.5);

		var valueAreaX = leftArrow.x + leftArrow.width + spacing;
		var boxW = valueBoxWidth; 

		valueText.x = valueAreaX + (boxW - valueText.width) * 0.5;
		valueText.y = textMidY - (valueText.height * 0.5);

		rightArrow.x = valueAreaX + boxW + spacing;
		rightArrow.y = textMidY - (rightArrow.height * 0.5);
	}

	override function changeSelection(change:Int):Void {
		if (locked) return;

		var next = FlxMath.bound(currentValue + change * step, min, max);
		if (next == currentValue) return;

		currentValue = next;
		valueText.text = Std.string(currentValue);

		Reflect.setField(parent, optionName, currentValue);
		if (changedCallback != null) changedCallback(currentValue);

		CoolUtil.playMenuSFX(SCROLL);
	}

	public override function update(elapsed:Float):Void {
		super.update(elapsed);

		positionElements();

		var mousePos = FlxG.mouse.getWorldPosition();
		if (FlxG.mouse.justPressed) {
			if (leftArrow.overlapsPoint(mousePos)) changeSelection(-1);
			else if (rightArrow.overlapsPoint(mousePos)) changeSelection(1);
		}
	}

	override function select() {}
}
