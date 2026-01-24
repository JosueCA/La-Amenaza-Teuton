<p align="center">
    <img src="capturas/AMENAZA_TEUTON.png" width="480" alt="Amenaza Teuton Diseño">
    <br>
    <b>Imperivm 1 - La Amenaza Teuton</b>
</p>

## Resumen

Este MOD cambia significativamente la experiencia de juego de "Imperivm: La Guerra de las Galias", enfocándose en tres áreas principales: **balance de unidades**, **mejora de la IA** y **compatibilidad con Wine/Linux**.

---

## 1. Correcciones de Audio (Compatibilidad Wine)

- **Conversión de codec de audio**: Los archivos de voz de las unidades usaban el codec Microsoft ADPCM, que Wine no soporta completamente. Se convirtieron **120+ archivos WAV** de voces (galos, romanos y teutones) a PCM estándar para que funcionen correctamente en Linux/Wine.

## 2. Nuevas resoluciones HD de pantalla

| Resolución | Ancho | Alto | Aspecto |
|------------|-------|------|---------|
| Res1 | 1024 | 768 | 4:3 |
| Res2 | 1152 | 864 | 4:3 |
| Res3 | 1280 | 1024 | 5:4 |
| Res4 | 1440 | 900 | 16:10 |
| Res5 | 1600 | 900 | 16:9 |
| Res6 | 1600 | 1024 | 25:16 |
| Res7 | 1600 | 1050 | 32:21 |
| Res8 | 1600 | 1200 | 4:3 |
| Res9 | 1600 | 1280 | 5:4 |
| Res10 | 1680 | 1050 | 16:10 |
| Res11 | 1920 | 1080 | 16:9 |

Imperivm 1 solo soporta resoluciones horizontales de hasta 1600 píxeles máximo (valor hardcodeado en el binario).

**Las resoluciones 10 y 11 (1680x1050 y 1920x1080) o mayores de 1600 requieren el ejecutable parcheado para jugar (HD/Imperivm.exe).**

1) EL EJECUTABLE PARCHEADO PUEDE PRODUCIR BUGS DENTRO DEL JUEGO. 
2) EL ZOOMMAP ESTÁ LIMITADO A 1600 PARA QUE EL JUEGO NO SE CIERRE.

## 3. Correciones al bioma de invierno
- Reemplazadas las imágenes de los minimap por las de verano
- Reducida la exposición (brillo) de las texturas de terreno de invierno

## 4. Balance de Unidades

### Unidades
- Reajustadas las unidades aleatoriamente
- Tiempos de reclutamiento reducidos

### Arqueros
- Arqueros con más alcance

### Heroes
- Modificaciones en las estadísticas base de heroes (más resistentes)
- Más vida por nivel

### Eliminado 'entrenamiento' de las unidades
- Las unidades del cuartel se generan con el nivel según el nivel de 'entrenamiento' investigado

### Formaciones
- Reducido el 'radio' de las unidades en formación. Las unidades en formaciones están más cerca entre sí.


## Tabla de Estadísticas de Unidades
#TODO

## 5. Mejoras de la IA

### Más "inteligente"
- Mayor dificultad al jugar contra la IA

### Sistema de Construccion de Ejercito

#### Investigacion Proactiva
- Mejorado algoritmo de investigación

#### Seleccion de Unidades Mejorada
- Nuevos **weights** favorecen ejércitos más variados

#### Sistema de Contra-Unidades Mejorado
- Mejor respuesta a las amenazas

### Prioridades de Ataque
- Mejor gestion de objetivos, IA más agresiva
- Mayores ejércitos

### Druidas y Magia
- Ajustes al sistema de reclutamiento de druidas
- La IA utiliza los altares durante las partidas aleatorias

### Monitor de Escuadrones
- Ajustes al sistema de monitoreo y control de unidades

### Teutones
- Los Teutones pueden capturar fortalezas de los jugadores

### Aldeas
- Las aldeas producen campesinos automáticamente junto a las mulas de comida

## Y muchos más cambios sin documentar...

## Notas de Instalacion

Este MOD se aplica directamente sobre la instalacion del juego. Reemplazando los archivos .pak


*** Generado automáticamente ***
