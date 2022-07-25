import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.text.FlxText;
using StringTools;
class Text extends FlxText{
	var stylePlacer:FlxTextBorderStyle;
    public function new(?Text:String, ?X:Float = 0, ?Y:Float = 0, ?Size:Int = 8, ?FieldWidth:Float = 0, ?Alpha:Float = 1, ?Visible:Bool = true, ?EmbeddedFont:Bool = true){
        super(X, Y);
        if (Text != null || Text != "")
            text = Text;
        else{
			text = "";
			Text = " ";
		}
		textField = new TextField();
		textField.selectable = false;
		textField.multiline = true;
		textField.wordWrap = true;
		_defaultFormat = new TextFormat(null, Size, 0xffffff);
		font = FlxAssets.FONT_DEFAULT;
		_formatAdjusted = new TextFormat();
		textField.defaultTextFormat = _defaultFormat;
		textField.text = Text;
		fieldWidth = FieldWidth;
		textField.embedFonts = EmbeddedFont;
		textField.sharpness = 100;
		textField.height = (Text.length <= 0) ? 1 : 10;
		allowCollisions = NONE;
		moves = false;
		drawFrame();
		shadowOffset = FlxPoint.get(1, 1);
		scrollFactor.set();
		alpha = Alpha;
        visible = Visible;
    }
    public function format(?Font:String, Size:Int = 8, Color:FlxColor = FlxColor.WHITE, BorderColor:FlxColor = FlxColor.TRANSPARENT, ?Alignment:FlxTextAlign, ?TextBorderStyle:String, ?FontFileExtension:String = 'ttf', ?EmbeddedFont:Bool = true){
        switch (TextBorderStyle){
            case 'none' | 'NONE': stylePlacer = FlxTextBorderStyle.NONE;
            case 'shadow' | 'SHADOW': stylePlacer = FlxTextBorderStyle.SHADOW;
            case 'outline' | 'OUTLINE': stylePlacer = FlxTextBorderStyle.OUTLINE;
            case 'outline_fast' | 'OUTLINE_FAST': stylePlacer = FlxTextBorderStyle.OUTLINE_FAST;
        }
		setFormat((Font != null ? Paths.type('assets/fonts/$Font', '$FontFileExtension', null, null, null, true) : ''), Size, Color, Alignment, stylePlacer, BorderColor, EmbeddedFont);
    }
	//public function settings(){}
}