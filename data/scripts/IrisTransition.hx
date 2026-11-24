var iris:FlxSprite;
var irisOn = false;
var irisT = 0.0;
var irisPhase = 0;
var irisMax = 1.15;
var irisKind = 0;
var irisArg = 0;
var irisPending = false;
var irisLeave = false;
var irisShader;
var irisRadius = 0.0;
var irisFinishPending = false;

function create(event) {
	irisTransitionInit();
	start(0, null);
	irisFinishPending = false;
	if (!event.transOut) {
		irisPhase = 1;
		irisRadius = 0;
		applyIrisRadius();
	}
	event.cancelled = true;
}

function update(elapsed) {
	var transition = irisTransitionUpdate(elapsed);
	if (transition != null)
		irisFinishPending = true;
}

function postUpdate(elapsed) {
	if (irisFinishPending) {
		irisFinishPending = false;
		finish();
	}
}

function onResize(event) {
	updateIrisMax();
	iris.setGraphicSize(FlxG.width + 100, FlxG.height + 100);
	iris.updateHitbox();
	iris.setPosition(-50, -50);
	applyIrisRadius();
}

function irisTransitionInit() {
	updateIrisMax();
	iris = new FlxSprite(-50, -50);
	iris.makeGraphic(20, 20, 0xFF000000, true);
	iris.scrollFactor.set();
	iris.setGraphicSize(FlxG.width + 100, FlxG.height + 100);
	iris.updateHitbox();
	iris.visible = false;
	try {
		irisShader = new CustomShader("irisHole");
		irisShader.radius = 1.4;
		irisShader.feather = 0.012;
		irisShader.aspect = FlxG.width / FlxG.height;
		iris.shader = irisShader;
	} catch (e:Dynamic) {
		irisShader = null;
	}
	add(iris);
}

function updateIrisMax() {
	var halfAspect = FlxG.width / FlxG.height / 2;
	irisMax = Math.max(1.15, Math.sqrt(halfAspect * halfAspect + 0.25) + 0.05);
}

function start(kind, arg) {
	if (irisOn)
		return;

	irisOn = true;
	irisLeave = false;
	irisPending = false;
	irisPhase = 0;
	irisT = 0;
	irisKind = kind;
	irisArg = arg;
	irisRadius = irisMax;
	iris.visible = true;
	iris.alpha = 1;
	iris.setGraphicSize(FlxG.width + 100, FlxG.height + 100);
	iris.updateHitbox();
	iris.setPosition(-50, -50);
	applyIrisRadius();
	remove(iris);
	add(iris);
}

function irisTransitionUpdate(elapsed) {
	if (!irisOn || irisLeave || irisPending)
		return null;

	irisT += elapsed;
	if (irisPhase == 0) {
		var t = Math.min(1, irisT / 0.42);
		irisRadius = irisMax * (1 - t * t * t);
		applyIrisRadius();
		if (t >= 1) {
			irisPending = true;
			return {type: "covered", kind: irisKind, arg: irisArg};
		}
		return null;
	}

	var t = Math.min(1, irisT / 0.46);
	var u = 1 - (1 - t) * (1 - t) * (1 - t);
	irisRadius = irisMax * u;
	applyIrisRadius();
	if (t >= 1) {
		irisOn = false;
		iris.visible = false;
		return {type: "finished"};
	}
	return null;
}

function continueTransition(leave) {
	irisPending = false;
	if (leave) {
		irisLeave = true;
		return;
	}

	irisPhase = 1;
	irisT = 0;
}

function isActive() {
	return irisOn;
}

function applyIrisRadius() {
	if (irisShader == null)
		return;

	var r = irisRadius;
	if (r < 0)
		r = 0;
	irisShader.radius = r;
	irisShader.feather = 0.012;
	irisShader.aspect = FlxG.width / FlxG.height;
}
