// void, Settlement set

int AIPlayer;
str strTech;
int lastCheck;


if (GetTime() < 120000) return;

AIPlayer = set.player;

if (set.IsRomeStronghold) strTech = "Altar of Jupiter"; else strTech = "Ritual chamber";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

if (set.IsRomeStronghold) strTech = "Wrath of Jupiter"; else strTech = "Mass Heal";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

if (set.IsRomeStronghold) strTech = "Cloud of Plague"; else strTech = "Ghoul Summoning";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

return;
