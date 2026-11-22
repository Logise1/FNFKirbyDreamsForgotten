//try not to vibecode things pls

var hovered = -1;
var selectedSomethin = false;
var flickerTime = 0.0;
var leftState = false;

var menuScale = 1.0;
var optionNames = ["story", "freeplay", "gallery", "options", "soundtest"];
var optionTitles = ["STORY", "FREEPLAY", "GALLERY", "OPTIONS", "SOUND TEST"];
var posX = [41, 608, 533, 255, 355];
var posY = [184, 50, 319, 460, 464];
var hoverMul = [1.12, 1.12, 1.12, 1.22, 1.22];

var menuItems = [];
var homeCX = [];
var homeCY = [];
var appearT = [];
var introTime = 0.0;
var bg;
var bgHomeX = 0.0;
var bgHomeY = 0.0;
var followX = 0.0;
var followY = 0.0;

var overlayOn = false;
var overlayTime = 0.0;
var overlayChoice = -1;
var overlayDim;
var overlayIcon;
var overlayTitle;
var overlaySub;
var overlayHint;
var overlayIconHomeX = 0.0;
var overlayIconHomeY = 0.0;

var levelSelectOn = false;
var worldCount = 5;
var worldLocked = [false, true, true, true, true];
var worldNames = ["DREAM LAND", "???", "???", "???", "???"];
var worldSongs = ["tutorial", "", "", "", ""];
var worldSprites = [];
var worldHomeX = [];
var worldHomeY = [];
var worldBaseW = [];
var worldBaseH = [];
var worldAppear = [];
var worldHovered = 0;
var worldShakeT = 0.0;
var worldShakeI = -1;

var lsBg;
var lsBgHomeX = 0.0;
var lsBgHomeY = 0.0;
var lsScale = 1.0;
var lsImgW = 1292.0;
var lsImgH = 584.0;
var slotCX = [466.5, 645.3, 819.2, 529.5, 729.2];
var slotCY = [194.8, 198.3, 195.8, 368.6, 364.6];
var slotW = [119.9, 119.9, 121.9, 115.9, 117.9];
var slotH = [113.9, 112.9, 113.9, 111.9, 115.9];

var irisTransition = importScript("data/scripts/IrisTransition");

function create() {
	skipTransIn = true;
	CoolUtil.playMenuSong();
	FlxG.mouse.visible = true;
	FlxG.camera.scroll.set(0, 0);
	FlxG.camera.bgColor = 0xFFD6CCE8;

	var canvasW = 1024;
	var canvasH = 657;
	menuScale = Math.max(FlxG.width / canvasW, FlxG.height / canvasH);
	var offsetX = (FlxG.width - canvasW * menuScale) / 2;
	var offsetY = (FlxG.height - canvasH * menuScale) / 2;

	bg = new FlxSprite();
	bg.loadGraphic(Paths.image("menus/mainmenu/bg"));
	bg.antialiasing = true;
	bg.scrollFactor.set();
	bg.scale.set(menuScale * 1.08, menuScale * 1.08);
	bg.updateHitbox();
	bgHomeX = offsetX - (bg.width - canvasW * menuScale) / 2;
	bgHomeY = offsetY - (bg.height - canvasH * menuScale) / 2;
	bg.setPosition(bgHomeX, bgHomeY);
	add(bg);

	var i = 0;
	while (i < optionNames.length) {
		var item = new FlxSprite();
		item.loadGraphic(Paths.image("menus/mainmenu/" + optionNames[i]));
		item.antialiasing = true;
		item.scrollFactor.set();
		item.ID = i;
		item.alpha = 0;
		item.scale.set(menuScale, menuScale);
		item.updateHitbox();
		item.x = offsetX + posX[i] * menuScale;
		item.y = offsetY + posY[i] * menuScale;
		homeCX.push(item.x + item.width / 2);
		homeCY.push(item.y + item.height / 2);
		item.scale.set(menuScale * 0.35, menuScale * 0.35);
		item.updateHitbox();
		item.x = homeCX[i] - item.width / 2;
		item.y = homeCY[i] - item.height / 2;
		menuItems.push(item);
		appearT.push(-1.0);
		add(item);
		i++;
	}

	overlayDim = new FlxSprite();
	overlayDim.makeGraphic(FlxG.width, FlxG.height, 0xFF001A44);
	overlayDim.scrollFactor.set();
	overlayDim.visible = false;
	overlayDim.alpha = 0;
	add(overlayDim);

	overlayIcon = new FlxSprite();
	overlayIcon.makeGraphic(1, 1, 0x00000000);
	overlayIcon.antialiasing = true;
	overlayIcon.scrollFactor.set();
	overlayIcon.visible = false;
	add(overlayIcon);

	try {
		overlayTitle = new FlxText(0, 0, FlxG.width, "", 42);
		overlayTitle.setFormat(Paths.font("vcr.ttf"), 42, 0xFFFFFFFF, "center");
		overlayTitle.scrollFactor.set();
		overlayTitle.visible = false;
		add(overlayTitle);

		overlaySub = new FlxText(0, 0, FlxG.width, "Coming soon...", 22);
		overlaySub.setFormat(Paths.font("vcr.ttf"), 22, 0xFFFFE27A, "center");
		overlaySub.scrollFactor.set();
		overlaySub.visible = false;
		add(overlaySub);

		overlayHint = new FlxText(0, FlxG.height - 36, FlxG.width, "CLICK or ESC  -  back to menu", 16);
		overlayHint.setFormat(Paths.font("vcr.ttf"), 16, 0xFFFFFFFF, "center");
		overlayHint.scrollFactor.set();
		overlayHint.visible = false;
		add(overlayHint);
	} catch (e:Dynamic) {}

	createWorlds();
}

function createWorlds() {
	lsBg = new FlxSprite();
	lsBg.loadGraphic(Paths.image("menus/mainmenu/levelselectbg"));
	lsBg.antialiasing = true;
	lsBg.scrollFactor.set();
	lsImgW = lsBg.frameWidth;
	lsImgH = lsBg.frameHeight;
	lsScale = Math.max(FlxG.width / lsImgW, FlxG.height / lsImgH) * 1.06;
	lsBg.setGraphicSize(Math.floor(lsImgW * lsScale), Math.floor(lsImgH * lsScale));
	lsBg.updateHitbox();
	lsBgHomeX = (FlxG.width - lsBg.width) / 2.0;
	lsBgHomeY = (FlxG.height - lsBg.height) / 2.0;
	lsBg.setPosition(lsBgHomeX, lsBgHomeY);
	lsBg.visible = false;
	add(lsBg);

	var i = 0;
	while (i < worldCount) {
		var spr = new FlxSprite();
		if (worldLocked[i])
			spr.loadGraphic(Paths.image("menus/mainmenu/locked"));
		else
			spr.loadGraphic(Paths.image("menus/mainmenu/1st"));
		spr.antialiasing = true;
		spr.scrollFactor.set();
		spr.visible = false;
		spr.alpha = 0;
		worldSprites.push(spr);
		worldAppear.push(-1.0);
		worldHomeX.push(0.0);
		worldHomeY.push(0.0);
		worldBaseW.push(1.0);
		worldBaseH.push(1.0);
		add(spr);
		i++;
	}

	layoutWorlds(0.0, 0.0);

	irisTransition.call("irisTransitionInit");
}

function layoutWorlds(ox, oy) {
	var bw = lsBg.width;
	var bh = lsBg.height;
	var bx = lsBgHomeX + ox;
	var by = lsBgHomeY + oy;
	var i = 0;
	while (i < worldCount) {
		var sw = slotW[i] * bw / lsImgW;
		var sh = slotH[i] * bh / lsImgH;
		var spr = worldSprites[i];
		spr.setGraphicSize(Math.floor(sw), Math.floor(sh));
		spr.updateHitbox();
		worldBaseW[i] = spr.width;
		worldBaseH[i] = spr.height;
		var cx = bx + slotCX[i] * bw / lsImgW;
		var cy = by + slotCY[i] * bh / lsImgH;
		worldHomeX[i] = cx - spr.width / 2.0;
		worldHomeY[i] = cy - spr.height / 2.0;
		spr.x = worldHomeX[i];
		spr.y = worldHomeY[i];
		i++;
	}
}

function update(elapsed) {
	if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.8)
		FlxG.sound.music.volume += 0.5 * elapsed;

	updateCameraFollow(elapsed);

	var irisUpdate = irisTransition.call("irisTransitionUpdate", [elapsed]);
	if (irisUpdate != null) {
		if (irisUpdate.type == "covered")
			irisTransition.call("continueTransition", [doIrisAction(irisUpdate.kind, irisUpdate.arg)]);
		else if (irisUpdate.type == "finished")
			selectedSomethin = false;
	}

	if (levelSelectOn) {
		updateLevelSelect(elapsed);
		return;
	}

	if (overlayOn) {
		updateOverlay(elapsed);
		return;
	}

	updateMenuMotion(elapsed);

	if (selectedSomethin)
		updateFlicker(elapsed);

	if (irisTransition.call("isActive") || selectedSomethin)
		return;

	if (FlxG.mouse.justPressed && hovered >= 0)
		clickItem();

	if (controls.BACK) {
		CoolUtil.playMenuSFX(2);
		startIris(4, 0);
	}

	if (controls.SWITCHMOD) {
		persistentUpdate = false;
		persistentDraw = true;
		openSubState(new ModSwitchMenu());
	}
}

function updateMenuMotion(elapsed) {
	introTime += elapsed;
	if (!selectedSomethin && !irisTransition.call("isActive"))
		updateHover();

	var i = 0;
	while (i < menuItems.length) {
		if (appearT[i] < 0 && introTime >= 0.08 + i * 0.13) {
			appearT[i] = 0;
			CoolUtil.playMenuSFX(0, 0.35);
		}
		if (appearT[i] >= 0)
			appearT[i] += elapsed;

		var item = menuItems[i];
		var p = 0.0;
		if (appearT[i] >= 0)
			p = Math.min(1, appearT[i] / 0.32);

		if (!(selectedSomethin && i == hovered))
			item.alpha = Math.min(1, p * 1.7);

		var target = menuScale;
		if (p < 1) {
			var t1 = p - 1;
			var pop = 1 + 2.70158 * t1 * t1 * t1 + 1.70158 * t1 * t1;
			item.scale.x = menuScale * pop;
		} else {
			if (i == hovered)
				target = menuScale * hoverMul[i];
			item.scale.x = FlxMath.lerp(item.scale.x, target, Math.min(1, elapsed * 14));
		}
		item.scale.y = item.scale.x;
		item.updateHitbox();
		item.x = homeCX[i] - item.width / 2 + followX;
		item.y = homeCY[i] - item.height / 2 + followY;
		i++;
	}
}

function updateCameraFollow(elapsed) {
	var tx = ((FlxG.mouse.screenX / FlxG.width) - 0.5) * 42;
	var ty = ((FlxG.mouse.screenY / FlxG.height) - 0.5) * 28;
	followX = FlxMath.lerp(followX, tx, Math.min(1, elapsed * 5.5));
	followY = FlxMath.lerp(followY, ty, Math.min(1, elapsed * 5.5));
	bg.x = bgHomeX + followX * 0.45;
	bg.y = bgHomeY + followY * 0.45;
}

function updateHover() {
	var next = -1;
	var i = menuItems.length - 1;
	while (i >= 0) {
		if (appearT[i] >= 0.18 && FlxG.mouse.overlaps(menuItems[i])) {
			next = i;
			break;
		}
		i--;
	}

	if (next != hovered) {
		hovered = next;
		if (hovered >= 0)
			CoolUtil.playMenuSFX(0, 0.7);
	}
}

function clickItem() {
	if (selectedSomethin || overlayOn || levelSelectOn || irisTransition.call("isActive") || hovered < 0)
		return;
	selectedSomethin = true;
	leftState = false;
	flickerTime = 0;
	CoolUtil.playMenuSFX(1);
}

function updateFlicker(elapsed) {
	flickerTime += elapsed;
	var item = menuItems[hovered];
	item.visible = (Math.floor(flickerTime * 18) % 2) == 0;

	if (flickerTime >= 0.28 && !irisTransition.call("isActive"))
		startIris(1, hovered);
}

function goToChoice() {
	var choice = hovered;
	if (choice == 0) {
		openLevelSelect();
		return;
	}
	if (choice == 2 || choice == 4) {
		openOverlay(choice);
		return;
	}

	if (choice == 1) {
		skipTransOut = true;
		FlxG.switchState(new FreeplayState());
	} else if (choice == 3) {
		skipTransOut = true;
		FlxG.switchState(new OptionsMenu());
	}
}

function startIris(kind, arg) {
	irisTransition.call("start", [kind, arg]);
}

function doIrisAction(kind, arg) {
	if (kind == 1) {
		hovered = arg;
		goToChoice();
		return arg == 1 || arg == 3;
	} else if (kind == 2) {
		closeLevelSelect();
	} else if (kind == 3) {
		closeOverlay();
	} else if (kind == 4) {
		skipTransOut = true;
		FlxG.switchState(new TitleState());
		return true;
	} else if (kind == 5) {
		skipTransOut = true;
		PlayState.loadSong(worldSongs[arg], "hard");
		PlayState.SONG.stage = "dreamland";
		FlxG.switchState(new PlayState());
		return true;
	}

	return false;
}

function openOverlay(choice) {
	overlayOn = true;
	overlayTime = 0;
	overlayChoice = choice;
	selectedSomethin = false;

	var i = 0;
	while (i < menuItems.length) {
		menuItems[i].visible = false;
		i++;
	}

	overlayIcon.loadGraphic(Paths.image("menus/mainmenu/" + optionNames[choice]));
	overlayIcon.antialiasing = true;
	overlayIcon.scale.set(menuScale * 1.15, menuScale * 1.15);
	overlayIcon.updateHitbox();
	overlayIcon.screenCenter();
	overlayIcon.y -= 30;
	overlayIconHomeX = overlayIcon.x;
	overlayIconHomeY = overlayIcon.y;

	overlayDim.visible = true;
	overlayIcon.visible = true;
	overlayDim.alpha = 0;
	overlayIcon.alpha = 0;

	if (overlayTitle != null) {
		overlayTitle.text = optionTitles[choice];
		overlayTitle.y = overlayIconHomeY + overlayIcon.height + 8;
		overlayTitle.visible = true;
		overlayTitle.alpha = 0;
	}
	if (overlaySub != null) {
		overlaySub.text = "Coming soon...";
		overlaySub.y = overlayIconHomeY + overlayIcon.height + 60;
		overlaySub.visible = true;
		overlaySub.alpha = 0;
	}
	if (overlayHint != null) {
		overlayHint.color = 0xFFFFFFFF;
		overlayHint.visible = true;
		overlayHint.alpha = 0;
	}
}

function closeOverlay() {
	overlayOn = false;
	overlayChoice = -1;
	hovered = -1;
	overlayDim.visible = false;
	overlayIcon.visible = false;
	if (overlayTitle != null) overlayTitle.visible = false;
	if (overlaySub != null) overlaySub.visible = false;
	if (overlayHint != null) overlayHint.visible = false;

	var i = 0;
	while (i < menuItems.length) {
		menuItems[i].visible = true;
		i++;
	}
}

function updateOverlay(elapsed) {
	overlayTime += elapsed;
	var fade = Math.min(1, overlayTime * 5);
	overlayDim.alpha = fade * 0.72;
	overlayIcon.alpha = fade;
	if (overlayTitle != null) overlayTitle.alpha = fade;
	if (overlaySub != null) overlaySub.alpha = fade;
	if (overlayHint != null) overlayHint.alpha = fade;

	overlayIcon.x = overlayIconHomeX + followX;
	overlayIcon.y = overlayIconHomeY + followY + Math.sin(overlayTime * 2) * 6;

	if (fade < 1)
		return;

	if (irisTransition.call("isActive"))
		return;

	if (controls.BACK || FlxG.mouse.justPressed) {
		CoolUtil.playMenuSFX(2);
		startIris(3, 0);
	}
}

function openLevelSelect() {
	levelSelectOn = true;
	overlayTime = 0;
	worldHovered = 0;
	worldShakeT = 0;
	worldShakeI = -1;
	selectedSomethin = false;

	var i = 0;
	while (i < menuItems.length) {
		menuItems[i].visible = false;
		i++;
	}

	i = 0;
	while (i < worldCount) {
		worldAppear[i] = -1.0;
		worldSprites[i].visible = true;
		worldSprites[i].alpha = 0;
		i++;
	}

	lsBg.visible = true;
	overlayDim.visible = false;
	if (overlayTitle != null)
		overlayTitle.visible = false;
	if (overlaySub != null)
		overlaySub.visible = false;
	if (overlayHint != null) {
		overlayHint.color = 0xFFFFFFFF;
		overlayHint.visible = true;
		overlayHint.alpha = 0;
	}
}

function closeLevelSelect() {
	levelSelectOn = false;
	hovered = -1;
	lsBg.visible = false;
	overlayDim.visible = false;
	if (overlayTitle != null) overlayTitle.visible = false;
	if (overlaySub != null) overlaySub.visible = false;
	if (overlayHint != null) overlayHint.visible = false;

	var i = 0;
	while (i < worldCount) {
		worldSprites[i].visible = false;
		i++;
	}

	i = 0;
	while (i < menuItems.length) {
		menuItems[i].visible = true;
		i++;
	}
}

function updateLevelSelect(elapsed) {
	overlayTime += elapsed;
	if (worldShakeT > 0)
		worldShakeT -= elapsed;

	var fade = Math.min(1, overlayTime * 5);
	var ox = followX * 0.45;
	var oy = followY * 0.45;
	lsBg.x = lsBgHomeX + ox;
	lsBg.y = lsBgHomeY + oy;
	if (overlayHint != null) overlayHint.alpha = fade;

	var nextHover = worldHovered;
	var i = 0;
	while (i < worldCount) {
		if (worldAppear[i] < 0 && overlayTime >= 0.12 + i * 0.1) {
			worldAppear[i] = 0;
			CoolUtil.playMenuSFX(0, 0.28);
		}
		if (worldAppear[i] >= 0)
			worldAppear[i] += elapsed;

		var p = 0.0;
		if (worldAppear[i] >= 0)
			p = Math.min(1, worldAppear[i] / 0.28);

		var spr = worldSprites[i];
		spr.alpha = p;
		var mul = 1.0;
		if (p < 1) {
			var t1 = p - 1;
			mul = 1 + 2.70158 * t1 * t1 * t1 + 1.70158 * t1 * t1;
		} else if (i == worldHovered) {
			mul = 1.08;
		}

		var bw = lsBg.width;
		var bh = lsBg.height;
		var sw = slotW[i] * bw / lsImgW * mul;
		var sh = slotH[i] * bh / lsImgH * mul;
		spr.setGraphicSize(Math.floor(sw), Math.floor(sh));
		spr.updateHitbox();

		var shake = 0.0;
		if (i == worldShakeI && worldShakeT > 0)
			shake = Math.sin(worldShakeT * 55) * 10 * (worldShakeT / 0.22);

		var cx = lsBg.x + slotCX[i] * bw / lsImgW;
		var cy = lsBg.y + slotCY[i] * bh / lsImgH;
		spr.x = cx - spr.width / 2.0 + shake;
		spr.y = cy - spr.height / 2.0;

		if (!selectedSomethin && !irisTransition.call("isActive") && p > 0.35 && FlxG.mouse.overlaps(spr))
			nextHover = i;
		i++;
	}

	if (nextHover != worldHovered) {
		worldHovered = nextHover;
		CoolUtil.playMenuSFX(0, 0.7);
	}

	if (selectedSomethin) {
		flickerTime += elapsed;
		var blinkItem = worldSprites[worldHovered];
		blinkItem.visible = (Math.floor(flickerTime * 18) % 2) == 0;
		if (flickerTime >= 0.28 && !irisTransition.call("isActive"))
			startIris(5, worldHovered);
	}

	if (fade < 1)
		return;

	if (irisTransition.call("isActive") || selectedSomethin)
		return;

	if (FlxG.keys.justPressed.LEFT && worldHovered > 0) {
		worldHovered -= 1;
		CoolUtil.playMenuSFX(0, 0.7);
	}
	if (FlxG.keys.justPressed.RIGHT && worldHovered < worldCount - 1) {
		worldHovered += 1;
		CoolUtil.playMenuSFX(0, 0.7);
	}

	var confirm = FlxG.mouse.justPressed || FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE;
	if (confirm) {
		var clickedWorld = -1;
		if (FlxG.mouse.justPressed) {
			i = worldCount - 1;
			while (i >= 0) {
				if (worldSprites[i].alpha > 0.35 && FlxG.mouse.overlaps(worldSprites[i])) {
					clickedWorld = i;
					break;
				}
				i--;
			}
			if (clickedWorld < 0) {
				CoolUtil.playMenuSFX(2);
				startIris(2, 0);
				return;
			}
			worldHovered = clickedWorld;
		}

		if (worldLocked[worldHovered]) {
			CoolUtil.playMenuSFX(2);
			worldShakeT = 0.22;
			worldShakeI = worldHovered;
			return;
		}

		CoolUtil.playMenuSFX(1);
		selectedSomethin = true;
		leftState = false;
		flickerTime = 0;
		hovered = worldHovered;
		return;
	}

	if (controls.BACK) {
		CoolUtil.playMenuSFX(2);
		startIris(2, 0);
	}
}
