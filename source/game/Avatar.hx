package game;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.Object;

/**
 * ...
 * @author ...
 */
class Avatar extends FlxSprite 
{
	public var username:String;
	public var country:String;
	
	// TODO: Convert to some kind of object w/ attribute for each body piece.
	// Also attribute for each piece color.
	public var itemArray:Array<Object>;
	
	public var canWalk:Bool = true;
	public var isHolding:Bool = false;
	public var currentAction:String = "Stand";
	
	public var keysTriggered:Object = { North: false, South: false, East: false, West: false, Run: false };
	public var previousKeysTriggered:Object = { North: false, South: false, East: false, West: false };
	
	public var velocityX:Float = 0;
	public var velocityY:Float = 0;
	
	public static var actionSet:Object = {Stand: "Stand", Walk: "Walk", Sit: "Sit", Hold: "Hold"};
	
	private var avatarSheet:GraphicsSheet = new GraphicsSheet(1772, 68);
	private static var sheetCanvas:BitmapData = new BitmapData(1722, 68);
	
	private static var zeroPoint:Point = new Point(0, 0);
	private static var frameSizePoint:FlxPoint = new FlxPoint(41, 68);
	private static var sheetRect:Rectangle = new Rectangle(0, 0, 1722, 68);
	
	// It saves CPU to pre-determine velocities rather than calculate them every frame.
	private static var orthogVelocity:FlxPoint = new FlxPoint(96, 48);
	private static var diagVelocity:FlxPoint = new FlxPoint(80, 26);
	
	public function new(_username:String) 
	{
		super();
		username = _username;
		
		itemArray = new Array<Object>();
		itemArray[0] = { Asset: "Body", Color: 0, TypeNum: 0 };
		itemArray[1] = { Asset: "Shoes", Color: 1, TypeNum: 2 };
		itemArray[2] = { Asset: "Jeans", Color: 1, TypeNum: 2 };
		itemArray[3] = { Asset: "Overcoat", Color: 1, TypeNum: 2 };
		itemArray[4] = { Asset: "Douli2", Color: 0, TypeNum: 2 };
		itemArray[5] = { Asset: "Face", Color: 0, TypeNum: 0 };
		itemArray[6] = { Asset: "Hair", Color: 1, TypeNum: 1 };
		itemArray[7] = { Asset: "Glasses", Color: 0, TypeNum: 2 };
		itemArray[8] = { Asset: "Douli", Color: 0, TypeNum: 2 };
		
		generateAvatar();
		generateAnimation();
	}
	
	override public function update(elapsed:Float):Void
	{
		doAnimation();
		super.update(elapsed);
    }
	
	private function doAnimation():Void
	{
		var animationString:String = buildAnimationString();
		
		animation.play(animationString);
		
		if (keysTriggered.Run)
		{
			this.velocity = FlxPoint.get(this.velocityX * 1.66, this.velocityY * 1.66);
		}
		
		else
		{
			this.velocity = FlxPoint.get(this.velocityX, this.velocityY);
		}
		
		this.velocity.put();
	}
	
	public function generateAvatar():Void
	{
		var itemSprite:FlxSprite = new FlxSprite(0, 0);
		
		for (item in itemArray)
		{
			itemSprite.loadGraphic("assets/images/" + item.Asset + ".png");
			
			itemSprite.pixels = avatarSheet.colorItem(itemSprite.pixels, item.Color, item.TypeNum);			
			avatarSheet.drawItem(itemSprite.pixels);
		}
		
		this.pixels = new BitmapData(41, 68, true, 0x00000000);
	}
	
	private function generateAnimation():Void
	{
		this.frames = FlxTileFrames.fromGraphic(FlxGraphic.fromBitmapData(avatarSheet.bitmapData), frameSizePoint);
		
		animation.add("StandUp", [0], 9, false, false);
		animation.add("StandUpRight", [1], 9, false, false);
		animation.add("StandRight", [2], 9, false, false);
		animation.add("StandDownRight", [3], 9, false, false);
		animation.add("StandDown", [4], 9, false, false);
		
		animation.add("StandUpLeft", [1], 9, false, true);
		animation.add("StandLeft", [2], 9, false, true);
		animation.add("StandDownLeft", [3], 9, false, true);
		
		animation.add("HoldUp", [37], 9, false, false);
		animation.add("HoldUpRight", [38], 9, false, false);
		animation.add("HoldRight", [39], 9, false, false);
		animation.add("HoldDownRight", [40], 9, false, false);
		animation.add("HoldDown", [41], 9, false, false);
		
		animation.add("HoldUpLeft", [38], 9, false, true);
		animation.add("HoldLeft", [39], 9, false, true);
		animation.add("HoldDownLeft", [40], 9, false, true);
		
		animation.add("WalkUp", [5, 6, 7, 8, 9, 10], 9, true, false);
		animation.add("WalkDown", [29, 30, 31, 32, 33, 34], 9, true, false);
		
		animation.add("WalkUpRight", [11, 12, 13, 14, 15, 16], 9, true, false);
		animation.add("WalkRight", [17, 18, 19, 20, 21, 22], 9, true, false);
		animation.add("WalkDownRight", [23, 24, 25, 26, 27, 28], 9, true, false);
		
		animation.add("WalkUpLeft", [11, 12, 13, 14, 15, 16], 9, true, true);
		animation.add("WalkLeft", [17, 18, 19, 20, 21, 22], 9, true, true);
		animation.add("WalkDownLeft", [23, 24, 25, 26, 27, 28], 9, true, true);
		
		animation.add("SitDownLeft", [35], 9, false, true);
		animation.add("SitUpLeft", [36], 9, false, true);
		animation.add("SitDownRight", [35], 9, false, false);
		animation.add("SitUpRight", [36], 9, false, false);
	}
	
	private function buildAnimationString():String
	{
		currentAction = actionSet.Stand;
		
		if (keysTriggered.North && keysTriggered.East) 
		{			
			previousKeysTriggered.North = true;
			previousKeysTriggered.South = false;
			
			previousKeysTriggered.East = true;
			previousKeysTriggered.West = false;
			
			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = diagVelocity.x;
				this.velocityY = diagVelocity.y * -1;
			}
			
			return currentAction + "UpRight";
		}
		
		else if (keysTriggered.North && keysTriggered.West)
		{
			previousKeysTriggered.North = true;
			previousKeysTriggered.South = false;
			
			previousKeysTriggered.East = false;
			previousKeysTriggered.West = true;
				
			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = diagVelocity.x * -1;
				this.velocityY = diagVelocity.y * -1;
			}
			
			return currentAction + "UpLeft";
		}
		
		else if (keysTriggered.South && keysTriggered.East)
		{			
			previousKeysTriggered.North = false;
			previousKeysTriggered.South = true;
			
			previousKeysTriggered.East = true;
			previousKeysTriggered.West = false;
			
			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = diagVelocity.x;
				this.velocityY = diagVelocity.y;
			}
			
			return currentAction + "DownRight";
		}
		
		else if (keysTriggered.South && keysTriggered.West)
		{
			previousKeysTriggered.North = false;
			previousKeysTriggered.South = true;
			
			previousKeysTriggered.East = false;
			previousKeysTriggered.West = true;
			
			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = diagVelocity.x * -1;
				this.velocityY = diagVelocity.y;
			}
			
			return currentAction + "DownLeft";
		}
		
		else if (keysTriggered.East)
		{			
			previousKeysTriggered.North = false;
			previousKeysTriggered.South = false;
			
			previousKeysTriggered.East = true;
			previousKeysTriggered.West = false;

			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = orthogVelocity.x;
				this.velocityY = 0;
			}
			
			return currentAction + "Right";
		}
		
		else if (keysTriggered.West)
		{
			previousKeysTriggered.North = false;
			previousKeysTriggered.South = false;
			
			previousKeysTriggered.East = false;
			previousKeysTriggered.West = true;
			
			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = orthogVelocity.x * -1;
				this.velocityY = 0;
			}
			
			return currentAction + "Left"; 
		}
		
		else if (keysTriggered.South)
		{			
			previousKeysTriggered.North = false;
			previousKeysTriggered.South = true;
			
			previousKeysTriggered.East = false;
			previousKeysTriggered.West = false;
			
			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = 0;
				this.velocityY = orthogVelocity.y;
			}
			
			return currentAction + "Down"; 
		}
		
		else if (keysTriggered.North)
		{			
			previousKeysTriggered.North = true;
			previousKeysTriggered.South = false;
			
			previousKeysTriggered.East = false;
			previousKeysTriggered.West = false;
			
			if (canWalk)
			{
				currentAction = actionSet.Walk;
				
				this.velocityX = 0;
				this.velocityY = orthogVelocity.y * -1;
			}
			
			return currentAction + "Up";
		}
		
		else
		{
			this.velocityX = 0;
			this.velocityY = 0;
			
			if (currentAction != actionSet.Sit)
			{
				if (isHolding) { currentAction = actionSet.Hold; }
				else { currentAction = actionSet.Stand; }
			}
			
			if (previousKeysTriggered.North && previousKeysTriggered.East) 
			{ return currentAction + "UpRight"; }
			
			else if (previousKeysTriggered.North && previousKeysTriggered.West)
			{ return currentAction + "UpLeft"; }
			
			else if (previousKeysTriggered.South && previousKeysTriggered.East)
			{ return currentAction + "DownRight"; }
			
			else if (previousKeysTriggered.South && previousKeysTriggered.West)
			{ return currentAction + "DownLeft"; }
			
			// In Christ there is no 
			else if (previousKeysTriggered.East)
			{ return currentAction + "Right";  }
			
			// Or
			else if (previousKeysTriggered.West)
			{ return currentAction + "Left"; }
			
			// In Him no
			else if (previousKeysTriggered.South)
			{ return currentAction + "Down"; }
			
			// Or
			else if (previousKeysTriggered.North)
			{ return currentAction + "Up"; }
		}
		
		return currentAction + "Down";
	}
}