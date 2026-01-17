// void, Settlement set

int AIPlayer;
str strTech;
int gold, food;
bool bReserving = false;
bool bRefuse = false;
bool bHire = false;
bool bExcessGold;

AIPlayer = set.player;
strTech = EnvReadString(set, "strTech");

if (IsResearched(set, strTech)) { EnvWriteInt(set, "FreezeArmyBuild", 0); return; }
if (!GetCmdCost(strTech, gold, food)) { EnvWriteInt(set, "FreezeArmyBuild", 0); return; }

if (strTech == "Gaul Woman Warrior") if (!IsResearched(set, "Steel Weapons")) {
  if (GetCmdCost("Steel Weapons", gold, food)) 
    strTech = "Steel Weapons";
  else GetCmdCost(strTech, gold, food);
}

if (!set.CanResearch(strTech)) return;

//if (EnvReadInt(AIPlayer, "NeedTraining")!=1) { // Don't refuse anything if we need training
	
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
		//if (AIVar(AIPlayer, AIV_LogResearch) != 0) pr("Player " + AIPlayer + " refuses to research " + strTech);
		//EnvWriteInt(set, "FreezeArmyBuild", 0); 
		return; 
	}

//}

if (strTech == "Hire Liberati") bHire = true;
else if (strTech == "Hire Viking Lord") bHire = true;

if (EnvReadInt(set, "Reserve" + (AIPlayer - 1)) > 0) {
  str strReserving; strReserving = EnvReadString(set, "ReserveFor" + (AIPlayer - 1));
  bReserving = (strReserving == strTech);
  if (bReserving) EnvWriteInt(set, "ReserveCounter", 50);
  else {
    int i; i = EnvReadInt(set, "ReserveCounter");
    if (i > 0) {
      i = i - 1; EnvWriteInt(set, "ReserveCounter", i);
      if (i == 0) {
        set.StopReserving;
        if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0)
          pr("Player " + AIPlayer + " stops reserving for " + (EnvReadString(set, "ReserveFor" + (AIPlayer - 1))) + " (gave up)");
      } else if (!bHire) {
        //if (AIVar(AIPlayer, AIV_LogResearch) != 0) pr("Player " + AIPlayer + " refuses to research " + strTech);
        return;
      }
    }
  }
} else if (!bHire) if (AIVar(AIPlayer, AIV_TechReserve) > 0) if (gold >= AIVar(AIPlayer, AIV_TechReserve)) {
  bReserving = set.ReserveFor(strTech, AIVar(AIPlayer, AIV_TechBudget));
  if (bReserving) {
    if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0)
      pr("Player " + AIPlayer + " starts reserving for " + strTech);
    EnvWriteInt(set, "ReserveCounter", 100);
  }
}

// Check tech budget
bExcessGold = set.gold >= AIVar(AIPlayer, AIV_ExcessGold);
if (rand(10)==1) bExcessGold = false;
if (!bHire) if (!bExcessGold) if (!set.CheckTechBudget(strTech, AIVar(AIPlayer, AIV_TechBudget))) return;

if (!set.CanAfford(strTech)) { 
  if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") == 0)
    pr("Player " + AIPlayer + " freezes army build, saving for " + strTech);
  EnvWriteInt(set, "FreezeArmyBuild", 10); 
  return; 
}

if (AIVar(AIPlayer, AIV_LogResearch) != 0) 
  if (bHire)
    if (strTech == "Hire Liberati") pr("Player " + AIPlayer + " hires liberati");
    else pr("Player " + AIPlayer + " hires thoric");
  else pr("Player " + AIPlayer + " is researching " + strTech); 

if (bHire) set.SpentGoldOnArmy(gold);
else if (!bExcessGold) set.SpentGoldOnTech(gold);

if (!bHire) if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) if (EnvReadInt(set, "FreezeArmyBuild") != 0)
  pr("Player " + AIPlayer + " enables army build, researching " + strTech);
EnvWriteInt(set, "FreezeArmyBuild", 0);

if (bReserving) {
  if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0) 
    pr("Player " + AIPlayer + " stops reserving for " + strTech + " (researching)");
  set.StopReserving;
  EnvWriteInt(set, "ReserveCounter", 0);
}

set.Research(strTech); 

