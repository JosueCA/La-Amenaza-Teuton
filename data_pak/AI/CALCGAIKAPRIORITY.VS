// int, int idPlayer, GAIKA g

int nODist, nADist, nEDist;
int nPriority, nMul, nDiv;
bool bExplored;
int nEnemyInStronghold;

// CRITICAL: Own stronghold under attack = MAXIMUM PRIORITY
if (g.settlement.IsStronghold) if (g.settlement.IsOwn(idPlayer)) {
	nEnemyInStronghold = g.Eval(AI_STAYING + AI_COMING, idPlayer, AI_ENEMY);
	if (nEnemyInStronghold > 0) {
		// Absolute maximum priority - nothing is more important than defending home
		return 99999; // enough??
	}
}

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
  {
    // Boosted to prioritize over RECLAIM, but reduced if very far
    if (nODist < 8000) { nMul = 6; nDiv = 1; }      // Close: high priority (9x with enemy bonus)
    else if (nODist < 12000) { nMul = 4; nDiv = 1; } // Medium: moderate priority
    else { nMul = 2; nDiv = 1; }                     // Far: reduced priority
  }
else if (g.settlement.IsVillage)
	{ nMul = 5; nDiv = 4; }
else if (g.settlement.IsTeutonTent)
	{
		// BOOST PRIORITY for TeutonTent that don't belong to the player
		if (!g.settlement.IsOwn(idPlayer))
		{
			// Enemy or independent tents = higher priority
			if (g.settlement.IsEnemy(idPlayer))
				{ nMul = 3; nDiv = 1; } // High priority for enemy tents
			else if (g.settlement.IsIndependent)
				{ nMul = 5; nDiv = 2; } // Good priority for independent tents
			else
				{ nMul = 2; nDiv = 1; } // Default boost for non-owned tents

			// Extra boost if close to our stronghold
			if (nODist < 6000)
				{ nMul = nMul * 2; }
		}
		else // Own tent - use original logic
		{
			// Don't attack tents early in the game - wait for stronger army
			if (GetTime < 120000) { nMul = 1; nDiv = 10; } // Very low priority in first 2 minutes
			else if (GetTime < 30000) if (MilEval(idPlayer) < 3000) { nMul = 1; nDiv = 5; } // Low priority if weak army
			// Don't fight for tents that are too far
			else if (nODist > nEDist)
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
				}
		}
	}
else if (g.settlement.IsOutpost || g.settlement.IsShipyard)
	{
		if (g.settlement.IsRomeOutpost && AIVar(idPlayer, AIV_TradeGold)>0 && g.settlement.IsEnemy(idPlayer))
			{ nMul = 4; nDiv = 3; }
		else
			{ nMul = 1; nDiv = 1; }
	}
else 
	{ nMul = 1; nDiv = 3; }

bExplored = g.Explored(idPlayer);

// Boost enemy settlements near the stronghold, and such far from the stronghold :)
if (g.settlement.IsEnemy(idPlayer))
	if (nODist<5000)
		{ nMul = nMul * 3; nDiv = nDiv * 2; }
	else
		{ nMul = nMul * 6; nDiv = nDiv * 5; }

// --- RECLAIM SYSTEM: Boost priority for nearby uncaptured villages/outposts ---
// If a village or outpost is close to our stronghold but NOT ours, prioritize capturing it
// CONFIG: Edit these values directly - AIV_ custom variables not supported by engine
// nDist1=6000 (x4), nDist2=10000 (x2), nDist3=15000 (x1.5)
if (!g.settlement.IsOwn(idPlayer)) {
	if (g.settlement.IsVillage || g.settlement.IsOutpost) {
		if (nODist < 6000) {
			nMul = nMul * 4;
			//pr("RECLAIM[" + idPlayer + "] GAIKA " + g.ID + " dist=" + nODist + " -> x4");
		}
		else if (nODist < 10000) {
			nMul = nMul * 2;
			//pr("RECLAIM[" + idPlayer + "] GAIKA " + g.ID + " dist=" + nODist + " -> x2");
		}
		else if (nODist < 15000) {
			nMul = nMul * 3; nDiv = nDiv * 2;
			//pr("RECLAIM[" + idPlayer + "] GAIKA " + g.ID + " dist=" + nODist + " -> x1.5");
		}
	}
}

if (g.Eval(AI_COMING + AI_STAYING, idPlayer, AI_OWN + AI_ALLY) > 0) // taking action here
  if (bExplored)
    { nPriority += 10000; } // support, man :)
  else
    { nMul = nMul * 4; nDiv = nDiv * 5; } // (someone) already taken care of an unexplored GAIKA, screw it :)

// Bonus/penalty for own settlements
if (g.settlement.IsOwn(idPlayer))
	{
		if (g.settlement.IsStronghold)
			{ nMul = nMul * 4; nDiv = nDiv * 3; }
		else if (g.settlement.supplied.IsValid)
			{ nMul = nMul * 4; nDiv = nDiv * 3; }
		else 
			{
				int enemy, own, ally;
				g.EvalNeighbors(AI_STAYING, idPlayer, own, ally, enemy, true);
				enemy += g.Eval(AI_COMING + AI_STAYING, idPlayer, AI_ENEMY);
				
				// Decrease the priority of unendangered friendly GAIKA
				if (enemy<2000) 
					{ nDiv = nDiv * 3; }
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

