// void, Settlement set

// WARNING: since the script language doesn't have arrays and has complete boolean evaluation,
//          the code in this script is ridiculously big and ugly :)


int AIPlayer;
str strTech, strCmd;
int nType;
int nCount;
int nArmyBuilds;
int nAssUnderFire;
bool bBuildArmy;
int  nLastResearched;
int  nLRCounter;
int  nLastBuilt;
int  nEnabled = 0;
int  nEarlyResearch;
int  nLastResearchTime;
bool bRome;
bool bNoArchers;
bool bNeedTraining;

int nDbg = 0;
int nRandSelect;
int nTryType;
int nInitialGold;
int nArmyDelay;
int iTechReserve;
int iTechBudget;
int iExcessThreshold;
int iAvailableGold;
int unitCost;
int unitFood;

AIPlayer = set.player;
nAssUnderFire = EnvReadInt(set, "nAssUnderFire");
nArmyBuilds = EnvReadInt(set, "nArmyBuilds");
nLastResearched = EnvReadInt(set, "nLastResearched");
nLRCounter = EnvReadInt(set, "nLRCounter");
nLastBuilt = EnvReadInt(set, "nLastBuilt");
nEarlyResearch = EnvReadInt(set, "nEarlyResearch");
nLastResearchTime = EnvReadInt(set, "nLastResearchTime");
bNeedTraining = EnvReadInt(AIPlayer, "NeedTraining")==1;
bRome = set.IsRomeStronghold;

// check AI vars to see which units are enabled
if (bRome) {
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRSwordsman), 0, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRArcher),    1, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRGladiator), 2, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRSpearman),  3, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRHorseman),  4, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxRPretorian), 5, bRome);
} else {
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGSwordsman), 0, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGArcher),    1, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGAxeman),    2, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGSpearman),  3, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGHorseman),  4, bRome);
  CheckUEnabled(nEnabled, AIPlayer, AIVar(AIPlayer, AIV_MaxGWFighter),  5, bRome);
}

// Save initial gold on first run (to adjust army build delay for low-gold starts)
if (EnvReadInt(set, "InitialGoldSaved") == 0) {
  EnvWriteInt(set, "InitialGold", set.gold);
  EnvWriteInt(set, "InitialGoldSaved", 1);
}

// Early exploration: recruit 3 basic units before researching technologies
if (EnvReadInt(set, "EarlyExploreDone") == 0) {
  if (MilUnits(AIPlayer) < 3) {
    nType = 0;
    if (UEnabled(nEnabled, nType)) {
      EnvWriteInt(set, "nBuildType", nType);
      EnvWriteInt(set, "nBuildCount", 5);
    }
  }
  EnvWriteInt(set, "EarlyExploreDone", 1);
  return;
}


// decide whether to build army at all
// Simplified: always build if we have barracks and minimum population
if (!set.BestBarrack(10).IsValid)
  bBuildArmy = false;
else if (set.population <= 5)
  bBuildArmy = false;
else if (EnvReadInt(set, "FreezeArmyBuild") > 0)
  bBuildArmy = false;
else
  bBuildArmy = true;

// === RANDOM RESEARCH: Pick randomly from pending techs ===
// Research is independent of army building freeze
if (MilUnits(AIPlayer) >= 2) {
  // Skip if all techs already researched
  if (EnvReadInt(set, "AllTechsResearched_" + AIPlayer) == 0) {
    int resType, pendingCount, randomChoice, currentPending, lastResearchTime, currentTime;
    str resTech;

    // Check if 60 seconds have passed since last research attempt
    lastResearchTime = EnvReadInt(set, "LastResearchTime_" + AIPlayer);
    currentTime = GetTime();

    if (currentTime - lastResearchTime >= 120000) {
      // Count pending techs
      pendingCount = 0;
      for (resType = 1; resType < 6; resType += 1) {
        if (!UEnabled(nEnabled, resType)) continue;
        resTech = UTech(resType, bRome);
        if (resTech == "") continue;
        if (IsResearched(set, resTech)) continue;
        pendingCount += 1;
      }

      // If there are pending techs, pick one randomly
      if (pendingCount > 0) {
        randomChoice = rand(pendingCount);
        currentPending = 0;

        for (resType = 1; resType < 6; resType += 1) {
          if (!UEnabled(nEnabled, resType)) continue;
          resTech = UTech(resType, bRome);
          if (resTech == "") continue;
          if (IsResearched(set, resTech)) continue;

          // Is this the randomly chosen one?
          if (currentPending == randomChoice) {
            // Try to start research
            EnvWriteString(set, "strTech", resTech);
            set.AIRun("ESH_NeedTech.vs");

            if (IsResearching(set, resTech)) {
              EnvWriteInt(set, "nLastResearched", resType);
              EnvWriteInt(set, "nLRCounter", 10);
            }

            // Update last research time
            EnvWriteInt(set, "LastResearchTime_" + AIPlayer, currentTime);
            break;
          }
          currentPending += 1;
        }
      } else {
        // No pending techs, mark as all researched
        EnvWriteInt(set, "AllTechsResearched_" + AIPlayer, 1);
      }
    }
  }
}

// build counter units

nType = -2;
if (nLastResearched == 0) if (AIVar(AIPlayer, AIV_CounterUnits) != 0) {
  int i, dummy;
  // Base weights favor advanced units (types 1-5) over basic (type 0)
  int w0 = 0, w1 = 500, w2 = 500, w3 = 0, w4 = 0, w5 = 0, total;
  int ec, eg, og;

  if (IsResearched(set, UTech(3, bRome)))
    w3 = 800;

  if (IsResearched(set, UTech(4, bRome)))
    w4 = 800;

  if (IsResearched(set, UTech(5, bRome)))
    w5 = 800;
  
  // RHastatus counters
  ec = EnemyCount(AIPlayer, UType(0, true));
  if (ec >= 15) if (GetCmdCost(UTrainCmd(0, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RSpearman
      if (GetCmdCost(UTrainCmd(3, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(3, bRome));
        if (og < eg) w3 += (eg - og);
      }
      // RArcher - ranged effective vs basic infantry
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
    } else {
      // GSpearman
      if (GetCmdCost(UTrainCmd(3, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(3, bRome));
        if (og < eg) w3 += (eg - og);
      }
      // GArcher - ranged effective vs basic infantry
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
    }
  }

  // RGladiator counters
  ec = EnemyCount(AIPlayer, UType(2, true));
  if (ec >= 10) if (GetCmdCost(UTrainCmd(2, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RHorseman
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
      // RPraetorian - heavy infantry vs cavalry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    } else {
      // GHorseman
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
      // GWFighter
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // RSpearman counters
  ec = EnemyCount(AIPlayer, UType(3, true));
  if (ec >= 10) if (GetCmdCost(UTrainCmd(3, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RSpearman
      if (GetCmdCost(UTrainCmd(3, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(3, bRome));
        if (og < eg) w3 += (eg - og);
      }
      // RPraetorian - heavy infantry effective vs spearmen
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    } else {
      // GAxeman
      if (GetCmdCost(UTrainCmd(2, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(2, bRome));
        if (og < eg) w2 += (eg - og);
      }
      // GWFighter
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // RScout counters
  ec = EnemyCount(AIPlayer, UType(4, true));
  if (ec >= 10) if (GetCmdCost(UTrainCmd(4, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RSpearman (Princeps) - effective vs cavalry
      if (GetCmdCost(UTrainCmd(3, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(3, bRome));
        if (og < eg) w3 += (eg - og);
      }
      // RPraetorian - infantería pesada contra exploradores
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    } else {
      // GAxeman
      if (GetCmdCost(UTrainCmd(2, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(2, bRome));
        if (og < eg) w2 += (eg - og);
      }
      // GWFighter
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // RPraetorian counters
  ec = EnemyCount(AIPlayer, UType(5, true));
  if (ec >= 5) if (GetCmdCost(UTrainCmd(5, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RArcher
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
      // RPraetorian - heavy infantry vs heavy infantry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    } else {
      // GArcher
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
      // GWFighter - heavy infantry vs heavy infantry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // RLiberatus counters
  ec = EnemyCount(AIPlayer, "RLiberatus");
  if (ec >= 5) {
    eg = 200 * ec; // hardcoded cost
    if (bRome) {
      // RHorseman
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
      // RPraetorian - heavy infantry vs cavalry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    } else {
      // GHorseman
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
      // GWFighter - heavy infantry vs heavy infantry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // GSwordsman counters
  ec = EnemyCount(AIPlayer, UType(0, false));
  if (ec >= 15) if (GetCmdCost(UTrainCmd(0, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RGladiator
      if (GetCmdCost(UTrainCmd(2, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(2, bRome));
        if (og < eg) w2 += (eg - og);
      }
      // RHorseman
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
    } else {
      // GAxeman
      if (GetCmdCost(UTrainCmd(2, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(2, bRome));
        if (og < eg) w2 += (eg - og);
      }
      // GHorseman
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
    }
  }

  // GArcher counters
  ec = EnemyCount(AIPlayer, UType(1, false));
  if (ec >= 15) if (GetCmdCost(UTrainCmd(1, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RScout - cavalry vs archers
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
    } else {
      // GHorseman - cavalry vs archers
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
    }
  }

  // RArcher counters
  ec = EnemyCount(AIPlayer, UType(1, true));
  if (ec >= 5) if (GetCmdCost(UTrainCmd(1, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RHorseman - cavalry vs archers
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
    } else {
      // GHorseman - cavalry vs archers
      if (GetCmdCost(UTrainCmd(4, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(4, bRome));
        if (og < eg) w4 += (eg - og);
      }
    }
  }

  // GAxeman counters
  ec = EnemyCount(AIPlayer, UType(2, false));
  if (ec >= 10) if (GetCmdCost(UTrainCmd(2, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RPraetorian - heavy infantry effective vs spearmen
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
      // RArcher
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
    } else {
      // GWFighter
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // GSpearman counters
  ec = EnemyCount(AIPlayer, UType(3, false));
  if (ec >= 10) if (GetCmdCost(UTrainCmd(3, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RGladiator
      if (GetCmdCost(UTrainCmd(2, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(2, bRome));
        if (og < eg) w2 += (eg - og);
      }
      // RPraetorian - heavy infantry vs cavalry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    } else {
      // GAxeman
      if (GetCmdCost(UTrainCmd(2, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(2, bRome));
        if (og < eg) w2 += (eg - og);
      }
      // GWFighter - heavy infantry vs spearmen
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // GHorseman counters
  ec = EnemyCount(AIPlayer, UType(4, false));
  if (ec >= 10) if (GetCmdCost(UTrainCmd(4, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RSpearman (Princeps) - effective vs cavalry
      if (GetCmdCost(UTrainCmd(3, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(3, bRome));
        if (og < eg) w3 += (eg - og);
      }
    } else {
      // GSpearman
      if (GetCmdCost(UTrainCmd(3, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(3, bRome));
        if (og < eg) w3 += (eg - og);
      }
      // GWFighter - heavy infantry vs cavalry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // GWFighter counters
  ec = EnemyCount(AIPlayer, UType(5, false));
  if (ec >= 5) if (GetCmdCost(UTrainCmd(5, true), eg, dummy)) {
    eg = eg * ec;
    if (bRome) {
      // RArcher
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
      // RPraetorian
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og) * 2; //!!!
      }
    } else {
      // GWFighter - heavy infantry vs cavalry
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
      // GArcher - ranged effective vs basic infantry
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
    }
  }

  // GVikingLord counters
  ec = EnemyCount(AIPlayer, "GVikingLord");
  if (ec >= 1) {
    eg = 800 * ec; // hardcoded cost
    if (bRome) {
      // RArcher
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
      // RPraetorian - heavy infantry effective vs heroes
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    } else {
      // GArcher
      if (GetCmdCost(UTrainCmd(1, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(1, bRome));
        if (og < eg) w1 += (eg - og);
      }
      // GWFighter - heavy infantry effective vs heroes
      if (GetCmdCost(UTrainCmd(5, bRome), og, dummy)) {
        og = og * Count(AIPlayer, UType(5, bRome));
        if (og < eg) w5 += (eg - og);
      }
    }
  }

  // zero weights for disabled types
  if (!UEnabled(nEnabled, 0)) w0 = 0;
  if (!UEnabled(nEnabled, 1)) w1 = 0;
  if (!UEnabled(nEnabled, 2)) w2 = 0;
  if (!UEnabled(nEnabled, 3)) w3 = 0;
  if (!UEnabled(nEnabled, 4)) w4 = 0;
  if (!UEnabled(nEnabled, 5)) w5 = 0;

  // calc weighted random
  total = w0 + w1 + w2 + w3 + w4 + w5;
  if (total > 0) {
    // give some bonus to the original plan (reduced to favor counters)
    for (i = 1; i < 6; i += 1) {
      int t;
      if (i == 1) if (!bRome) continue;
      t = EnvReadInt(set, "TechSeq" + AIPlayer + "_" + i);
      if (!UEnabled(nEnabled, t)) continue;
      strTech = UTech(t, bRome);
      if (IsResearched(set, strTech)) continue;
      if (t == 1) w1 += 300;
      if (t == 2) w2 += 300;
      if (t == 3) w3 += 300;
      if (t == 4) w4 += 300;
      if (t == 5) w5 += 300;
      break;
    }
		total = w0 + w1 + w2 + w3 + w4 + w5;

    if (AIVar(AIPlayer, AIV_LogArmy) > 1) {
      pr("Weighted random odds: ");
      if (w0 > 0) pr ("  " + UType(0, bRome) + ": " + w0);
      if (w1 > 0) pr ("  " + UType(1, bRome) + ": " + w1);
      if (w2 > 0) pr ("  " + UType(2, bRome) + ": " + w2);
      if (w3 > 0) pr ("  " + UType(3, bRome) + ": " + w3);
      if (w4 > 0) pr ("  " + UType(4, bRome) + ": " + w4);
      if (w5 > 0) pr ("  " + UType(5, bRome) + ": " + w5);
    }

    i = rand(total);
    if (i < w0) nType = 0;
    else if (i < w0 + w1) nType = 1;
    else if (i < w0 + w1 + w2) nType = 2;
    else if (i < w0 + w1 + w2 + w3) nType = 3;
    else if (i < w0 + w1 + w2 + w3 + w4) nType = 4;
    else nType = 5;

    if (AIVar(AIPlayer, AIV_LogArmy) > 1)
      pr("Result: " + UType(nType, bRome));

  }
}


// Reduce army build delay for low-gold starts (less than 5000 gold)
nInitialGold = EnvReadInt(set, "InitialGold");
if (nInitialGold >= 5000) {
  nArmyDelay = 30000;
} else {
  nArmyDelay = 90000;
}
if (GetTime() < nArmyDelay) {
  return;
}
if (!bBuildArmy) return;


bNoArchers = Count(AIPlayer, "GArcher") + Count(AIPlayer, "RArcher") > AIVar(AIPlayer, AIV_ArcherPercent)*MilUnits(AIPlayer)/100;

if (nType >= 0) nDbg = 5;
else if (nLastResearched) { nDbg = 1; nType = nLastResearched; }
else if (rand(4) != 0) { // reduced from nLastBuilt/2+2 to flat 25% chance to try something new
	nDbg = 2;
	// 30% chance to pick something different even when continuing
	if (rand(10) < 3) nType = rand(6);
	else nType = nLastBuilt;
}
else
	{
		nDbg = 3;
		// Random selection strongly favoring advanced units (types 1-5) over basic (type 0)
		nRandSelect = rand(20);
		if (nRandSelect < 1) nType = 0;       // 5% basic infantry (reduced from 20%)
		else if (nRandSelect < 4) nType = 1;  // 15% archers
		else if (nRandSelect < 8) nType = 2;  // 20% gladiator/axeman
		else if (nRandSelect < 12) nType = 3; // 20% spearman
		else if (nRandSelect < 16) nType = 4; // 20% cavalry
		else nType = 5;                       // 20% heavy infantry (increased from 10%)

		// if (nType!=5) if (GetTime()>900000) if (rand(2)==1) nType+=1;
		if (nType!=5) if (set.gold >= AIVar(AIPlayer, AIV_ExcessGold)) nType+=1;
		if (!bNoArchers) if (rand(5)==1) nType = 1;
	}

if (nType == 1) if (bNoArchers) // We've chosen to build archers - archers should be no more than a fixed percent of the army
	nType = rand(6);

// Try to find a valid unit type, but don't always fall back to type 0
while (nType >= 0)
	{
		if (!UEnabled(nEnabled, nType)) { nType -= 1; continue; }
		strTech = UTech(nType, bRome);
		if (strTech!="")
			if (!IsResearched(set, strTech))
				{ nType -= 1; continue; }
		break;
	}

// If we fell all the way to -1, try to find ANY available researched unit
// Prefer advanced units (search from type 5 down to 0)
if (nType < 0) {
	for (nTryType = 5; nTryType >= 0; nTryType -= 1) {
		if (!UEnabled(nEnabled, nTryType)) continue;
		strTech = UTech(nTryType, bRome);
		if (strTech == "") { nType = nTryType; break; } // basic unit, no tech needed
		if (IsResearched(set, strTech)) { nType = nTryType; break; }
	}
}

if (nType < 0) return;

if (nType == 1) if (bNoArchers)
	nType = rand(6); // pick random instead of always type 0

strTech = UTech(nType, bRome);

if (strTech != "") if (!IsResearched(set, strTech))
  if (nAssUnderFire > 0) {
    // Under fire - find any available unit, prefer advanced units (search 5 to 0)
    nType = -1;
    for (nTryType = 5; nTryType >= 0; nTryType -= 1) {
      if (!UEnabled(nEnabled, nTryType)) continue;
      strTech = UTech(nTryType, bRome);
      if (strTech == "") { nType = nTryType; break; }
      if (IsResearched(set, strTech)) { nType = nTryType; break; }
    }
    if (nType < 0) return;
    nDbg = 4;
  } else return;

EnvWriteInt(set, "nBuildType", nType);
strCmd = UTrainCmd(nType, bRome);

// Reserve minimum gold for research - AI cannot recruit if it would go below this
// Use AIV_TechReserve as the fixed minimum gold reserve
iTechReserve = AIVar(AIPlayer, AIV_TechReserve);

// Calculate available gold for army after reserve
iAvailableGold = set.gold - iTechReserve;
if (iAvailableGold < 0) iAvailableGold = 0;

// Check affordability with reserved gold
if (!GetCmdCost(strCmd, unitCost, unitFood)) {
  return; // Can't get cost, abort
}

// Determine count based on available gold (not total gold)
if (iAvailableGold >= unitCost * 10) if (set.food >= unitFood * 10) nCount = 10;
else if (iAvailableGold >= unitCost * 5) if (set.food >= unitFood * 5) nCount = 5;
else if (iAvailableGold >= unitCost * 1) if (set.food >= unitFood * 1) if (nAssUnderFire <= 0) nCount = 1;
else {
  // Can't afford chosen unit - find affordable unit with tech reserve, prefer advanced (search 5 to 0)
  for (nTryType = 5; nTryType >= 0; nTryType -= 1) {
    if (!UEnabled(nEnabled, nTryType)) continue;
    strTech = UTech(nTryType, bRome);
    if (strTech != "") if (!IsResearched(set, strTech)) continue;
    strCmd = UTrainCmd(nTryType, bRome);
    if (GetCmdCost(strCmd, unitCost, unitFood)) {
      if (iAvailableGold >= unitCost) if (set.food >= unitFood) {
        EnvWriteInt(set, "nBuildType", nTryType);
        EnvWriteInt(set, "nBuildCount", 1);
        return;
      }
    }
  }
  // Not enough gold after tech reserve - don't build anything
  return;
}

EnvWriteInt(set, "nBuildCount", nCount);

if (nType != 0) if (nType == nLastResearched) {
  if (rand(5) == 0) nLRCounter = 0;
  else nLRCounter -= nCount; 
  if (nLRCounter < 0) nLRCounter = 0;
  EnvWriteInt(set, "nLRCounter", nLRCounter);
  if (nLRCounter <= 0) 
    EnvWriteInt(set, "nLastResearched", 0);
}
EnvWriteInt(set, "nLastBuilt", nType);

if (AIVar(AIPlayer, AIV_LogArmy) != 0) {
  if (nDbg == 1) pr("Player " + AIPlayer + " builds new fancy " + nCount + " " + UType(nType, bRome));
  if (nDbg == 2) pr("Player " + AIPlayer + " continues with "   + nCount + " " + UType(nType, bRome));
  if (nDbg == 3) pr("Player " + AIPlayer + " randomly builds "  + nCount + " " + UType(nType, bRome));
  if (nDbg == 4) pr("Player " + AIPlayer + " forced to build "  + nCount + " " + UType(nType, bRome));
  if (nDbg == 5) pr("Player " + AIPlayer + " COUNTERS with "    + nCount + " " + UType(nType, bRome));
}


