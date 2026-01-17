// void, Settlement set

int AIPlayer;
str cmd;
int percent, needed, avail, minDruids;

AIPlayer = set.player;
percent = AIVar(AIPlayer, AIV_Druids);
needed = percent * MilUnits(AIPlayer) / 100;

// Minimum 5 druids/priests for Stonehenge rituals
minDruids = 5;
if (needed < minDruids) {
	needed = minDruids;
}

avail = Count(AIPlayer, "RPriest") + Count(AIPlayer, "GDruid");
if (avail >= needed) return;

if (set.IsRomeStronghold) cmd = "trainRPriest"; else cmd = "trainGDruid";

if (set.CanResearch(cmd)) {
  int gold, food;
  if (GetCmdCost(cmd, gold, food)) {
    if (set.CanAfford(gold, food)) {
      set.Research(cmd);
      set.SpentGoldOnArmy(gold);
    }
  }
}
