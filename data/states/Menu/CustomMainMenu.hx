var optionNames = ["story", "freeplay", "gallery", "options", "soundtest"];
var optionsPos:Array<Array<Float>> = [[41, 184], [608, 50], [533, 319], [255, 460], [355, 464]];
var optionGridIndices:Array<Array<Int>> = [[0, 1], [2, 1], [2, 0], [0, 0], [1, 0]];
var hoverMul = [1.12, 1.12, 1.12, 1.22, 1.22];

var curselect:Array<Int> = [0, 0];
var prevselect:Array<Int> = [0, 0];

var follow:Array<Float> = [0, 0];
var menuItems:Array<{sprite:FlxSprite, xIndex:Int, yIndex:Int}> = [];
var optionStart:Array<Array<Float>> = [];

var aptime:Int;

function create(){

    var canvasW = 1024;
	var canvasH = 657;
	menuScale = Math.max(FlxG.width / canvasW, FlxG.height / canvasH);
	var offsetX = (FlxG.width - canvasW * menuScale) / 2;
	var offsetY = (FlxG.height - canvasH * menuScale) / 2;

    //bg
    bg = new FlxSprite();
	bg.loadGraphic(Paths.image("menus/mainmenu/bg"));
	bg.antialiasing = true;
	bg.scrollFactor.set();
	bg.scale.set(menuScale * 1.08, menuScale * 1.08);
	bg.updateHitbox();
	bgStartX = offsetX - (bg.width - canvasW * menuScale) / 2;
	bgStartY = offsetY - (bg.height - canvasH * menuScale) / 2;
	bg.setPosition(bgStartX, bgStartY);
	add(bg);

    for (i in 0...optionNames.length) {
        var name = optionNames[i];
        var option = createOption(name, offsetX + optionsPos[i][0] * menuScale, offsetY + optionsPos[i][1] * menuScale);
        menuItems.push({
            sprite: option,
            xIndex: optionGridIndices[i][0],
            yIndex: optionGridIndices[i][1]
        });
        optionStart.push([option.x, option.y]);
    }
}

function update(elapsed:Float) {
    updateCameraFollow(elapsed);
    updateOptions(elapsed);
	checkOptions(elapsed);

	if (FlxG.keys.justPressed.DOWN) {
		prevselect[1] = curselect[1];
		curselect[1] = Math.max(0, curselect[1] - 1);
	}
	if (FlxG.keys.justPressed.UP) {
		prevselect[1] = curselect[1];
		curselect[1] = Math.min(1, curselect[1] + 1);
	}
	if (FlxG.keys.justPressed.LEFT) {
		prevselect[0] = curselect[0];
		curselect[0] = Math.max(0, curselect[0] - 1);
	}
	if (FlxG.keys.justPressed.RIGHT) {
		prevselect[0] = curselect[0];
		curselect[0] = Math.min(2, curselect[0] + 1);
	}

	if (!FlxG.mouse.visible){
		follow[0] = FlxMath.lerp(follow[0], (curselect[0] - 1) * -42/4, Math.min(5, elapsed * 5.5));
		follow[1] = FlxMath.lerp(follow[1], (curselect[1] - 0.5) * 28/4, Math.min(5, elapsed * 5.5));
	}

	if (curselect[0] == 1 && curselect[1] == 1){
		if (prevselect[0] != curselect[0]){
			if (prevselect[0] < curselect[0]){
				curselect[0] = Math.min(2, curselect[0] + 1);
			}
			else{
				curselect[0] = Math.max(0, curselect[0] - 1);
			}
		}
		else if (prevselect[0] == 1 && prevselect[1] == 0){
			curselect[0] = 0;
		}
		else if (prevselect[0] == 1 && prevselect[1] == 1){
			curselect[1] = Math.max(0, curselect[1] - 1);
		}
	}

	if (FlxG.keys.justPressed.SEVEN){
		openSubState(new funkin.editors.EditorPicker());
		persistentUpdate = false;
		persistentDraw = true;
	}

	if (controls.SWITCHMOD){
		openSubState(new funkin.menus.ModSwitchMenu());
		persistentUpdate = false;
		persistentDraw = true;
	}

	if ((FlxG.keys.justPressed.ENTER && !FlxG.mouse.visible) || (FlxG.mouse.justPressed && FlxG.mouse.visible)) {
		if (curselect[0] == 0 && curselect[1] == 0){
			//options
			FlxG.switchState(new funkin.options.OptionsMenu());
		}
		else if (curselect[0] == 2 && curselect[1] == 1){
			//freeplay
			FlxG.switchState(new funkin.menus.FreeplayState());
		}
		else if (curselect[0] == 2 && curselect[1] == 0){
			//gallery
			FlxG.switchState(new ModState("Menu/GalleryState"));
		}
		else if (curselect[0] == 0 && curselect[1] == 1){
			//story
			FlxG.switchState(new ModState("Menu/StoryMenuState"));
		}
		else if (curselect[0] == 1 && curselect[1] == 0){
			//soundtest
			FlxG.switchState(new ModState("Menu/SoundTestState"));
		}
	}
	//trace(curselect);
}




//helper functions
function updateCameraFollow(elapsed) {
	var tx = ((FlxG.mouse.screenX / FlxG.width) - 0.5) * 42;
	var ty = ((FlxG.mouse.screenY / FlxG.height) - 0.5) * 28;
	follow[0] = FlxMath.lerp(follow[0], tx, Math.min(1, elapsed * 5.5));
	follow[1] = FlxMath.lerp(follow[1], ty, Math.min(1, elapsed * 5.5));
	bg.x = bgStartX + follow[0] * 0.45;
	bg.y = bgStartY + follow[1] * 0.45;
}

function updateOptions(elapsed) {
    var i = 0;
    while (i < menuItems.length) {
        var option = menuItems[i].sprite;
        option.x = optionStart[i][0] + follow[0];
        option.y = optionStart[i][1] + follow[1];
        i++;
    }
}

function createOption(name:String, x:Float, y:Float) {
	var option = new FlxSprite();
	option.loadGraphic(Paths.image("menus/mainmenu/" + name));
	option.antialiasing = true;
	option.scrollFactor.set();
	option.scale.set(menuScale, menuScale);
	option.updateHitbox();
	option.setPosition(x, y);
	add(option);
	return option;
}

function checkOptions(elapsed) {
	var hoveredIndex = -1;
	if (FlxG.mouse.visible) {
		var hoverCheck = 0;
		while (hoverCheck < menuItems.length) {
			if (FlxG.mouse.overlaps(menuItems[hoverCheck].sprite)) {
				hoveredIndex = hoverCheck;
				break;
			}
			hoverCheck++;
		}
	}

	var i = 0;
    while (i < menuItems.length) {
		var option = menuItems[i].sprite;
		if ((FlxG.mouse.visible && i == hoveredIndex) || (!FlxG.mouse.visible && curselect[0] == menuItems[i].xIndex && curselect[1] == menuItems[i].yIndex)) {
			prevselect[0] = curselect[0];
			prevselect[1] = curselect[1];

			curselect[0] = menuItems[i].xIndex;
			curselect[1] = menuItems[i].yIndex;

			option.scale.x = FlxMath.lerp(option.scale.x, menuScale * hoverMul[i], Math.min(1, elapsed * 5.5));
			option.scale.y = FlxMath.lerp(option.scale.y, menuScale * hoverMul[i], Math.min(1, elapsed * 5.5));
		}
		else{
			option.scale.x = FlxMath.lerp(option.scale.x, menuScale, Math.min(1, elapsed * 5.5));
			option.scale.y = FlxMath.lerp(option.scale.y, menuScale, Math.min(1, elapsed * 5.5));
		}
		i++;
    }
}