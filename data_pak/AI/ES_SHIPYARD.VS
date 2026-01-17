// void, Settlement set
int idPlayer;
str cmd = "buildship";
idPlayer = set.player;

while( set.player == idPlayer )
{
  int needs, ships;
  needs = ShipNeeds(idPlayer, set.WaterLsa);
  ships = Ships(idPlayer, set.WaterLsa);
  if (needs <= ships) { Sleep(AIVar(idPlayer,AIV_Sleep_ES)); continue; }

// temporary
  if (needs - ships >= 100) if (set.CanResearch(cmd)) {
    if (!set.CanAfford(cmd)) {
      // ugly cheat
      int gold, food; GetCmdCost(cmd, gold, food);
      if (set.gold < gold) set.SetGold(gold); 
      if (set.food < food) set.SetFood(food); 
/*
      Sleep(AIVar(idPlayer,AIV_Sleep_ES));
      continue;
*/
    }
    set.Research(cmd);
    ClrShipNeeds(idPlayer, set.WaterLsa);
  }

	Sleep(AIVar(idPlayer,AIV_Sleep_ES));
}