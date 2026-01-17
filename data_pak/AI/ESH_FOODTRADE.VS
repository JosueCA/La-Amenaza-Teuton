// void, Settlement set

GAIKA gSellFood;
int AIPlayer;
GAIKA g;
int i;

gSellFood = GetGAIKA(EnvReadInt(set, "gSellFood"));
AIPlayer = set.player;
g = set.GetGaika();

if (!gSellFood.settlement.IsOwn(AIPlayer)) gSellFood = 0;
else if (!gSellFood.settlement.supplied.IsValid) gSellFood = 0;

if (gSellFood == 0) { // find best food sell GAIKA
  int nBest = 0;
  for (i = 0; i < MaxSetIdx; i += 1) {
    int nDist, nODist, nADist, nEDist, nEval;
    Settlement s; s = IdxToSet(i);
    if (!s.IsOwn(AIPlayer)) continue;
    if (!s.IsGaulOutpost) continue;
    if (s.supplied.IsValid) /*if (s.supplied != set)*/ continue;
    nDist = s.GetGaika.Center.Dist(g.Center);
    s.GetGaika.GetDistToPlayers(AIPlayer, nODist, nADist, nEDist);
    if (nEDist < 0) nEDist = 32000;
    nEval = nEDist - nDist;
    if (nEval > nBest) { 
      gSellFood = s.GetGaika; 
      nBest = nEval; 
    }
  }
  if (gSellFood != 0) { // new food sell place
    Settlement sSell; sSell = gSellFood.settlement;
    EnvWriteInt(set, "gSellFood", gSellFood.ID);
    sSell.StartSupplyFood(set); // !!! mark as food selling for us
    if (AIVar(AIPlayer, AIV_LogFoodSell) != 0) pr("Player " + AIPlayer + " will sell food in GAIKA " + gSellFood.ID);
  }
}

if (gSellFood != 0) { // send food to sell
  Settlement sSell; sSell = gSellFood.settlement;
  if (sSell.food < 2000) {
    Wagon wagon; wagon = set.CreateMuleFood(1000);
    if (wagon.IsValid) {
	    wagon.AddCommand(false, "unload", sSell.GetCentralBuilding);
	    wagon.KillCommand();
    }
  }
}
