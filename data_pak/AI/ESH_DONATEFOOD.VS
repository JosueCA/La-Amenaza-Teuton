// void, Settlement set

int AIPlayer;
str cmd;

AIPlayer = set.player;

if (set.population <= set.max_population) {
  if (set.IsRomeStronghold) cmd = "RAddPop"; else cmd = "GAddPop";
  if (set.CanResearch(cmd)) {
    int gold, food;
    if (GetCmdCost(cmd, gold, food)) {
      if (set.CanAfford(gold, food + AIVar(AIPlayer, AIV_DonateFood))) {
        set.Research(cmd);
        return;
      }
    }
  }
}

if (set.gold >= AIVar(AIPlayer, AIV_BuyFood)) if (set.IsRomeStronghold)
{
  cmd = "buyfoodforgold";
  if ((set.food < 100) || (set.population < set.max_population * 8 / 10)) if (rand(3)==2) {
    int gold, food;
    if (GetCmdCost(cmd, gold, food)) if (set.CanAfford(gold, food)) 
			set.Research(cmd);
  }
}


