import flixel.util.FlxColor;
import flixel.FlxG;
class Rating{
	public static var ranking:String = "N/A";
    public static var hitMs = [];
    public static function generateFCRating(accuracy:Float){
        var rating_FC:String = "?";
		if (PlayState.badNote == 0 && PlayState.misses == 0 && PlayState.shits == 0 && PlayState.bads == 0 && PlayState.goods == 0 && accuracy == 100) // Super Perfect Full Combo
			rating_FC = "SPFC!!";
		else if (PlayState.badNote == 0 && PlayState.misses == 0 && PlayState.shits == 0 && PlayState.bads == 0 && PlayState.goods == 0) // Perfect Full Combo
			rating_FC = "PFC!";
		else if (PlayState.badNote == 0 && PlayState.misses == 0 && PlayState.shits == 0 && PlayState.bads == 0 && PlayState.goods >= 1) // Great Full Combo (Nothing but Goods & Sicks)
			rating_FC = "GFC";
		else if (PlayState.badNote == 0 && PlayState.misses == 0)  // Full Combo
			rating_FC = "FC";
		else if (PlayState.misses == 1) // One Touch Failure
			rating_FC = "OTF";
		else if (PlayState.misses == 2) // Two Touch Failures
			rating_FC = "TwTF";
		else if (PlayState.misses == 3) // Three Touch Failures
			rating_FC = "ThrTF";
		else if (PlayState.misses == 4) // Four Touch Failures
			rating_FC = "FTF";
		else if (PlayState.misses == 5) // Five Touch Failures
			rating_FC = "FvTF";
		else if (PlayState.misses == 6) // Six Touch Failures
			rating_FC = "SxTF";
		else if (PlayState.misses == 7) // Seven Touch Failures
			rating_FC = "SvnTF";
		else if (PlayState.misses == 8) // Eight Touch Failures
			rating_FC = "ETF";
		else if (PlayState.misses == 9) // Nine Touch Failures
			rating_FC = "NTF";
		else if (PlayState.misses == 10) // Ten Touch Failures
			rating_FC = "TenTF";
		else if (PlayState.misses >= 11) // Unstoppable Touch Failures
			rating_FC = "UnstoppableTF";
        return rating_FC;
	}
    public static function generateRatingNames(accuracy:Float){
        if (accuracy == 0)
			changeRanking("N/A", 0xFFf0f0f0);
        else if (accuracy == 100)
			changeRanking("Bloody Epic!!!!", 0xFFfffb01);
    	else if (accuracy >= 90)
			changeRanking("Mayor!!!", 0xFF00ff00);
        else if (accuracy >= 80)
			changeRanking("Excellent!!", 0xFF1be619);
        else if (accuracy >= 70)
			changeRanking("Optimum!", 0xFF32cd32);
        else if (accuracy >= 60)
			changeRanking("Great", 0xFF50c878);
        else if (accuracy >= 50)
			changeRanking("Good", 0xFFfde910);
        else if (accuracy >= 40)
			changeRanking("Meh", 0xFFff4600);
        else if (accuracy >= 30)
			changeRanking("Bruh", 0xFFcc0005);
        else if (accuracy >= 20)
			changeRanking("Bad", 0xFFcc0000);
        else if (accuracy >= 10)
			changeRanking("Shit", 0xFF530000);
        else if (accuracy < 10)
			changeRanking("Terrible!", 0xFF350000);
        return ranking;
	}
    public static function noteMs(noteDiff:Float){
		var diff = Math.abs(noteDiff);
		for (index in 0...hitMs.length){
			var time = hitMs[index];
			var nextTime = index + 1 > hitMs.length - 1 ? 0 : hitMs[index + 1];
			if (diff < time && diff >= nextTime){
				switch (index){
					case 0: return "shit";
					case 1: return "bad";
					case 2: return "good";
					case 3: return "sick";
				}
			}
		}
		return "sick";
	}
	public static function changeRanking(Name:String, ?Color:FlxColor = FlxColor.WHITE){
		ranking = Name;
		PlayState.ratingTxt.color = Color;
	}
    public static function getRatings(accuracy:Float):String{
        return (FlxG.save.data.rating == 0 ? generateRatingNames(accuracy) : generateRatingNames(accuracy) + " - " + "(" + generateFCRating(accuracy) + ")");
    }
}