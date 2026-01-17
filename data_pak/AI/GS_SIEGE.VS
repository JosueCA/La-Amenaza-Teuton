// void, GAIKA gaika

int        AIPlayer;
SquadList  SL;
Squad      squad;
Settlement set;
Gate       gate;
int        gtStart;
int        state;
int        own, ally, enemy, nMinNeed;
int        nInHolder;
bool       bPr;
str        s;

AIPlayer = AIGetPlayer();
gtStart = GetTime();
set = gaika.settlement;
bPr = (AIVar(AIPlayer, AIV_LogSiege) != 0);

if (bPr) pr( "*** CS_Siege in gaika " + gaika.ID + " for player " + AIPlayer );

if( set.NumGates() == 0 )
  { pr("CS_Siege(" + gaika.ID + "): no gates -> nothing to siege!"); return; }

// Step 1: gather approaching squads
if (bPr) pr("=== Gathering army ...");
while (666) {
	bool bWait = false;
  bPr = (AIVar(AIPlayer, AIV_LogSiege) != 0);
  gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
  if (enemy * 8 <= own + ally) break;
  nMinNeed = gaika.MinNeed(AIPlayer, own, ally, enemy);
  if (own + ally >= nMinNeed) break;

	gaika.GetSquads(SL, AI_COMING + AI_STAYING, AIPlayer, AI_OWN);
  SL.Lock;
	for (0; !SL.EOL; SL.Next) {
		squad = SL.Cur;
    if (squad.GAIKAIn == gaika && squad.LastFightTime > gtStart)
      { bWait = false; break; }
		if (squad.State == SS_Approach)
			if (squad.GAIKAIn == gaika )
        squad.ClrCmd(SS_Wait, 0, SF_ADVCHOOSER);
			else
				bWait = true;
	}
  SL.Unlock;
  if (!bWait) break;
	if (gaika.GetStrat(AIPlayer) != GS_Siege) break;
  Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

// --- Step 2: Siege (attack gate or kill enemies or capture)
if (bPr) pr("=== Sieging ...");
while (666) {
  bool bEnemies, bEnemiesOut;
  bPr = (AIVar(AIPlayer, AIV_LogSiege) != 0);
  
  if (gaika.GetStrat(AIPlayer) != GS_Siege) {
		bool bBreak = true;
		gaika.GetSquads(SL, AI_STAYING + AI_COMING, AIPlayer, AI_OWN);
		for (0; !SL.EOL; SL.Next) {
      if (squad.State == SS_Siege || squad.State == SS_Catapult)
				{ bBreak = false; break; }
		}
		if (bBreak)
			break;
	}


  gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
  bEnemies = (enemy * 4 > own + ally);
  nInHolder = gaika.settlement.UnitsInHolderEval();
  bEnemiesOut = ((enemy - nInHolder) * 4 > own + ally);

  if (bPr) {
    if (enemy == 0) pr("--- No enemies at all");
    else if (!bEnemies) pr("--- Miserable defence");
    else if (nInHolder >= enemy) pr("--- All enemies in holder");
    else if (!bEnemiesOut) pr("--- Most enemies in holder");
    else pr("--- Serious defence");
  }

	gaika.GetSquads(SL, AI_STAYING + AI_COMING, AIPlayer, AI_OWN);
  SL.Lock;
	for (0; !SL.EOL; SL.Next) {
		squad = SL.Cur;
    if (squad.TestFlags(SF_PEACEFUL)) continue;
    if (squad.GAIKAIn != gaika) if (squad.State != SS_IDLE) if (squad.State != SS_Wait) if (squad.State != SS_Siege) if (squad.State != SS_Catapult) if (squad.State != SS_KillAll) 
      continue;
    if (squad.State == SS_Flee || squad.State == SS_Attach) continue;
    if (squad.OrderDest != gaika) { squad.SendTo(gaika, 1); continue; } // issue order, to force squad's AIDest to gaika

    if (bPr) s = "  squad " + squad.No + "(" + squad.Size + "/" + squad.Eval + ", " + SS_STR(squad.State) + ", ";

    gate = set.BestGate (squad.pos);
    if (!gate.IsValid) { Breakpoint; continue; }

    if (gate.Inside(squad)) {
      if (bPr) s = s + "inside";
      if (bEnemiesOut) state = SS_KillAll;
      else state = SS_Capture;
    } else {
      if (bPr) s = s + "outside";
      if (gate.IsVeryBroken) state = SS_Enter;
      else state = SS_Siege;
    }

    if (state == SS_Capture) if (AIVar(AIPlayer, AIMV_NoCapture, set.player))
      state = SS_IDLE;

    if (bPr) if (squad.State != state) if ((state != SS_Siege) || (squad.State != SS_Catapult)) {
      s = s + "): " + SS_STR(state);
      pr(s);
    }

    if (squad.State != state)
      if (state == SS_Siege) {
         if (squad.State != SS_Catapult)
           squad.Siege(gate, 2, SS_Catapult, SS_Siege);
      }
      else if (state == SS_KillAll) squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
      else if (state == SS_Capture) squad.SetCmd(SS_Capture, 0, SF_ADVCHOOSER, "capture", gaika.settlement.GetCentralBuilding);
      else if (state == SS_IDLE)    squad.ClrCmd(SS_IDLE,    0, SF_ADVCHOOSER);
      else if (state == SS_Enter)   squad.InvadeThroughGate(gate, SS_Enter);
	}
  SL.Unlock;
	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

// --- Step 4: clear SS_Siege state and advance to the center of settlement (if next strat is KillAll)
if (bPr) pr("=== Cleaning up ...");
gaika.GetSquads( SL, AI_ALL, AIPlayer, AI_OWN );
SL.Lock;
for (0; !SL.EOL; SL.Next) {
	squad = SL.Cur;
	if (/*squad.State == SS_Approach || */squad.State == SS_IDLE || squad.State == SS_Wait || squad.State == SS_Siege || squad.State == SS_Catapult || squad.State == SS_KillAll || squad.State == SS_Capture || squad.State == SS_Enter) {
		//if (squad.OrderDest == gaika) squad.DelOrder();
    //squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
    squad.SetState(SS_IDLE); squad.SendTo(gaika, 1);
	}
}
SL.Unlock;
if (bPr) pr( "*** CS_Siege in gaika " + gaika.ID + " for player " + AIPlayer + " done!" );
