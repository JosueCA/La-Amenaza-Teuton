# Compatiblidad con aventuras
#### Este MOD no es 100% compatible con las aventuras. Para disfrutar de la experiencia original en Full HD, utilizar el parche independiente para el juego.

## "Celtic Kings Adventure"

- Copiar "Celtic Kings Adventure DEV.BFHP" como "Celtic Kings Adventure.BFHP" para disponer de los objetos de Lárax y saltar rápidamente entre escenarios (experimental, para poder debuguear fallos)

### THORIC

- En el 'Map7' de la aventura se requiere que 'THORIC' resista el ataque de los teutones en una aldea.
```
- Creada clase 'DTHORIC' para usarla en el personaje de la aventura. 
- Reemplazado 'GVIKINGLORD' por la nueva clase
- Ajustados parámetros de la unidad para mantener la compatibilidad
```

### Lleldoryn

```
- Aumentada velocidad de la unidad
```

### Map10 ARENA
- Los Gladiadores deben ganar contra los lobos en el duelo inicial
M10_Main - seq0.vs
```
BlockUserInput();
View(AreaCenter("M10_A_Arena"), false);
SpawnGroup("M10_Q_DreadWolves");
Sleep(1000);
RunAIHelper("FirstEncounter", "guard area", "M10_Q_DreadWolves", "M10_A_Arena" );

// MOD: fix soft lock due to new balance
// WaitQueryCountBetween(M10_Q_DreadWolves, 0, 5, -1 );
//	SpawnGroup("M10_Q_DreadWolves");
```