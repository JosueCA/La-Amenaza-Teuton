//void
// Z_MUSIC_UTILS.VS - Utilidades de música para scripts
//
// Variables de entorno soportadas:
//   musicAction: "play", "stop", "check"
//   musicFile: ruta del archivo (ej: "music\\ammonRa.ogg")
//   musicResult: resultado de "check" (1=playing, 0=stopped)
//
// Uso desde otros scripts:
//   EnvWriteString("musicAction", "play");
//   EnvWriteString("musicFile", "music\\miCancion.ogg");
//   Run("data/subai/Z_MUSIC_UTILS.VS");
//
//   EnvWriteString("musicAction", "stop");
//   Run("data/subai/Z_MUSIC_UTILS.VS");
//
//   EnvWriteString("musicAction", "check");
//   Run("data/subai/Z_MUSIC_UTILS.VS");
//   int playing = EnvReadInt("musicResult");

str action;
str file;

action = EnvReadString("musicAction");

if (action == "play") {
	file = EnvReadString("musicFile");

	if (MusicPlaying()) {
		PlayMusic("");
	}

	if (file != "") {
		PlayMusic(file);
	}
}

if (action == "stop") {
	PlayMusic("");
}

if (action == "check") {
	if (MusicPlaying()) {
		EnvWriteInt("musicResult", 1);
	} else {
		EnvWriteInt("musicResult", 0);
	}
}

// Limpiar variables después de usar
EnvWriteString("musicAction", "");
