var gallery;
var galleryHomeX = 0.0;
var galleryHomeY = 0.0;
var bg;
var bgHomeX = 0.0;
var bgHomeY = 0.0;
var followX = 0.0;
var followY = 0.0;
var canLeave = true;
var menuTime = 0.0;

function create() {
	skipTransIn = true;
	CoolUtil.playMenuSong();
	FlxG.mouse.visible = true;
	FlxG.camera.scroll.set(0, 0);
	FlxG.camera.bgColor = 0xFFD6CCE8;

	var canvasW = 1024;
	var canvasH = 657;
	var menuScale = Math.max(FlxG.width / canvasW, FlxG.height / canvasH);
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

	var dim = new FlxSprite();
	dim.makeGraphic(FlxG.width, FlxG.height, 0x88001A44);
	dim.scrollFactor.set();
	add(dim);

	gallery = new FlxSprite();
	gallery.loadGraphic(Paths.image("menus/mainmenu/gallery"));
	gallery.antialiasing = true;
	gallery.scrollFactor.set();
	gallery.scale.set(menuScale * 1.15, menuScale * 1.15);
	gallery.updateHitbox();
	gallery.screenCenter();
	gallery.y -= 30;
	galleryHomeX = gallery.x;
	galleryHomeY = gallery.y;
	add(gallery);

	var title = new FunkinText(0, gallery.y + gallery.height + 8, FlxG.width, "GALLERY", 42);
	title.alignment = "center";
	title.scrollFactor.set();
	add(title);

	var subtitle = new FunkinText(0, title.y + 52, FlxG.width, "Coming soon...", 22);
	subtitle.alignment = "center";
	subtitle.color = 0xFFFFE27A;
	subtitle.scrollFactor.set();
	add(subtitle);

	var hint = new FunkinText(0, FlxG.height - 36, FlxG.width, "CLICK or ESC  -  back to menu", 16);
	hint.alignment = "center";
	hint.scrollFactor.set();
	add(hint);
}

function update(elapsed) {
	menuTime += elapsed;

	var tx = ((FlxG.mouse.screenX / FlxG.width) - 0.5) * 42;
	var ty = ((FlxG.mouse.screenY / FlxG.height) - 0.5) * 28;
	followX = FlxMath.lerp(followX, tx, Math.min(1, elapsed * 5.5));
	followY = FlxMath.lerp(followY, ty, Math.min(1, elapsed * 5.5));
	bg.x = bgHomeX + followX * 0.45;
	bg.y = bgHomeY + followY * 0.45;
	gallery.x = galleryHomeX + followX;
	gallery.y = galleryHomeY + followY + Math.sin(menuTime * 2) * 6;

	if (!canLeave)
		return;

	if (controls.BACK || FlxG.mouse.justPressed) {
		canLeave = false;
		CoolUtil.playMenuSFX(2);
		FlxG.switchState(new MainMenuState());
	}
}
