package;
import lime.utils.Assets;
using StringTools;
typedef Difficulty ={
	var  DifficultyNames:Array<String>;
	var DifficultyDataNames:Array<String>;
}
class CoolUtil{
	public static var PushDiff:Difficulty;
	public static function difficultyFromInt(difficulty:Int):String{
		return PushDiff.DifficultyNames[difficulty];
	}
	public static function difficultyData(difficulty:Int){
		return PushDiff.DifficultyDataNames[difficulty];
	}
	public static function checkDifficultyData(typeDif:Int){
		if (typeDif == typeDif) PushDiff.DifficultyDataNames[typeDif];
		return PushDiff.DifficultyDataNames[typeDif];
	}
	public static function coolTextFile(path:String):Array<String>{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');
		for (i in 0...daList.length) daList[i] = daList[i].trim();
		return daList;
	}
	public static function coolStringFile(path:String):Array<String>{
		var daList:Array<String> = path.trim().split('\n');
		for (i in 0...daList.length) daList[i] = daList[i].trim();
		return daList;
	}
	public static function numberArray(max:Int, ?min = 0):Array<Int>{
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);
		return dumbArray;
	}
	public static function floatDecimals(number:Float, precision:Int):Float{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}
}