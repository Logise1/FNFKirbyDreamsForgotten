var stageZoom = 0.58;
var camX = 680.0;
var camY = 160.0;
var shaderTime = 0.0;
var waterShader = null;
var swirlShader = null;
var vigShader = null;
var extraDad = null;
var extraGf = null;

function create() {
	defaultCamZoom = stageZoom;
}

function postCreate() {
	lockCam();
	try { setupShaders(); } catch (e:Dynamic) {}
	try { spawnStageDad(); } catch (e:Dynamic) {}
	try { addOverlay(); } catch (e:Dynamic) {}
	try { setupHealthbar(); } catch (e:Dynamic) {}
}

function isDadChar(ch) {
	if (ch == null) return false;
	var n = "";
	try { n = ch.curCharacter; } catch (e:Dynamic) {}
	try { if (n == null || n == "") n = ch.character; } catch (e:Dynamic) {}
	if (n == null) n = "";
	n = n.toLowerCase();
	return n == "dad" || n.indexOf("dad") >= 0;
}

function isGfChar(ch) {
	if (ch == null) return false;
	var n = "";
	try { n = ch.curCharacter; } catch (e:Dynamic) {}
	try { if (n == null || n == "") n = ch.character; } catch (e:Dynamic) {}
	if (n == null) n = "";
	n = n.toLowerCase();
	return n == "gf" || n.indexOf("girlfriend") >= 0 || n.indexOf("gf-") >= 0;
}

function insertBefore(target, spr) {
	var idx = -1;
	try { idx = PlayState.instance.members.indexOf(target); } catch (e:Dynamic) {}
	if (idx >= 0)
		PlayState.instance.insert(idx, spr);
	else
		PlayState.instance.add(spr);
}

function spawnStageDad() {
	var existing = null;
	try { existing = dad; } catch (e:Dynamic) {}
	try { if (existing == null) existing = PlayState.instance.dad; } catch (e:Dynamic) {}
	if (isDadChar(existing)) {
		existing.setPosition(98, 11);
		extraDad = existing;
		return;
	}

	extraDad = new Character(98, 11, "dad", false);
	extraDad.scrollFactor.set(1, 1);
	insertBefore(boyfriend, extraDad);

	if (isGfChar(existing))
		existing.setPosition(677, -337);
}

function addOverlay() {
	var ov = new FlxSprite(-450, -520);
	ov.loadGraphic(Paths.image("stages/dreamland/overlay"));
	ov.antialiasing = true;
	ov.scrollFactor.set(1, 1);
	ov.scale.set(0.95, 0.95);
	ov.updateHitbox();
	PlayState.instance.add(ov);
}

var hbScale = 0.62;
var hbSlotX = 300.0;
var hbSlotY = 82.0;
var hbSlotW = 418.0;
var hbSlotH = 12.0;
var hbWell = 71.0;
var hbWellLX = 211.0;
var hbWellRX = 738.0;
var hbWellY = 59.0;
var hbWoodTop = 31.0;
var hbWoodBot = 175.0;
var hbTextY = 0.0;
var hbTextLeft = 0.0;
var hbTextRight = 0.0;
var hbTextMid = 0.0;

function setupHealthbar() {
	healthBarBG.loadGraphic(Paths.image("stages/dreamland/healthbar"));
	healthBarBG.antialiasing = true;
	healthBarBG.scale.set(hbScale, hbScale);
	healthBarBG.updateHitbox();
	healthBarBG.offset.set(0, 0);
	healthBarBG.origin.set(0, 0);
	healthBarBG.x = (FlxG.width - healthBarBG.width) * 0.5;
	healthBarBG.y = FlxG.height - hbWoodBot * hbScale - 2;

	healthBar.scale.set(1, 1);
	healthBar.updateHitbox();
	var bw = healthBar.width;
	var bh = healthBar.height;
	if (bw < 1) bw = 1;
	if (bh < 1) bh = 1;
	healthBar.scale.set((hbSlotW * hbScale) / bw, (hbSlotH * hbScale) / bh);
	healthBar.updateHitbox();
	healthBar.offset.set(0, 0);
	healthBar.origin.set(0, 0);
	healthBar.x = healthBarBG.x + hbSlotX * hbScale;
	healthBar.y = healthBarBG.y + hbSlotY * hbScale;

	var ps = PlayState.instance;
	ps.remove(healthBar, true);
	ps.remove(healthBarBG, true);
	var idx = ps.members.indexOf(iconP1);
	if (idx < 0) idx = ps.members.length;
	ps.insert(idx, healthBar);
	ps.insert(idx + 1, healthBarBG);

	hbTextY = healthBarBG.y + 136 * hbScale;
	hbTextLeft = healthBarBG.x + 140 * hbScale;
	hbTextRight = healthBarBG.x + 880 * hbScale;
	hbTextMid = (hbTextLeft + hbTextRight) * 0.5;

	stickHudText(accuracyTxt, "left");
	stickHudText(missesTxt, "center");
	stickHudText(scoreTxt, "right");
	pinHudText();

	var iconScale = (120.0 * hbScale) / 150.0;
	iconP1.defaultScale = iconScale;
	iconP2.defaultScale = iconScale;
	iconP1.scale.set(iconScale, iconScale);
	iconP2.scale.set(iconScale, iconScale);
	iconP1.updateHitbox();
	iconP2.updateHitbox();

	try { PlayState.instance.updateIconPositions = placeHealthIcons; } catch (e:Dynamic) {}
	try { updateIconPositions = placeHealthIcons; } catch (e:Dynamic) {}
	placeHealthIcons();
}

function stickHudText(t, align) {
	if (t == null) return;
	try { t.autoSize = true; } catch (e:Dynamic) {}
	try { t.wordWrap = false; } catch (e:Dynamic) {}
	try { t.alignment = align; } catch (e:Dynamic) {}
}

function pinHudText() {
	if (accuracyTxt == null) return;
	accuracyTxt.y = hbTextY;
	missesTxt.y = hbTextY;
	scoreTxt.y = hbTextY;
	accuracyTxt.x = hbTextLeft;
	missesTxt.x = hbTextMid - missesTxt.width * 0.5;
	scoreTxt.x = hbTextRight - scoreTxt.width;
}

function placeHealthIcons() {
	var well = hbWell * hbScale;
	iconP2.x = healthBarBG.x + hbWellLX * hbScale + (well - iconP2.width) * 0.5;
	iconP2.y = healthBarBG.y + hbWellY * hbScale + (well - iconP2.height) * 0.5;
	iconP1.x = healthBarBG.x + hbWellRX * hbScale + (well - iconP1.width) * 0.5;
	iconP1.y = healthBarBG.y + hbWellY * hbScale + (well - iconP1.height) * 0.5;
	var p = 50.0;
	try { p = healthBar.percent; } catch (e:Dynamic) {}
	iconP1.health = p / 100;
	iconP2.health = 1 - (p / 100);
}

function setupShaders() {
	try {
		if (Options.gameplayShaders == false)
			return;
	} catch (e:Dynamic) {}

	waterShader = new CustomShader("dreamWater");
	waterShader.uTime = 0.0;
	waterShader.uStrength = 0.006;
	waterShader.uSpeed = 1.7;

	swirlShader = new CustomShader("dreamWater");
	swirlShader.uTime = 0.0;
	swirlShader.uStrength = 0.01;
	swirlShader.uSpeed = 2.1;

	vigShader = new CustomShader("dreamVignette");
	vigShader.amount = 0.45;

	var waterSpr = stage.getSprite("water");
	var swirlSpr = stage.getSprite("waterSwirl");
	if (waterSpr != null) waterSpr.shader = waterShader;
	if (swirlSpr != null) swirlSpr.shader = swirlShader;

	camGame.addShader(vigShader);
}

function lockCam() {
	defaultCamZoom = stageZoom;
	camGame.zoom = stageZoom;
	FlxG.camera.zoom = stageZoom;
	camZooming = false;
	camFollow.setPosition(camX, camY);
	FlxG.camera.followEnabled = false;
	FlxG.camera.scroll.set(camX - FlxG.width * 0.5, camY - FlxG.height * 0.5);
}

function onCameraMove(event) {
	event.position.x = camX;
	event.position.y = camY;
}

function onEvent(e) {
	if (e.event != null && e.event.name == "Camera Movement")
		e.cancel();
}

function onNoteHit(event) {
	camZooming = false;
}

function beatHit(curBeat) {
	if (extraDad != null)
		extraDad.dance();
	if (extraGf != null)
		extraGf.dance();
}

function update(elapsed) {
	lockCam();
	shaderTime += elapsed;
	if (waterShader != null) waterShader.uTime = shaderTime;
	if (swirlShader != null) swirlShader.uTime = shaderTime;
	try { pinHudText(); } catch (e:Dynamic) {}
}
