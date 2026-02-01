// void, Obj This
// Script que monitorea la salud del héroe cada 1 segundo
// Si la vida está por debajo del 50%, muestra múltiples efectos visuales

Hero this;
int lastEffectTime;
int currentHealth;

this = This.AsHero();
lastEffectTime = 0;

// Bucle infinito que se ejecuta mientras el héroe esté vivo
while(1)
{
	// Verificar que el objeto This sigue siendo válido antes de convertirlo
	if (!This.IsValid())
		return;

	// Verificar que el héroe sigue vivo
	if (!this.IsValid() || this.IsDead())
		return;

	// Capturar salud en variable local para evitar accesos múltiples
	currentHealth = this.health;

	// Verificar si la salud está por debajo de la mitad
	if (currentHealth > 0 && currentHealth < (this.maxhealth / 2))
	{
		// Evitar spam de efectos - solo mostrar cada 3 segundos
		if (GetTime() - lastEffectTime > 3000)
		{
			// Efecto visual de curación
			CreateFeedback("Damage2", this.AsUnit());
			lastEffectTime = GetTime();
		}
	}

	// Esperar antes de la siguiente comprobación
	Sleep(500);
}
