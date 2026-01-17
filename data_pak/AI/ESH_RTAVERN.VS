// void, Settlement set
// Roman Tavern research script

int AIPlayer;
str strTech;
int lastTavernCheck;

AIPlayer = set.player;

// Only check every 1 minute (60000ms)
lastTavernCheck = EnvReadInt(set, "lastRTavernCheck");
if (GetTime() < lastTavernCheck + 60000) return;
EnvWriteInt(set, "lastRTavernCheck", GetTime());

// Free Wine (unlocks other tavern upgrades)
strTech = "Free Wine";
if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
  EnvWriteString(set, "strTech", strTech);
  set.AIRun("ESH_NeedTech.vs");
  return;
}

// Import horses - upgrades scouts to level 12 (requires Free Wine)
strTech = "Import horses";
if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
  EnvWriteString(set, "strTech", strTech);
  set.AIRun("ESH_NeedTech.vs");
  return;
}

// Military Academy - heroes start at level 12 (requires Gladiator Shows)
if (IsResearched(set, "Gladiator Shows")) {
  strTech = "Military Academy";
  if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
    EnvWriteString(set, "strTech", strTech);
    set.AIRun("ESH_NeedTech.vs");
    return;
  }
}
