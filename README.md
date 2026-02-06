<p align="center">
    <img src="capturas/AMENAZA_TEUTON.png" width="480" alt="Amenaza Teuton Diseño">
    <br>
    <b>Imperivm 1 - La Amenaza Teuton</b>
</p>

## Resumen

Este MOD cambia significativamente la experiencia de juego de "Imperivm: La Guerra de las Galias", enfocándose en tres áreas principales: **balance de unidades**, **mejora de la IA** y **compatibilidad con Wine/Linux**.

---

## Tabla de Contenidos

1. [Correcciones de Audio (Compatibilidad Wine)](#1-correcciones-de-audio-compatibilidad-wine)
1. [Nuevas resoluciones HD de pantalla](#2-nuevas-resoluciones-hd-de-pantalla)
1. [Correciones al bioma de invierno](#3-correciones-al-bioma-de-invierno)
1. [Cambios generales](#4-cambios-generales)
1. [Cambios en Unidades](#5-cambios-en-unidades)
   - [Unidades](#unidades)
   - [Arqueros](#arqueros)
   - [Heroes](#heroes)
   - [Eliminado 'entrenamiento' de las unidades](#eliminado-entrenamiento-de-las-unidades)
   - [Formaciones](#formaciones)
   - [Druidas/Sacerdotes](#druidassacerdotes)
   - [Tabla de Estadísticas de Unidades](#tabla-de-estadísticas-de-unidades)
1. [Mejoras de la IA](#6-mejoras-de-la-ia)
   - [Más "inteligente"](#más-inteligente)
   - [Sistema de Construccion de Ejercito](#sistema-de-construccion-de-ejercito)
   - [Prioridades de Ataque](#prioridades-de-ataque)
   - [Fortaleza](#fortaleza)
   - [Druidas y Magia](#druidas-y-magia)
   - [Monitor de Escuadrones](#monitor-de-escuadrones)
   - [Teutones](#teutones)
   - [Aldeas](#aldeas)
1. [Notas de Instalacion](#notas-de-instalacion)

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

## 3. Correcciones al bioma de invierno
- Reemplazadas las imágenes de los minimap por las de verano
- Reducida la exposición (brillo) de las texturas de terreno de invierno

## 4. Cambios generales
- Cambios en la música
- Pequeños ajustes en la interfaz del juego
- Vídeo introductorio reescalado


## 5. Cambios en Unidades

### Unidades
- Reajustadas las unidades aleatoriamente
- Tiempos de reclutamiento ajustados

### Arqueros
- Arqueros con más alcance
- Más débiles
- Fuertes contra unidades con poca vida (habilidad)

### Heroes
- Modificaciones en las estadísticas base de heroes (más resistentes)
- Más vida por nivel
- Añadido un efecto visual cuando el héroe tiene menos del 50% de la vida
- Reutilizados assets de héroes para generar más héroes aleatorios

### Eliminado 'entrenamiento' de las unidades
- Las unidades del cuartel se generan con el nivel según el nivel de 'entrenamiento' investigado

### Formaciones
- Reducido el 'radio' de las unidades en formación. Las unidades en formaciones están más cerca entre sí.

### Druidas/Sacerdotes
- Reducido daño de los hechizos 
- Reimplementado la 'Nube Venenosa' (sacerdote) para que no dañe a unidades amigas  

## Tabla de Estadísticas de Unidades
#TODO

## 6. Mejoras de la IA

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

### Fortaleza
- La IA investiga las mejoras en el coliseo, taberna, templo

### Druidas y Magia
- Ajustes al sistema de reclutamiento de druidas
- La IA utiliza los altares durante las partidas aleatorias
- La IA utiliza los hechizos en el combate (Espiritu Vampiro, Nube venenosa)

### Monitor de Escuadrones
- Ajustes al sistema de monitoreo y control de unidades

### Teutones
- Los Teutones pueden capturar fortalezas de los jugadores

### Ruinas
- La IA usa mejor las ruinas

### Aldeas
- Las aldeas producen campesinos automáticamente junto a las mulas de comida

## Y muchos más cambios sin documentar...

## Notas de Instalacion

Este MOD se aplica directamente sobre la instalacion del juego. Reemplazando los archivos .pak y demás directorios/ficheros incluidos en el zip.


*** Generado automáticamente ***
