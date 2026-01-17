// void, Settlement set

int AIPlayer;
str strTech;

AIPlayer = set.player;

if (set.IsRomeStronghold) strTech = "Gladiator Shows"; else strTech = "Fights";
if (!IsResearched(set, strTech)) {
  EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
  return;
}

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

if (!set.IsRomeStronghold)  {
  strTech = "Gaul Training 3";
  if (!IsResearched(set, strTech)) {
    EnvWriteString(set, "strTech", strTech); set.AIRun("ESH_NeedTech.vs");
    return;
  }
}
