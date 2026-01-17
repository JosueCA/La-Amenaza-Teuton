// void, Settlement set
// Gaul Tavern research script

int AIPlayer;
str strTech;
int lastTavernCheck;

AIPlayer = set.player;

// Only check every 1 minute (60000ms)
lastTavernCheck = EnvReadInt(set, "lastTavernCheck");
if (GetTime() < lastTavernCheck + 60000) return;
EnvWriteInt(set, "lastTavernCheck", GetTime());

// Free Beer (unlocks other tavern upgrades)
strTech = "Free Beer";
if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
  EnvWriteString(set, "strTech", strTech);
  set.AIRun("ESH_NeedTech.vs");
  return;
}

// Food Tax (requires Free Beer)
strTech = "Food Tax";
if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
  EnvWriteString(set, "strTech", strTech);
  set.AIRun("ESH_NeedTech.vs");
  return;
}

// Nordic trade routes (requires Free Beer)
strTech = "Nordic trade routes";
if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
  EnvWriteString(set, "strTech", strTech);
  set.AIRun("ESH_NeedTech.vs");
  return;
}

// Herb Amulets and Belts require Nordic trade routes
if (IsResearched(set, "Nordic trade routes")) {
  strTech = "Herb Amulets of Luck";
  if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
    EnvWriteString(set, "strTech", strTech);
    set.AIRun("ESH_NeedTech.vs");
    return;
  }

  strTech = "Belts of Might";
  if (!IsResearched(set, strTech)) if (!IsResearching(set, strTech)) {
    EnvWriteString(set, "strTech", strTech);
    set.AIRun("ESH_NeedTech.vs");
    return;
  }
}
