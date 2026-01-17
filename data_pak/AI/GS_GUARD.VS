// void, GAIKA gaika

int        AIPlayer;
SquadList  SL;
Squad      squad;

AIPlayer = AIGetPlayer();
//pr( "CS_Guard in gaika " + gaika.ID + " for player " + AIPlayer );

while (666) {
  gaika.GetSquads( SL, AI_ALL, AIPlayer, AI_OWN );
  SL.Lock;
  while (SL.EOL == false) {
    bool bStop = false;
	  squad = SL.Cur; 
    SL.Next();
	  
    if ((squad.State != SS_Wait) && (squad.State != SS_Approach)) continue;
    if (squad.State == SS_Wait) bStop = true;
    else if (squad.GAIKAIn == gaika && squad.AIDest == gaika) // staying      
      bStop = true;
    // doesn't stop coming or leaving squads with SS_Approach

    if (bStop) {
      if (squad.State != SS_Wait) if (squad.pos.Dist(gaika.Center) > 500) 
        continue;
		  //if (SL.Cur.OrderDest == gaika) squad.DelOrder();
		  squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
	  }
  }
  SL.Unlock;
  if (gaika.GetStrat( AIPlayer ) != GS_Guard)
    break;

  Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

//pr( "CS_Guard in gaika " + gaika.ID + " for player " + AIPlayer + " completed");