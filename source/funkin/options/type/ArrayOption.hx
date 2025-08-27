package funkin.options.type;

import flixel.FlxG;
import flixel.FlxSprite;
import funkin.backend.utils.CoolUtil;

class ArrayOption extends TextOption {
	public var changedCallback:String->Void;

	public var options:Array<Dynamic>;
	public var displayOptions:Array<String>;
	public var currentSelection:Int;

	public var parent:Dynamic;
	public var optionName:String;

	var __selectionText:Alphabet;
	
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var spacing:Int = 24;

	override function set_text(v:String) {
		super.set_text(v);
		positionElements();
		return v;
	}

	public function new(text:String, desc:String, options:Array<Dynamic>, displayOptions:Array<String>, ?optionName:String, ?changedCallback:Dynamic->Void = null, ?parent:Dynamic) {
		this.changedCallback = changedCallback;
		this.displayOptions = displayOptions;
		this.options = options;
		this.optionName = optionName;
		this.parent = parent = parent != null ? parent : Options;

		var fieldValue = Reflect.field(parent, optionName);
		if (fieldValue != null) currentSelection = CoolUtil.maxInt(0, options.indexOf(fieldValue));
	
		super(text, desc);

		leftArrow = new FlxSprite();
		leftArrow.loadGraphic(Paths.image("menus/ui/arrow_left"));
		add(leftArrow);

		rightArrow = new FlxSprite();
		rightArrow.loadGraphic(Paths.image("menus/ui/arrow_right"));
		add(rightArrow);

		__selectionText = new Alphabet(0, 20, formatTextOption(), 'bold');
		add(__selectionText);
	}

	private function positionElements():Void {
		if (__text == null || leftArrow == null || rightArrow == null || __selectionText == null) return;

		var baseX = __text.x + __text.width + spacing;
		var textMidY = __text.y + (__text.height * 0.5);

		leftArrow.x = baseX;
		leftArrow.y = textMidY - (leftArrow.height * 0.5);

		var valueAreaX = leftArrow.x + leftArrow.width + spacing;
		
		__selectionText.x = valueAreaX;
		__selectionText.y = textMidY - (__selectionText.height * 0.5);

		rightArrow.x = valueAreaX + __selectionText.width + spacing;
		rightArrow.y = textMidY - (rightArrow.height * 0.5);
	}

	override function reloadStrings() {
		__selectionText.text = formatTextOption();
		super.reloadStrings();
		positionElements();
	}

	function formatTextOption() {
		return TU.exists(displayOptions[currentSelection]) ? TU.translate(displayOptions[currentSelection]) : displayOptions[currentSelection];
	}

	override function changeSelection(change:Int) {
		if (locked || currentSelection == (currentSelection = CoolUtil.boundInt(currentSelection + change, 0, options.length - 1))) return;
		
		__selectionText.text = formatTextOption();
		positionElements();
		
		CoolUtil.playMenuSFX(SCROLL);

		if (optionName != null) Reflect.setField(parent, optionName, options[currentSelection]);
		if (changedCallback != null) changedCallback(options[currentSelection]);
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