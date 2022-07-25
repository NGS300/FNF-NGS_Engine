package;
typedef SwagSection ={
	var sectionNotes:Array<Dynamic>;
	var mustHitSection:Bool;
	var lengthInSteps:Int;
	var typeOfSection:Int;
	var changeBPM:Bool;
	var altAnim:Bool;
	var bpm:Int;
}
class Section{
	public var sectionNotes:Array<Dynamic> = [];
	public var mustHitSection:Bool = true;
	public var lengthInSteps:Int = 16;
	public var typeOfSection:Int = 0;
	public static var COPYCAT:Int = 0;
	public function new(lengthInSteps:Int = 16){
		this.lengthInSteps = lengthInSteps;
	}
}