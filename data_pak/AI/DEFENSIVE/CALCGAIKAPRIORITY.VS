// int, int idPlayer, GAIKA g

int nODist, nADist, nEDist;
int nPriority, nMul, nDiv;
bool bExplored;

g.GetDistToPlayers(idPlayer, nODist, nADist, nEDist);
nADist = g.GetDistToArmies(idPlayer); // Discard previous value
nPriority = 450000 - 2 * (nODist + 2 * nADist);
if (nODist>8000 && nEDist>7000 && nADist>6000)
	nPriority = nPriority*2/3;
if (nODist>11000 && nEDist>9000 && nADist>8000)
	nPriority = nPriority*2/3;
if (nPriority<=0)
	nPriority = 1; // Just in case

if (g.settlement.IsStronghold)
  { nMul = 4; nDiv = 3; }
else if (g.settlement.IsVillage)
	{ nMul = 5; nDiv = 4; }
else if (g.settlement.IsTeutonTent)
	{
		// Don't fight for tents that are too far
		if (nODist > nEDist)
			{
				nMul = 1; nDiv = 1;
				if (g.settlement.IsIndependent)
					nDiv += 1;
			}
		if (nMul == 0)
			{
				Settlement s;
				s = NearestStronghold(g.Center, idPlayer);
				nMul = 5; nDiv = 4;
				if (s.IsValid) if (EnvReadInt(s, "ArenaRush")) if (g.Explored(idPlayer)) // Making arena rush - boost tent priority
					{ nMul = 2; nDiv = 1; }
			}
	}
else if (g.settlement.IsOutpost || g.settlement.IsShipyard)
	{ nMul = 1; nDiv = 1; }
else 
	{ nMul = 1; nDiv = 3; }

bExplored = g.Explored(idPlayer);

// Boost enemy settlements near the stronghold, and such far from the stronghold :)
if (g.settlement.IsEnemy(idPlayer))
	if (nODist<5000) 
		{ nMul = nMul * 3; nDiv = nDiv * 2; }
	else
		{ nMul = nMul * 6; nDiv = nDiv * 5; }

if (g.Eval(AI_COMING + AI_STAYING, idPlayer, AI_OWN + AI_ALLY) > 0) // taking action here
  if (bExplored)
    { nPriority += 3000; } // support, man :)
  else
    { nMul = nMul * 4; nDiv = nDiv * 5; } // (someone) already taken care of an unexplored GAIKA, screw it :)

// Bonus/penalty for own settlements
if (g.settlement.IsOwn(idPlayer))
	{
		if (g.settlement.IsStronghold)
			{ nMul = nMul * 4; nDiv = nDiv * 3; }
		else if (g.settlement.supplied.IsValid)
			{ nMul = nMul * 5; nDiv = nDiv * 4; }
		else 
			{
				int enemy, own, ally;
				g.EvalNeighbors(AI_STAYING, idPlayer, own, ally, enemy, true);
				enemy += g.Eval(AI_COMING + AI_STAYING, idPlayer, AI_ENEMY);
				
				// Decrease the priority of unendangered friendly GAIKA
				if (enemy<1000) 
					{ nDiv = nDiv * 3; }
				else
					{ nMul = nMul * 3; }
			}
	}

if (g.settlement.IsIndependent) if (nMul >= nDiv) // multiply bonus for independent / rescue
  { nMul = nMul * 3; nDiv = nDiv * 2; }

if (bExplored)
  nPriority = nPriority * nMul / nDiv;
else {
  if (AIVar(idPlayer, AIV_LuckyExplore) != 0) nPriority = nPriority * nMul / nDiv;
  nPriority = nPriority * 3 / 2; // priority bonus for unexplored GAIKA
}

return nPriority+1;

