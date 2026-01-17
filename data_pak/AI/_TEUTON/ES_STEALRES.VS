// void, Settlement set
int idPlayer, i;
point    ptDummy;
Obj      objDummy;

idPlayer = set.player;

while (set.player == idPlayer) {
  point pt;
  Settlement Dest; int nODist = 50000;
  pt = set.GetCentralBuilding.pos;
  // find nearest tent
  for (i = 0; i < MaxSetIdx; i += 1) {
    Settlement s; int dist; 
    s = IdxToSet(i); if (!s.IsTeutonTent) continue;
    dist = s.GetCentralBuilding.pos.Dist(pt);
    if (dist < nODist) { nODist = dist; Dest = s; }
  }

  if (!Dest.IsValid) { Sleep(AIVar(idPlayer,AIV_Sleep_ES)); continue; }

  if (set.gold >= 100) {
    Wagon wagon; wagon = set.CreateMuleGold(set.gold);
    if (wagon.IsValid) {
	    wagon.AddCommand(false, "unload", Dest.GetCentralBuilding);
	    wagon.KillCommand();
    }
  }

  if (set.food >= 100) {
    Wagon wagon; wagon = set.CreateMuleFood(set.food);
    if (wagon.IsValid) {
	    wagon.AddCommand(false, "unload", Dest.GetCentralBuilding);
	    wagon.KillCommand();
    }
  }

	Sleep(AIVar(idPlayer,AIV_Sleep_ES));
}