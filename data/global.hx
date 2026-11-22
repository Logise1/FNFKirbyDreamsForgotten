var lastMouseX:Float = 0;
var lastMouseY:Float = 0;
var movementThreshold:Float = 10;

function update(elapsed:Float):Void {
	if (FlxG.keys.justPressed.ANY) {
		FlxG.mouse.visible = false;
	}
	
	if (!FlxG.mouse.visible)
	{
	    var mouseX = FlxG.mouse.screenX;
	    var mouseY = FlxG.mouse.screenY;
	    var mouseDeltaX = Math.abs(mouseX - lastMouseX);
	    var mouseDeltaY = Math.abs(mouseY - lastMouseY);
	
	if ((mouseDeltaX > movementThreshold || mouseDeltaY > movementThreshold)) {
		FlxG.mouse.visible = true;
	}
	
	    lastMouseX = mouseX;
	    lastMouseY = mouseY;
	}
}