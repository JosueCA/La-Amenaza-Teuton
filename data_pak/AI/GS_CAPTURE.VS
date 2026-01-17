// void, GAIKA gaika

int       AIPlayer;
SquadList SL;
Squad     squad;
int       NextStrat;
int       state;
int       own, ally, enemy;
bool      bWait;
int       gtStart;

AIPlayer = AIGetPlayer();
gtStart = GetTime();

//pr( "CS_Capture in gaika " + gaika.ID + " for player " + AIPlayer );

// --- Step 1: gather approaching army
if (!gaika.settlement.IsOwn(AIPlayer)) {
	bWait = true;
	while( bWait )
	{
		int own, ally, enemy, nMinNeed;
		bWait = false;
		gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
 		nMinNeed = gaika.MinNeed(AIPlayer, own, ally, enemy);
		if (own + ally >= nMinNeed) break;
    gaika.Count(AI_STAYING, AIPlayer, own, ally, enemy);
    if (own >= enemy + 10) break;

		gaika.GetSquads( SL, AI_COMING + AI_STAYING, AIPlayer, AI_OWN );
    SL.Lock;
		while( SL.EOL == false ) {
			Squad squad; squad = SL.Cur;
			if (squad.GAIKAIn == gaika && squad.LastFightTime > gtStart)
				{ bWait = false; break; }
			if (squad.State == SS_Approach)
				if (squad.GAIKAIn == gaika)
          squad.ClrCmd(SS_Wait, 0, SF_ADVCHOOSER);
				else
					bWait = true;
			SL.Next();
		}
    SL.Unlock;
		if( gaika.GetStrat( AIPlayer ) != GS_Capture ) break;
		if( bWait ) Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
	}
}

while (666) {
// own check for next strat (allow some minor enemy presence); decide attack (siege) or capture 
  state = SS_Capture;
  if (!gaika.settlement.IsEnemy(AIPlayer))
		break;
  gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
  if (enemy * 8 > own + ally || (gaika.settlement.IsOutpost() && gaika.settlement.UnitsCount()>10))
		if (gaika.AllEnemiesInHolder(AIPlayer))
			state = SS_Siege;
		else
			break;
  if (state == SS_Capture) if (own + ally < 2000) if (!gaika.settlement.IsIndependent())
	  if (!gaika.settlement.IsOutpost() || gaika.settlement.UnitsCount()==0) {
			gaika.Count(AI_STAYING, AIPlayer, own, ally, enemy);
			if (own + ally < 5)
				state = SS_IDLE;
	  }
	if (state == SS_Capture) if (gaika.settlement.IsOutpost()) if (gaika.settlement.UnitsCount()!=0) {
		gaika.Count(AI_STAYING, AIPlayer, own, ally, enemy);
		if (own+ally <= gaika.settlement.UnitsCount()+11)
			state = SS_Siege;
	}

// command
  gaika.GetSquads(SL, AI_STAYING, AIPlayer, AI_OWN);
  SL.Lock;
  for (0; !SL.EOL; SL.Next) {
	  squad = SL.Cur;
    if (squad.TestFlags(SF_PEACEFUL)) continue;

    if (squad.State == state) continue;
    if (squad.State == SS_Catapult && state == SS_Siege) continue;

	  if (squad.State != SS_IDLE && squad.State != SS_Wait && squad.State != SS_Approach && squad.State != SS_Flee && 
        squad.State != SS_Capture && squad.State != SS_Siege && squad.State != SS_Catapult)
      continue;

    if (state == SS_Capture)
		  squad.SetCmd(SS_Capture, 0, SF_ADVCHOOSER, "capture", gaika.settlement.GetCentralBuilding);
    else if (state == SS_Siege) { 
			if (squad.State != SS_Catapult)
				squad.Siege(gaika.settlement.GetCentralBuilding, 2, SS_Catapult, SS_Siege);
		}
    else if (state == SS_IDLE) squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
  }
  SL.Unlock;

  Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

NextStrat = gaika.GetStrat(AIPlayer);
gaika.GetSquads(SL, AI_ALL, AIPlayer, AI_OWN);
SL.Lock;
for (0; !SL.EOL; SL.Next) {
	if (SL.Cur.State == SS_Capture || SL.Cur.State == SS_Siege || SL.Cur.State == SS_Catapult) {
		//if (SL.Cur.OrderDest == gaika) SL.Cur.DelOrder();
    if (NextStrat == GS_KillEnemies) 
      SL.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
    else {
		  //SL.Cur.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
      SL.Cur.SetState(SS_IDLE); SL.Cur.SendTo(gaika, 1);
    }
	}
}
SL.Unlock;
// pr( "CS_Capture in gaika " + gaika.ID + " for player " + AIPlayer + " done!");