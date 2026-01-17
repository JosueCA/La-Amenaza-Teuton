// int, GAIKA g, int idPlayer, bool bMin, int own, int ally, int enemy

bool bCap = true;
int nEval = 0;
int own1, ally1, enemy1;
int vikings;
Settlement Set; Set = g.settlement;

if (!g.Explored(idPlayer)) if (!g.settlement.IsTeutonTent || GetTime > 600000)
  return 1;

if (g.settlement.IsIndependent) if (!g.settlement.IsTeutonTent) if (!g.settlement.IsStronghold)
	return 1;

// TeutonTent: require more army at game start, don't attack too early
if (g.settlement.IsTeutonTent) {
  if (GetTime < 300000) return 99999; // Don't attack tents in first 5 minutes
  if (GetTime < 600000) if (MilEval(idPlayer) < 3000) return 99999; // Need 3000+ eval before attacking tents early
}

if (!g.Revealed(idPlayer)) if (!g.settlement.IsStronghold) if (GetTime - g.LastSeen(idPlayer) >= 200000)
  enemy = 1; // expect only few enemies if non-stronghold GIAKA not visited for 20.000 ms

// Add enemies from adjacent revealed GAIKA
g.EvalNeighbors(AI_STAYING, idPlayer, own1, ally1, enemy1, true); // 'true' == revealed GAIKA only
enemy += enemy1*2/3;

if( Set.IsValid )
  if (Set.IsOwn(idPlayer)) { // own settlement
    if (enemy == 0) { // protect unattacked settlements
      if (Set.IsOutpost) if (Set.supplied.IsValid) // trading outpost, some protection
        if (bMin) nEval = 6000; else nEval = 10000;
      return nEval; 
    } else if (enemy > 500)
			bCap = false; // no minimum when defending our settlements
  } else if (!Set.IsStronghold && !Set.IsVillage && !Set.IsOutpost && !Set.IsShipyard) {
    if (enemy == 0)
      return 0;
    // TeutonTents are dangerous - increase enemy weight significantly
    if (Set.IsTeutonTent) {
      enemy = enemy * 4; // Cuadruple the perceived enemy strength
      if (enemy < 4000) enemy = 4000; // Minimum perceived threat
    }
  } else if (Set.IsIndependent) {
		if (Set.IsStronghold)
			return 1500;
    if (enemy == 0)
      return 1;
  } else if (Set.IsEnemy(idPlayer)) {// enemy settlement
    nEval += 1;
		if (Set.IsStronghold) { // strongholds are tough :)
      if (bMin) nEval += 5000; else nEval += 10000;
			enemy += enemy1/2;
			vikings = EvalGroup("Player"+idPlayer+"GVikingLord");
		}
    else if (Set.IsVillage) {
      Settlement s; s = NearestStronghold(Set.GetCentralBuilding.pos, idPlayer);
      if (s.IsValid) if (s.food < 100)
        bCap = false; // no minimum for enemy villages if starving
    }
  }

// enemies
if (bMin) { // min
  int min;
  if (!bCap) min = 0;
  else if (GetTime < 60000) min = 2000;
  else if (GetTime < 120000) min = 5000;
  else if (GetTime < 180000) min = 8000;
  else min = 9000;
	if (Set.IsStronghold) if (Set.IsEnemy(idPlayer))
		if (!bCap) if (min<vikings+3000) min = vikings+3000; // Do not attack strongholds with viking lords only
  // TeutonTents require significant minimum army
  if (Set.IsTeutonTent) {
    if (GetTime < 60000) min = 6000; // First 1 min: need 4000 eval minimum
    else min = 6000; // After 10 min: need 3000 eval minimum
  }
  if (GetTime<60000) // Be more careful at game start
		nEval += enemy * 15 / 10;
	else
		nEval += enemy * 11 / 10;
  if ((nEval > 0) && (nEval < min)) nEval = min;
} else {
  int min;
  if (!bCap) min = 0;
  else if (GetTime < 30000) min = 4000;
  else if (GetTime < 60000) min = 6000;
  else if (GetTime < 90000) min = 10000;
  else min = 12000;
	if (Set.IsStronghold) if (Set.IsEnemy(idPlayer))
		if (!bCap) if (min<vikings+3000) min = vikings+6000; // Do not attack strongholds with viking lords only
  // TeutonTents require significant maximum army for proper attack
  if (Set.IsTeutonTent) {
    if (GetTime < 60000) min = 6000; // First 1 min: want 6000 eval for full attack
    else min = 9000; // After 10 min: want 9000 eval for full attack
  }
	nEval += enemy * 4;
  if ((nEval > 0) && (nEval < min)) nEval = min;
}

/*if (!g.Revealed(idPlayer)) if (nEval == 0) if (GetTime - g.LastSeen(idPlayer) >= 300000)
  nEval = 1; // wish to check out GAIKA's not visited for 5 min*/

return nEval;