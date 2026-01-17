// void, Settlement set

int        i;
int        AIPlayer;
Squad      squad;
bool       bHireHero, bMilUnits;
bool       bRush, bArenaRush, bGTRush;
int        nArmyBuilds = 0;
int        nFreezeArmyBuild;
bool       bAssUnderFire, bEnemies;
int        nAssUnderFire;
GAIKA      g;
int        own, ally, enemy;
bool       bNeedTraining;
int        train;
bool       bExitTraining;
int        nTrainLevel;
int        nTrainingStartTime;

g = set.GetGaika();
AIPlayer = set.player;
EnvWriteInt(set, "gSellFood", 0);
EnvWriteInt(set, "nArmyBuilds", nArmyBuilds);

if (rand(100)<AIVar(AIPlayer, AIV_TrainingRush))
	EnvWriteInt(AIPlayer, "NeedTraining", 1);

bNeedTraining = EnvReadInt(AIPlayer, "NeedTraining")==1;

//if (set.IsRomeStronghold) SetAIVar(AIPlayer, AIV_ArenaRush, 100); //!!!

if (AIVar(AIPlayer, AIV_ArenaHire) != 0) 
	{
		EnvWriteInt(set, "ArenaRush", (rand(100) < AIVar(AIPlayer, AIV_ArenaRush)));
		if (AIVar(AIPlayer, AIV_PurposeArenaRush)!=0)
			if (SettlementCount(set.GetCentralBuilding.pos, 6500, "TTent")>=3)
				EnvWriteInt(set, "ArenaRush", 1);
	}
else EnvWriteInt(set, "ArenaRush", 0);

if (AIVar(AIPlayer, AIV_GTRush) != 0) if (set.IsGaulStronghold) if (EnvReadInt(set, "ArenaRush") == 0) 
	{
		EnvWriteInt(set, "GTRush", (rand(100) < AIVar(AIPlayer, AIV_GTRush)));
		if (SettlementCount(set.GetCentralBuilding.pos, 6500, "BaseVillage")<=2)
			EnvWriteInt(set, "GTRush", 1);
	}

if (AIVar(AIPlayer, AIV_LogRush) != 0) {
  if (EnvReadInt(set, "ArenaRush") != 0)
    pr("Player " + AIPlayer + " will start with arena rush!");
  if (EnvReadInt(set, "GTRush") != 0)
    pr("Player " + AIPlayer + " will start with GT rush!");
}

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

  bArenaRush = (EnvReadInt(set, "ArenaRush") != 0);
  bGTRush = (EnvReadInt(set, "GTRush") != 0);
  bRush = bArenaRush || bGTRush;
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
  // Simplified: always build military units (ignore limits)
  bMilUnits = true;
  if (AIVar(AIPlayer, AIV_BuildArmy) == 0) bMilUnits = false;
  // Removed AIV_MaxMilUnits and AIV_MaxMilEval limits
  // else {
  //   i = AIVar(AIPlayer, AIV_MaxMilUnits);
  //   if (i < 0) ;
  //   else if (i == 0) bMilUnits = false;
  //   else if (MilUnits(AIPlayer) >= i) bMilUnits = false;
  //
  //   if (bMilUnits) {
  //     i = AIVar(AIPlayer, AIV_MaxMilEval);
  //     if (i < 0) ;
  //     else if (i == 0) bMilUnits = false;
  //     else if (MilEval(AIPlayer) >= i) bMilUnits = false;
  //   }
  // }
// hero support
  bHireHero = false;
  if (bMilUnits && !bRush) {
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
        if (MilUnits(AIPlayer) >= 15) if (set.CanResearch(cmd)) {
          if (AIVar(AIPlayer, AIV_LogHeroes) != 0) pr("Player " + AIPlayer + " hires new hero");
          set.SpentGoldOnArmy(gold);
          set.Research(cmd);
        }
        bHireHero = false;
      }
    }
  }

// build army
  // Simplified: removed bRush restriction, always try to build
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
	if (AIVar(AIPlayer, AIV_UpgradeBarracks) != 0) if (!bAssUnderFire && !bRush && (set.gold >= 500))
		set.UpgradeBestBarrack(8);

// food donate
  i = AIVar(AIPlayer, AIV_DonateFood);
  if (i > 0) if (!bGTRush)
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
	if (i > 0) if (!bAssUnderFire) if (bArenaRush || MilUnits(AIPlayer) >= i)
		set.AIRun("ESH_ArenaUnits.vs");

	// tavern research (gaul and roman)
	i = AIVar(AIPlayer, AIV_Training_Tavern);
	if (i > 0) if (MilUnits(AIPlayer) >= i) {
		if (set.IsGaulStronghold) {
			set.AIRun("ESH_GTavern.vs");
		} else if (set.IsRomeStronghold) {
			set.AIRun("ESH_RTavern.vs");
		}
	}

	if (!bNeedTraining) // Don't spend money on druids if we need training
		{
		// druids
			i = AIVar(AIPlayer, AIV_Druids);
			if (i > 0) if (bMilUnits) if (!bAssUnderFire) if (!bRush) if (MilUnits(AIPlayer) >= 20)
				set.AIRun("ESH_Druids.vs");

		// combat magic (lowest priority)
			i = AIVar(AIPlayer, AIV_CombatMagic);
			if (i > 0) if (!bAssUnderFire) if (!bRush) if (MilUnits(AIPlayer) >= AIVar(AIPlayer, AIV_Training_CombatMagic))
				set.AIRun("ESH_CombatMagic.vs");
		}
	else
		{
			// Check if we should exit NeedTraining mode
			bExitTraining = false;
			nTrainLevel = EnvReadInt(AIPlayer, "maxtrainlevel");
			nTrainingStartTime = EnvReadInt(AIPlayer, "TrainingStartTime");

			// Record when training mode started (for timeout)
			if (nTrainingStartTime == 0) {
				EnvWriteInt(AIPlayer, "TrainingStartTime", GetTime());
				nTrainingStartTime = GetTime();
			}

			if (set.IsRomeStronghold()) {
				// Original condition: reached max training level 8
				if (nTrainLevel >= 8) bExitTraining = true;
				// New condition 1: Have at least training level 4 AND 30+ military units
				if (nTrainLevel >= 4) if (MilUnits(AIPlayer) >= 30) bExitTraining = true;
				// New condition 2: Timeout after 10 minutes (600000ms) with at least some training
				if (nTrainLevel >= 4) if (GetTime() > nTrainingStartTime + 600000) bExitTraining = true;
				// New condition 3: Timeout after 15 minutes regardless of training level
				if (GetTime() > nTrainingStartTime + 900000) bExitTraining = true;
			} else {
				// Original condition: reached max training level 12
				if (nTrainLevel >= 12) bExitTraining = true;
				// New condition 1: Have at least training level 8 AND 30+ military units
				if (nTrainLevel >= 8) if (MilUnits(AIPlayer) >= 30) bExitTraining = true;
				// New condition 2: Timeout after 10 minutes with at least some training
				if (nTrainLevel >= 4) if (GetTime() > nTrainingStartTime + 600000) bExitTraining = true;
				// New condition 3: Timeout after 15 minutes regardless
				if (GetTime() > nTrainingStartTime + 900000) bExitTraining = true;
			}

			if (bExitTraining) {
				EnvWriteInt(AIPlayer, "NeedTraining", 2);
				bNeedTraining = false;
			}

			set.AIRun("ESH_ResearchTraining.vs");
		}

// check if we need overall training
	if (train > 0) if (rand(30)==3)
		if (EnvReadInt(AIPlayer, "NeedTraining")==0)
			if (NeedTraining(AIPlayer))
				{ EnvWriteInt(AIPlayer, "NeedTraining", 1); bNeedTraining = true; }

// sleep  
	Sleep(AIVar(AIPlayer, AIV_Sleep_ES));
}