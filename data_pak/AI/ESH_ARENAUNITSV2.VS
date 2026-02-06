// void, Settlement set
// Arena units research and hiring script - DIRECT VERSION (no ESH_NeedTech dependency)

int AIPlayer;
str strTech, class;
int gold, food, max, i, techReserve;
bool bUpgrade;
bool bExcessGold;

AIPlayer = set.player;

if (set.gold < AIVar(AIPlayer, AIV_ExcessGold)) {
  EnvWriteInt(set, "FreezeArmyBuild", 0);
  return;
}

if (set.IsRomeStronghold) strTech = "Gladiator Shows"; else strTech = "Fights";
if (!IsResearched(set, strTech)) {
  if (!GetCmdCost(strTech, gold, food)) { EnvWriteInt(set, "FreezeArmyBuild", 0); return; }

  // Check if can afford
  if (!set.CanAfford(strTech)) {
    if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") == 0)
      pr("Player " + AIPlayer + " freezes army build, saving for " + strTech);
    EnvWriteInt(set, "FreezeArmyBuild", 20);
    return;
  }

  // Research it
  if (AIVar(AIPlayer, AIV_LogResearch) != 0)
    pr("Player " + AIPlayer + " is researching " + strTech);

  bExcessGold = set.gold >= AIVar(AIPlayer, AIV_ExcessGold);
  if (!bExcessGold) set.SpentGoldOnTech(gold);

  if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") != 0)
    pr("Player " + AIPlayer + " enables army build, researching " + strTech);
  EnvWriteInt(set, "FreezeArmyBuild", 0);

  set.Research(strTech);
  return;
}

i = AIVar(AIPlayer, AIV_ArenaUpgradeHires);
if (i < 0) bUpgrade = true;
else if (i == 0) bUpgrade = false;
else if (i == 1) bUpgrade = true;
else bUpgrade = (EnvReadInt(set, "ArenaHired") != 0);

if (bUpgrade) {
  if (set.IsRomeStronghold) strTech = "Liberati guild"; else strTech = "Shrine of Thor";
  if (!IsResearched(set, strTech)) {
    if (!GetCmdCost(strTech, gold, food)) { EnvWriteInt(set, "FreezeArmyBuild", 0); return; }

    // Check if can afford
    if (!set.CanAfford(strTech)) {
      if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") == 0)
        pr("Player " + AIPlayer + " freezes army build, saving for " + strTech);
      EnvWriteInt(set, "FreezeArmyBuild", 20);
      return;
    }

    // Research it
    if (AIVar(AIPlayer, AIV_LogResearch) != 0)
      pr("Player " + AIPlayer + " is researching " + strTech);

    bExcessGold = set.gold >= AIVar(AIPlayer, AIV_ExcessGold);
    if (!bExcessGold) set.SpentGoldOnTech(gold);

    if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") != 0)
      pr("Player " + AIPlayer + " enables army build, researching " + strTech);
    EnvWriteInt(set, "FreezeArmyBuild", 0);

    set.Research(strTech);
    if (i < 0) return; // upgraded units only
    return;
  }
}


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
  if (!GetCmdCost(strTech, gold, food)) return;

  // Check if can afford
  if (!set.CanAfford(strTech)) {
    if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") == 0)
      pr("Player " + AIPlayer + " freezes army build, saving for " + strTech);
    EnvWriteInt(set, "FreezeArmyBuild", 20);
    return;
  }

  // Check if we can keep tech reserve after hiring
  techReserve = AIVar(AIPlayer, AIV_TechReserve);
  if (techReserve > 0) {
    if (set.gold - gold < techReserve) {
      // Not enough gold to hire and keep reserve for research
      if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0)
        pr("Player " + AIPlayer + " skips hiring " + strTech + " to keep tech reserve");
      return;
    }
  }

  // Hire unit
  if (AIVar(AIPlayer, AIV_LogResearch) != 0) {
    if (strTech == "Hire Liberati") pr("Player " + AIPlayer + " hires liberati");
    else pr("Player " + AIPlayer + " hires thoric");
  }

  set.SpentGoldOnArmy(gold);

  if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") != 0)
    pr("Player " + AIPlayer + " enables army build, hiring " + strTech);
  EnvWriteInt(set, "FreezeArmyBuild", 0);

  set.Research(strTech);
} else {
  EnvWriteInt(set, "ArenaHired", 1);
}
