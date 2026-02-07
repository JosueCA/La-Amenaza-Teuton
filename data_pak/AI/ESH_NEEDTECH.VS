// void, Settlement set
// Simplified version: always research, add gold if needed

int AIPlayer;
str strTech;
int gold, food;
bool bRefuse = false;

AIPlayer = set.player;
strTech = EnvReadString(set, "strTech");

// Check if already researched
if (IsResearched(set, strTech)) {
  EnvWriteInt(set, "FreezeArmyBuild", 0);
  return;
}

// Get research cost
if (!GetCmdCost(strTech, gold, food)) {
  EnvWriteInt(set, "FreezeArmyBuild", 0);
  return;
}

// Handle Gaul Woman Warrior prerequisite
if (strTech == "Gaul Woman Warrior") if (!IsResearched(set, "Steel Weapons")) {
  if (GetCmdCost("Steel Weapons", gold, food))
    strTech = "Steel Weapons";
  else GetCmdCost(strTech, gold, food);
}

// Check if can research (building requirements, etc.)
if (!set.CanResearch(strTech)) return;

// Refuse certain tech combinations
if ((strTech == "Altar of Jupiter") || (strTech == "Ritual chamber")) {
  if (IsResearched(set, "Gladiator Shows"))
    if (!IsResearched(set, "Rome Training 1")) if (!IsResearched(set, "Liberati guild"))
      bRefuse = true;
  if (!bRefuse) if (IsResearched(set, "Fights"))
    if (!IsResearched(set, "Gaul Training 1")) if (!IsResearched(set, "Shrine of Thor"))
      bRefuse = true;
}
if (!bRefuse) if ((strTech == "Gladiator Shows") || (strTech == "Fights")) {
  if (IsResearched(set, "Altar of Jupiter")) if (!IsResearched(set, "Cloud of Plague"))
    bRefuse = true;
  if (!bRefuse) if (IsResearched(set, "Ritual chamber")) if (!IsResearched(set, "Ghoul Summoning"))
    bRefuse = true;
}
if (bRefuse) {
  EnvWriteInt(set, "FreezeArmyBuild", 0);
  return;
}

// Check if can afford research
if (!set.CanAfford(strTech)) {
  // Not enough gold, freeze army building to save gold
  EnvWriteInt(set, "FreezeArmyBuild", 20);
  if (AIVar(AIPlayer, AIV_LogResearch) != 0)
    pr("Player " + AIPlayer + " freezing army to save " + (gold - set.gold) + " gold for " + strTech);
  return;
}

// Has enough gold, unfreeze and research
EnvWriteInt(set, "FreezeArmyBuild", 0);

if (AIVar(AIPlayer, AIV_LogResearch) != 0)
  pr("Player " + AIPlayer + " is researching " + strTech);

set.Research(strTech);

