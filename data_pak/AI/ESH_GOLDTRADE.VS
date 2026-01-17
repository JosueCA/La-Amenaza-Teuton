// void, Settlement set

int AIPlayer;
GAIKA g, gSell;
int i, nOutposts, timeLimit;
bool bStartNewTrade;

AIPlayer = set.player;
nOutposts = EnvReadInt(AIPlayer, "GoldTradeOutposts");
timeLimit = EnvReadInt(AIPlayer, "GoldTradeTime");
if (timeLimit==0)
	{
		if (rand(3)!=1)
			timeLimit = 420000;
		else
			timeLimit = 1;
		EnvWriteInt(AIPlayer, "GoldTradeTime", timeLimit);
	}

if (nOutposts>=AIVar(AIPlayer, AIV_TradeGold) || EnvReadInt(AIPlayer, "GoldTradeStartInProgress")==1 || GetTime()<timeLimit)
  return;

g = set.GetGaika();

{
  int nBest = 0;
  for (i = 0; i < MaxSetIdx; i += 1) {
    int nDist, nODist, nADist, nEDist, nEval;
    Settlement s; s = IdxToSet(i);
    if (!s.IsOwn(AIPlayer)) continue;
    if (!s.IsRomeOutpost) continue;
    if (s.supplied.IsValid) continue;
    nDist = s.GetGaika.Center.Dist(g.Center);
    s.GetGaika.GetDistToPlayers(AIPlayer, nODist, nADist, nEDist);
    if (nEDist < 0) nEDist = 32000;
    nEval = nEDist - nDist;
    if (nEval > nBest) { 
      gSell = s.GetGaika; 
      nBest = nEval; 
    }
  }
  if (gSell != 0) { // new gold sell place
    Settlement sSell; sSell = gSell.settlement;
    sSell.RunEconomyScript(ES_OutpostSellGold);
		EnvWriteInt(AIPlayer, "GoldTradeTime", timeLimit + 300000 + rand(10)*60000);
    if (AIVar(AIPlayer, AIV_LogFoodSell) != 0) pr("Player " + AIPlayer + " will sell gold in GAIKA " + gSell.ID);
  }
}
