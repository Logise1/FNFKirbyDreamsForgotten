static var redirectStates:Map<FlxState, String> = [
	MainMenuState => "CustomMainMenu"
];

function preStateSwitch() {
	try {
		for (redirectState in redirectStates.keys()) {
			if (FlxG.game._requestedState is redirectState)
				FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
		}
	} catch (e:Dynamic) {}
}

function preStateCreate(state) {
	try {
		if (PlayState.SONG != null) {
			var n = PlayState.SONG.meta != null ? PlayState.SONG.meta.name : null;
			if (n != null && n.toLowerCase().indexOf("tutorial") != -1)
				PlayState.SONG.stage = "dreamland";
		}
	} catch (e:Dynamic) {}
}
