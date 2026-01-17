// void
int         nSetIdx, nMaxSet;
Settlement  Set;
int         AIPlayer;
int         script;

Sleep(rand(1000));

AIPlayer = AIGetPlayer();
nMaxSet = MaxSetIdx();
while( true )
{
	for( nSetIdx = 0; nSetIdx < nMaxSet; nSetIdx += 1 )
	{
		Set = IdxToSet( nSetIdx );
		if (!Set.IsOwn(AIPlayer)) continue;
		if( Set.EconomyScript != ES_NONE ) continue;
		script = Set.GetEconomyScript( AIPlayer );
		if( script != ES_NONE )
			Set.RunEconomyScript( script );
	}
	Sleep(1000);
}