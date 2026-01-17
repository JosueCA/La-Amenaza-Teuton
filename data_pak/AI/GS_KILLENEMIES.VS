// void, GAIKA gaika
int       i, AIPlayer;
Squad     squad;
SquadList SL;
bool      bWait;
int       gtStart;

//pr( "CS_KillEnemies in gaika " + gaika.ID + " for player " + AIPlayer );

AIPlayer = AIGetPlayer();
gtStart = GetTime();

// --- Step 1: gather approaching army
if (!gaika.settlement.IsOwn(AIPlayer)) {
	bWait = true;
	while( bWait )
	{
		int own, ally, enemy, nMinNeed;
		bWait = false;
		gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy);
		if (enemy == 0) break;
		nMinNeed = gaika.MinNeed(AIPlayer, own, ally, enemy);
		if (own + ally >= nMinNeed) break;

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
		if( gaika.GetStrat( AIPlayer ) != GS_KillEnemies ) break;
		if( bWait ) Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
	}
}

// --- Step 2: fight the bad guys
while( gaika.GetStrat( AIPlayer ) == GS_KillEnemies )
{
  int   state;
  bool  bEnter = false;

// decide whether to hide in the townhall at all
  if (gaika.settlement.IsStronghold) if (gaika.settlement.IsOwn(AIPlayer)) if(0 == EnvReadInt(gaika.settlement, "EnemiesAlert")) {
    int our, enemy;
    our = gaika.Eval(AI_STAYING, AIPlayer, AI_OWN + AI_ALLY);
    enemy = gaika.Eval(AI_STAYING + AI_COMING, AIPlayer, AI_ENEMY);
    bEnter = (enemy * 2 > our);
  }

// command gates
  if (gaika.settlement.IsStronghold) 
    if (bEnter) gaika.settlement.IdleAllGates();
    else gaika.settlement.OpenAllGates();


// --- command our squads
	gaika.GetSquads( SL, AI_STAYING + AI_COMING, AIPlayer, AI_OWN );
  SL.Lock;
	while( SL.EOL == false )
	{
		squad = SL.Cur;

    if ((squad.GAIKAIn != gaika) && (squad.State != SS_Wait))
      { SL.Next; continue; }

    if (squad.Leader.AsShip.IsValid) if ((squad.Leader.command == "aitransport") || (squad.Leader.command == "boardunit"))
      { SL.Next; continue; }

    if (squad.OrderDest != gaika) 
      { SL.Cur.SendTo(gaika, 1); SL.Next; continue; } // issue order, to force squad's AIDest to gaika
  
  // --- decide to use or not the towers
	  if (bEnter) state = SS_Enter;
    else state = SS_KillAll;

  // --- command
		if (squad.State != SS_Flee && squad.State != SS_Attach && squad.State != state) if (!squad.TestFlags(SF_PEACEFUL))
			if (state == SS_Enter)
        squad.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", gaika.settlement.GetCentralBuilding);
			else
				squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall" );
//        squad.ClrCmd(SS_KillAll, SF_ADVCHOOSER, 0);
		SL.Next();
	}
  SL.Unlock;
	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}
// --- Step 3: clean up
if (gaika.settlement.IsStronghold) gaika.settlement.IdleAllGates();
gaika.GetSquads( SL, AI_ALL, AIPlayer, AI_OWN );
SL.Lock;
while( SL.EOL == false ) {
  bool bStop = false;
	squad = SL.Cur;
	if (squad.State == SS_KillAll || squad.State == SS_Wait || squad.State == SS_Enter ) bStop = true;
  else if (squad.State == SS_Approach && squad.GAIKAIn == gaika && squad.AIDest == gaika)
    bStop = true;

  if (bStop) {
		//if (SL.Cur.OrderDest == gaika) SL.Cur.DelOrder();
    //SL.Cur.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
    SL.Cur.SetState(SS_IDLE); SL.Cur.SendTo(gaika, 1);
	}
	SL.Next();
}
SL.Unlock;
//pr( "CS_KillEnemies in gaika " + gaika.ID + " for player " + AIPlayer + " done!");