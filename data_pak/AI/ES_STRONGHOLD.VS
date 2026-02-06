// void, Settlement set

int        i;
int        AIPlayer;
Squad      squad;
bool       bHireHero, bMilUnits;
int        nArmyBuilds = 0;
int        nFreezeArmyBuild;
bool       bAssUnderFire, bEnemies;
int        nAssUnderFire;
GAIKA      g;
int        own, ally, enemy;
int        train;
bool       bExitTraining;
int        nTrainLevel;
int        nTrainingStartTime;

g = set.GetGaika();
AIPlayer = set.player;
EnvWriteInt(set, "gSellFood", 0);
EnvWriteInt(set, "nArmyBuilds", nArmyBuilds);


while (set.player == AIPlayer) {
// Apply difficulty bonus gold and food
  i = AIVar(AIPlayer, AIV_GoldBonus);
  if (i > 0) set.SetGold(set.gold + i);
  i = AIVar(AIPlayer, AIV_FoodBonus);
  if (i > 0) set.SetFood(set.food + i);

// freeze army build counter
  nFreezeArmyBuild = EnvReadInt(set, "FreezeArmyBuild");
  if (nFreezeArmyBuild > 0) {
    nFreezeArmyBuild -= 1;
    EnvWriteInt(set, "FreezeArmyBuild", nFreezeArmyBuild);
    if (nFreezeArmyBuild == 0) if (AIVar(AIPlayer, AIV_LogFreezeArmy) != 0)
      pr("Player " + AIPlayer + " enables army build (gave up)");
  }

// check "ass under fire"
  g.Eval(AI_ALL, AIPlayer, own, ally, enemy);
  bEnemies = (enemy > 0);
  bAssUnderFire = (enemy > own + ally);
  if (bAssUnderFire) {
    nAssUnderFire = EnvReadInt(set, "AssUnderFire");
    nAssUnderFire += 1;
    EnvWriteInt(set, "AssUnderFire", nAssUnderFire);
    if (nAssUnderFire > 10)
      set.StopReserving;
    if (AIVar(AIPlayer, AIV_LogAUF) != 0)
      if (nAssUnderFire == 1) pr("Player " + AIPlayer + " ass under fire!");
      else if (nAssUnderFire == 11) pr("Player " + AIPlayer + " ASS STILL UNDER FIRE!");
  } else {
    if (AIVar(AIPlayer, AIV_LogAUF) != 0) if (EnvReadInt(set, "AssUnderFire") != 0)
      pr("Player " + AIPlayer + " ass no longer under fire");
    EnvWriteInt(set, "AssUnderFire", 0);
  }

// check whether to build military units
  bMilUnits = true;
  if (AIVar(AIPlayer, AIV_BuildArmy) == 0) {
    bMilUnits = false;
  } else {
    i = AIVar(AIPlayer, AIV_MaxMilUnits);
    if (i < 0) ;
    else if (i == 0) bMilUnits = false;
    else if (MilUnits(AIPlayer) >= i) bMilUnits = false;

    if (set.food < 200) bMilUnits = false;

    if (bMilUnits) {
      i = AIVar(AIPlayer, AIV_MaxMilEval);
      if (i < 0) ;
      else if (i == 0) bMilUnits = false;
      else if (MilEval(AIPlayer) >= i) bMilUnits = false;
    }
  }
// hero support
  bHireHero = false;
  if (bMilUnits) {
    SquadList  sl;
	  bHireHero = true;
	  g.GetSquads( sl, AI_STAYING + AI_COMING, AIPlayer, AI_OWN );
	  while (!sl.EOL) {
		  squad = sl.Cur;	sl.Next;
		  if (squad.Leader.AsHero.IsValid()) if (squad.Size < 41)
		    {	bHireHero = false;	break; }
	  }
    if (bHireHero) { 
      int gold, food;
      str cmd; if (set.IsRomeStronghold) cmd = "hireheroR"; else cmd = "hireheroG";
      if (GetCmdCost(cmd, gold, food)) if (set.CanAfford(cmd)){
        if (set.CanResearch(cmd)) {
          if (AIVar(AIPlayer, AIV_LogHeroes) != 0) pr("Player " + AIPlayer + " hires new hero");
          set.SpentGoldOnArmy(gold);
          set.Research(cmd);
        }
        bHireHero = false;
      }
    }
  }

// build army
  if (bMilUnits) if (!bHireHero) {
    Barrack    brk;
    str cmd;
    int nCount; EnvReadInt(set, "nBuildCount");
    if (nCount >= 0) { // < 0 means retry with the last
      EnvWriteInt(set, "nBuildCount", 0);
      set.AIRun("ESH_BuildArmy.vs");
      nCount = EnvReadInt(set, "nBuildCount");
    } else nCount = 1;
    brk = set.BestBarrack(10);
    if (!brk.IsValid) nCount = 0;
    if (nCount > 0) cmd = UTrainCmd(EnvReadInt(set, "nBuildType"), set.IsRomeStronghold);

    // Check FreezeArmyBuild to allow saving gold for research
    if (nCount > 0) if (!bAssUnderFire)
      if (!set.CanAfford(cmd, nCount)) { nCount = 0; EnvWriteInt(set, "nBuildCount", -1); }
      else if (nFreezeArmyBuild != 0)
        nCount = 0;

    if (nCount > 0) {
      int   gold, food;
      point ptDummy;
      Obj   objDummy;

      nArmyBuilds += 1; EnvWriteInt(set, "nArmyBuilds", nArmyBuilds);
      if (GetCmdCost(cmd, gold, food)) 
        set.SpentGoldOnArmy(gold * nCount);

      //pr("Player " + AIPlayer + ": (" + nArmyBuilds + ") " + cmd + "(" + nCount + ")");
      for (i = 0; i < nCount; i += 1) brk.ExecCmd( cmd, ptDummy, objDummy, false );
    }
  }

// repair
	if (!bEnemies)
		set.RepairAll;

// barrack upgrade
	if (AIVar(AIPlayer, AIV_UpgradeBarracks) != 0) if (!bAssUnderFire && (set.gold >= 500))
		set.UpgradeBestBarrack(8);

// food donate
  i = AIVar(AIPlayer, AIV_DonateFood);
    set.AIRun("ESH_DonateFood.vs");

// food trade
  i = AIVar(AIPlayer, AIV_TradeFood);
  if (i > 0) if (set.food >= i)
    set.AIRun("ESH_FoodTrade.vs");

// gold trade
  i = AIVar(AIPlayer, AIV_TradeGold);
  if (i > 0)
    set.AIRun("ESH_GoldTrade.vs");

// training
	train = AIVar(AIPlayer, AIV_Training);
	if (train > 0) if (!bAssUnderFire) if (MilUnits(AIPlayer) >= train)
		set.AIRun("ESH_ResearchTraining.vs");

	// arena units and tavern research - always run regardless of training mode
	i = AIVar(AIPlayer, AIV_ArenaHire);
	if (i > 0) if (!bAssUnderFire) if (MilUnits(AIPlayer) >= i)
		set.AIRun("ESH_ArenaUnitsv2.vs");

	// tavern research (gaul and roman)
	i = AIVar(AIPlayer, AIV_Training_Tavern);
	if (i > 0) if (MilUnits(AIPlayer) >= i) {
		if (set.IsGaulStronghold) {
			set.AIRun("ESH_GTavern.vs");
		} else if (set.IsRomeStronghold) {
			set.AIRun("ESH_RTavern.vs");
		}
	}
  
// FIX: Both scripts use 'research', they fight with each other for research
if(rand(6)==1) {
  // combat magic (lowest priority)
  i = AIVar(AIPlayer, AIV_CombatMagic);
  if (i > 0) if (MilUnits(AIPlayer) >= AIVar(AIPlayer, AIV_Training_CombatMagic))
    set.AIRun("ESH_CombatMagic.vs");
} else {
  // druids
  i = AIVar(AIPlayer, AIV_Druids);
  if (i > 0) if (bMilUnits) if (MilUnits(AIPlayer) >= AIVar(AIPlayer, AIV_Training_CombatMagic))
    set.AIRun("ESH_Druids.vs");
}

  
// sleep  
	Sleep(AIVar(AIPlayer, AIV_Sleep_ES));
}