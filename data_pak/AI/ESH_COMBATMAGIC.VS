// void, Settlement set

int AIPlayer;
str strTech;
int lastCheck;

AIPlayer = set.player;

// Only check every 3 minutes (180000ms)
lastCheck = EnvReadInt(set, "lastCombatMagicCheck");
if (GetTime() < lastCheck + 180000) return;
EnvWriteInt(set, "lastCombatMagicCheck", GetTime());

// if (Count(AIPlayer, "RPriest") + Count(AIPlayer, "GDruid") < AIVar(AIPlayer, AIV_CombatMagic))
//  return;

if (set.IsRomeStronghold) strTech = "Altar of Jupiter"; else strTech = "Ritual chamber";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

if (set.IsRomeStronghold) strTech = "Cloud of Plague"; else strTech = "Ghoul Summoning";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}
    
