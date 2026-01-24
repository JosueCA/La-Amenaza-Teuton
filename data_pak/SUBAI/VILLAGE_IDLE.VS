// void, Obj This

Settlement this;
int min_resource;
Wagon wagon;
Building central;
Unit unit;
point ptDest, pt;
int lRadius, i;
int lastPeasantTime, currentTime;
int peasantCooldown;

this = This.AsBuilding().settlement;
min_resource = GetConst("MinResQtyToTransport");
lRadius = GetConst("VillageTrainPeasantRadius");
central = This.AsBuilding();
lastPeasantTime = 0;
peasantCooldown = 30000; // 30 segundos en milisegundos

while (1) {
	Sleep(3000);
	if (.supplied == this)
		.StopSupply();
	if (!.supplied.IsValid()) continue;

	// Enviar recursos
	if (.gold > min_resource) {
		wagon = .CreateMuleGold(1000);
		wagon.SetCommand("unload", .supplied.GetCentralBuilding());
	} else
	if (.food > min_resource) {
		wagon = .CreateMuleFood(1000);
		wagon.SetCommand("unload", .supplied.GetCentralBuilding());

		// Enviar 2 campesinos junto con la mula de comida (cooldown de 1 minuto)
		// Solo si el edificio destino tiene capacidad de población
		currentTime = GetTime();
		if (currentTime - lastPeasantTime >= peasantCooldown && .supplied.GetCentralBuilding().settlement.max_population > 0) {
			lastPeasantTime = currentTime;

			for (i = 0; i < 2; i += 1) {
				ptDest.Set(1,1);
				ptDest.SetLen(rand(lRadius - central.radius) + central.radius);
				ptDest.Rot(rand(360));
				ptDest = ptDest + central.pos;
				pt = central.GetExitPoint(ptDest, false);

				// Evitar que los campesinos aparezcan en el mismo punto
				if (i == 0)
					pt.Set(pt.x + 10, pt.y + 10);
				else if (i == 1)
					pt.Set(pt.x - 10, pt.y - 10);
				else if (i == 2)
					pt.Set(pt.x - 10, pt.y + 10);
				else if (i == 3)
					pt.Set(pt.x + 10, pt.y - 10);
				else
					pt.Set(pt.x + 10, pt.y);

				if (central.IsGaulVillage)
					if (rand(2) == 1)
						unit = Place("GVillager", pt, central.player).AsUnit();
					else
						unit = Place("GWVillager", pt, central.player).AsUnit();
				else
					if (rand(2) == 1)
						unit = Place("RVillager", pt, central.player).AsUnit();
					else
						unit = Place("RWVillager", pt, central.player).AsUnit();

				unit.SetCommand("enter", .supplied.GetCentralBuilding());
				Sleep(250);
			}
		}
	}
}