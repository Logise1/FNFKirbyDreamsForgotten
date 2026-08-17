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
