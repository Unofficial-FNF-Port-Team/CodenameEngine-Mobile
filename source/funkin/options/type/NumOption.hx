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
		this.parent = parent != null ? parent : Options;

		if (optionName != null && Reflect.field(this.parent, optionName) != null) {
			var rawValue:Float = Reflect.field(this.parent, optionName);
			currentValue = FlxMath.bound(rawValue, min, max);
		} else {
			currentValue = min;
		}

		super(text, desc);

		var maxText = formatValue(max);
		var measure = new Alphabet(0, 0, maxText, "bold");
		valueBoxWidth = Math.max(measure.width, 80);
		measure.destroy();

		leftArrow = new FlxSprite();
		leftArrow.loadGraphic(Paths.image("menus/ui/arrow_left"));
		add(leftArrow);

		rightArrow = new FlxSprite();
		rightArrow.loadGraphic(Paths.image("menus/ui/arrow_right"));
		add(rightArrow);

		valueText = new Alphabet(0, 0, formatValue(currentValue), "bold");
		add(valueText);

		if (optionName != null) {
			Reflect.setField(this.parent, optionName, currentValue);
		}
	}

	private function formatValue(value:Float):String {
		if (step >= 1.0) {
			return Std.string(Std.int(value));
		} else if (step >= 0.01) {
			return Std.string(Math.round(value * 100) / 100);
		} else if (step >= 0.001) {
			return Std.string(Math.round(value * 1000) / 1000);
		} else {
			return Std.string(Math.round(value * 10000) / 10000);
		}
	}

	private function positionElements():Void {
		if (__text == null) return;
		
		var baseX = __text.x + __text.width + spacing;
		var textMidY = __text.y + (__text.height * 0.5);

		leftArrow.x = baseX;
		leftArrow.y = textMidY - (leftArrow.height * 0.5);

		var valueAreaX = leftArrow.x + leftArrow.width + innerPad;
		valueText.x = valueAreaX + (valueBoxWidth - valueText.width) * 0.5;
		valueText.y = textMidY - (valueText.height * 0.5);

		rightArrow.x = valueAreaX + valueBoxWidth + innerPad;
		rightArrow.y = textMidY - (rightArrow.height * 0.5);
	}

	override function changeSelection(change:Int):Void {
		if (locked) return;

		var next = FlxMath.bound(currentValue + change * step, min, max);
		if (Math.abs(next - currentValue) < (step * 0.001)) return;

		currentValue = next;
		valueText.text = formatValue(currentValue);

		if (optionName != null && parent != null) {
			Reflect.setField(parent, optionName, currentValue);
		}
		
		if (changedCallback != null) {
			changedCallback(currentValue);
		}

		positionElements();

		CoolUtil.playMenuSFX(SCROLL);
	}

	public override function update(elapsed:Float):Void {
		super.update(elapsed);
		positionElements();

		if (FlxG.mouse.justPressed) {
			var mousePos = FlxG.mouse.getWorldPosition();
			if (leftArrow.overlapsPoint(mousePos)) {
				changeSelection(-1);
			} else if (rightArrow.overlapsPoint(mousePos)) {
				changeSelection(1);
			}
		}
	}

	override function select() {}
}