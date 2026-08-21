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
}
