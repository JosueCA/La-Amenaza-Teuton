// void, Settlement set

int AIPlayer;
str strTech;
int lastCheck;

AIPlayer = set.player;

// Only check every 2 minutes (120000ms)
lastCheck = EnvReadInt(set, "lastCombatMagicCheck");
if (GetTime() < lastCheck + 120000) return;
EnvWriteInt(set, "lastCombatMagicCheck", GetTime());

// if (Count(AIPlayer, "RPriest") + Count(AIPlayer, "GDruid") < AIVar(AIPlayer, AIV_CombatMagic))
//  return;

if (set.IsRomeStronghold) strTech = "Altar of Jupiter"; else strTech = "Ritual chamber";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

if (set.IsRomeStronghold) strTech = "Wrath of Jupiter"; else strTech = "Mass heal";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

if (set.IsRomeStronghold) strTech = "Cloud of Plague"; else strTech = "Ghoul Summoning";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}
    
