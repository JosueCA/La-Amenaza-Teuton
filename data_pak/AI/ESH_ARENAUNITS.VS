// void, Settlement set
// Arena units research and hiring script

int AIPlayer;
str strTech, class;
int max, i;
bool bUpgrade;

AIPlayer = set.player;

// First research: Gladiator Shows (Rome) / Fights (Gaul)
if (set.IsRomeStronghold) strTech = "Gladiator Shows"; else strTech = "Fights";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

// decide whether to try to upgrade hires
i = AIVar(AIPlayer, AIV_ArenaUpgradeHires);
if (i < 0) bUpgrade = true;
else if (i == 0) bUpgrade = false;
else if (i == 1) bUpgrade = true;
else bUpgrade = (EnvReadInt(set, "ArenaHired") != 0);

if (bUpgrade) {
  if (set.IsRomeStronghold) strTech = "Liberati guild"; else strTech = "Shrine of Thor";
  if (!IsResearched(set, strTech)) {
    EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
    if (i < 0) return; // upgraded units only
  }
}

// Training upgrades
if (set.IsRomeStronghold) strTech = "Rome Training 1"; else strTech = "Gaul Training 1";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

if (set.IsRomeStronghold) strTech = "Rome Training 2"; else strTech = "Gaul Training 2";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

if (!set.IsRomeStronghold) {
  strTech = "Gaul Training 3";
  if (!IsResearched(set, strTech)) {
    EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
    return;
  }
}

// Hire arena units
if (set.IsRomeStronghold) {
  strTech = "Hire Liberati";
  class = "RLiberatus";
  max = 20;
} else {
  strTech = "Hire Viking Lord";
  class = "GVikingLord";
  max = 4;
}

i = Count(AIPlayer, class);
if (i <= max) {
  int gold, food;
  if (!GetCmdCost(strTech, gold, food)) return;
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
} else {
  EnvWriteInt(set, "ArenaHired", 1);
}
