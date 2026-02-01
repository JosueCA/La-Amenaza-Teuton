// void, Obj This, ref int lastHealthEffectTime
// Función de utilidad para monitorear la salud del héroe
// Muestra efecto visual si la salud está por debajo del 50%
// Debe ser llamada desde otros métodos del héroe

Hero this;

this = This.AsHero;

// Verificar que el héroe sigue vivo
if (!this.IsAlive)
	return;

// Verificar si la salud está por debajo de la mitad
if (.health > 0 && .health < (.maxhealth / 2))
{
	// Evitar spam de efectos - solo mostrar cada 3 segundos
	if (GetTime() - lastHealthEffectTime > 3000)
	{
		CreateFeedback("Heal", .AsUnit());
		lastHealthEffectTime = GetTime();
	}
}
