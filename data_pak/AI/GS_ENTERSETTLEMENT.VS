// void, GAIKA gaika

int        AIPlayer;
SquadList  SL;
Squad      squad;
int        gtStart;
int        mages;

AIPlayer = AIGetPlayer();
gtStart = GetTime();
//pr( "CS_EnterSettlement in gaika " + gaika.ID + " for player " + AIPlayer );

while( 666 ) {
  SquadList slTrain;
  bool bStarted, bEnter, bTrain; 
  bool bPr;
  int  i;

  bStarted = gtStart + 15000 <= GetTime();
  bEnter = bStarted;
  // Training disabled - units now spawn with level based on Training research
  bTrain = false;
  // bTrain = bStarted && gaika.settlement.IsStronghold;
  // if (bTrain) if (0 < gaika.Eval(AI_STAYING + AI_COMING, AIPlayer, AI_ENEMY)) bTrain = false;
  if (!bEnter) if (!gaika.settlement.IsStronghold) if (gaika.Eval(AI_STAYING, AIPlayer, AI_ENEMY) > 0) bEnter = true;
  bPr = (AIVar(AIPlayer, AIV_LogTrain) != 0);
	mages = gaika.Count(AIPlayer, AI_OWN, "BaseMage");

  gaika.GetSquads( SL, AI_STAYING, AIPlayer, AI_OWN );
  SL.Lock;
  while( SL.EOL == false ) {
    bool bE, bT; bE = bEnter; bT = bTrain;

	  squad = SL.Cur;
    if (squad.TestFlags(SF_PEACEFUL + SF_NOAI)) { SL.Next; continue; }
		if (squad.State == SS_Ruins) { SL.Next; continue; }
    
		if (squad.State == SS_Flee) { bE = true; bT = true; }
    else if (squad.State == SS_Train) bT = true;
    else if (squad.State == SS_Wait || squad.State == SS_Approach) {
      if (!bE) squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
    } else if (squad.State != SS_IDLE) if (squad.State != SS_Enter) if (squad.State != SS_Heal)
      bE = false;

		// Heal with mages logic
		if (bT || bE)
			{
				bool bExit = false;
				if (gaika.settlement.IsStronghold)
					{
						if (squad.Leader.AsHero.IsValid && squad.Leader.health<squad.Leader.maxhealth*3/4)
							bExit = mages>=4;
						else
							if (squad.health<squad.maxhealth*3/4)
								bExit = mages>=9;
						if (gaika.settlement.food<50)
							if (squad.health<squad.maxhealth)
								bExit = mages>=4;
					}
				
				if (bExit) 
					{
						if (squad.State != SS_Heal)
							{
								point vec;
								vec.Set(0, 320);
								vec.Rot(rand(360));
								squad.SetCmd(SS_Heal, 0, SF_ADVCHOOSER, "move", vec+gaika.settlement.GetCentralBuilding.pos);
							}
						bT = false;
						bE = false;
					}
			}
		
		if (bT) slTrain.Add(squad);
    else if (bE) if (squad.State != SS_Enter)
			squad.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", gaika.settlement.GetCentralBuilding);

	  SL.Next();
  }
  SL.Unlock;

  i = slTrain.Train(SS_Train, SS_Enter, 4, 10, gaika.settlement.GetCentralBuilding);
  if (bPr)
    if (i == 1) pr("Player " + AIPlayer + " started training in GAIKA " + gaika.ID);
//    else if (i == 2) pr("Player " + AIPlayer + " continues training in GAIKA " + gaika.ID);
    else if (i == 3) pr("Player " + AIPlayer + " stopped training in GAIKA " + gaika.ID);

  if (gaika.GetStrat( AIPlayer ) != GS_EnterSettlement) break;
  Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

gaika.GetSquads( SL, AI_ALL, AIPlayer, AI_OWN );
SL.Lock;
while( SL.EOL == false ) {
	if (SL.Cur.State == SS_Enter || SL.Cur.State == SS_Train || SL.Cur.State == SS_Heal) {
		//if (SL.Cur.OrderDest == gaika) SL.Cur.DelOrder();
    SL.Cur.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
  }
	SL.Next();
}
SL.Unlock;
//pr( "CS_EnterSettlement in gaika " + gaika.ID + " for player " + AIPlayer + " completed");