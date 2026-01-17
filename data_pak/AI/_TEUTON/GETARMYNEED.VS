// int, GAIKA g, int idPlayer, bool bMin, int own, int ally, int enemy

bool bCap = true;
int nEval = 0;
Settlement Set; Set = g.settlement;

if( Set.IsValid )
  if (Set.IsOwn(idPlayer)) { // own settlement
    bCap = false; // no minimum when defending our settlements
  } else if (!Set.IsStronghold && !Set.IsVillage && !Set.IsOutpost && !Set.IsShipyard) {
    if (enemy == 0) 
      return 0;
  } else if (Set.IsEnemy(idPlayer)) {// enemy settlement
    nEval += 1;
		if (Set.IsStronghold) 
      if (bMin) nEval += 3000; else nEval += 10000; // strongholds are tough :)
  }

// enemies
if (bMin) { // min 
  int min;
  if (!bCap) min = 0;
  else if (GetTime < 600000) min = 2000;
  else if (GetTime < 120000) min = 3000;
  else if (GetTime < 180000) min = 5000;
  else min = 6000;
  nEval += enemy;
  if ((nEval > 0) && (nEval < min)) nEval = min;
} else {
  int min;
  if (!bCap) min = 0;
  else if (GetTime < 600000) min = 4000;
  else if (GetTime < 120000) min = 6000;
  else if (GetTime < 180000) min = 10000;
  else min = 12000;
	nEval += enemy * 3;
  if ((nEval > 0) && (nEval < min)) nEval = min;
}

return nEval;