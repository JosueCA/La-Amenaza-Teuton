// void
int  i, AIPlayer, Strat;

Sleep(rand(1000));

AIPlayer = AIGetPlayer();
while ( ! LAIKA( AIPlayer, GAIKACount() - 1 ).Prioritized( AIPlayer ))
{
  Sleep( 2000 );
}

while( true )
{
  bool bIP, bSA;
  bIP = (AIVar(AIPlayer, AIV_InterruptPassing) != 0);
  bSA = (AIVar(AIPlayer, AIV_SynchApproach) != 0);

	for (i = 1; i < GAIKACount(); i += 1)	{
		GAIKA gaika; gaika = LAIKA( AIPlayer, i );

		if (gaika.settlement.IsOwn(AIPlayer))
			gaika.SetControlFlag(AIPlayer, true);

		if (i%15==0) Sleep(100); // Don't think too much
		if (!gaika.MilitaryPresence(AIPlayer)) continue;

    if (bIP) gaika.AIRun("GSH_InterruptPassing.vs", AIPlayer);
    if (bSA) gaika.AIRun("GSH_SynchApproach.vs", AIPlayer);

		if (gaika.StratRunning(AIPlayer) != GS_NONE) continue;

		Strat = gaika.GetStrat(AIPlayer);
		if (Strat != 0) {
			//pr( "> GAIKA " + i + " without STRATEGY found and we found that it may run " + Strat );
			gaika.RunStrat( AIPlayer, Strat );
      Sleep( 500 );
 		}
		Sleep( 100 );
	}
  Sleep(100);
}