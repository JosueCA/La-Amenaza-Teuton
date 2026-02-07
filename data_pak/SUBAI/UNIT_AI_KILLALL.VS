// void, Obj u

Unit this;
Obj  enemy;

this = u.AsUnit;
while( 1 ) 
{
	enemy = .BestTargetInSquadSight;
	if( ! enemy.IsValid ) enemy = .BestTargetInGAIKA.AsUnit;
	if( enemy.IsAlive )	
	{
    if( .GotoAttack( enemy, 1500, true, -1))
			while( .Attack( enemy )) if(!.IsVisible) .SetVisible(true);
  }	
	else
		Sleep( 1000 );
}