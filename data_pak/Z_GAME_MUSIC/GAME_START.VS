//void
// GAME_START.VS - Reproduce música al inicio de partida
// Detecta la civilización verificando el tipo de townhall
// Selecciona una canción aleatoria de 3 para cada civilización

Query qTownhall;
int player;
int musicStarted;
int track;

// Obtener el jugador desde la variable global
player = EnvReadInt("musicPlayer");

// Verificar si la música ya se inició
musicStarted = EnvReadInt("gameMusicStarted");
if (musicStarted == 1) {
	return;
}

// Marcar que la música ya se inició
EnvWriteInt("gameMusicStarted", 1);

// Detectar civilización por el tipo de townhall
qTownhall = ClassPlayerObjs("RTownhall", player);
if (!qTownhall.IsEmpty()) {
	// Romanos - 3 tracks aleatorios
	track = rand(3);
	if (track == 0) {
		PlayMusic("music/0ad/Calm_Before_the_Storm.ogg");
	} else if (track == 1) {
		PlayMusic("music/0ad/Honor_Bound.ogg");
	} else {
		PlayMusic("music/0ad/Juno_Protect_You.ogg");
	}
	return;
}

qTownhall = ClassPlayerObjs("GTownhall", player);
if (!qTownhall.IsEmpty()) {
	// Galos - 3 tracks aleatorios
	track = rand(3);
	if (track == 0) {
		PlayMusic("music/0ad/Celtica.ogg");
	} else if (track == 1) {
		PlayMusic("music/0ad/Celtic_Pride.ogg");
	} else {
		PlayMusic("music/0ad/Cisalpine_Gaul.ogg");
	}
	return;
}

// Música genérica si no se pudo determinar
// PlayMusic("music/tzar1.ogg");
