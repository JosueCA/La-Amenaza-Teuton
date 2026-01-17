// int, int idPlayer, GAIKA g

int nODist = 50000;
int nPriority, nMul, nDiv;
int i;

// get dist to nearest tent
for (i = 0; i < MaxSetIdx; i += 1) {
  Settlement set; int dist; 
  set = IdxToSet(i); if (!set.IsTeutonTent) continue;
  dist = set.GetCentralBuilding.pos.Dist(g.Center);
  if (dist < nODist) nODist = dist;
}

nPriority = 100000 - 2 * nODist;

if (g.settlement.IsStronghold) { nMul = 4; nDiv = 3; }  // Boost priority for strongholds
else if (g.settlement.IsVillage) { nMul = 5; nDiv = 4; }
else if (g.settlement.IsValid) { nMul = 1; nDiv = 1; }
else if (g.Eval(AI_ALL, idPlayer, AI_ENEMY) > 0)  { nMul = 1; nDiv = 1; }
else  { nMul = 1; nDiv = 2; }

return nPriority * nMul / nDiv;

