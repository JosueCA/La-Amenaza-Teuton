// void, Obj me

Unit  this, u;
point pt;
int   range;
bool  bSleeped;

this = me.AsUnit();
while( ! .Stop( 1000 ));
pt = .posRH;
range = 120;

while( ! .Stop( 200 ));
while(.IsAlive)
{
	if (.CmdCount() > 1)
		break;
	if( .IsRanged )
	{
		u = .BestTargetInRange( pt, .range );
		while( u.IsAlive && .IsValidTarget( u ) && .IsVisible)
		{
			bSleeped = false;
			while( .Attack( u ))
			{
				if( ! .IsVisible ) break;
				bSleeped = true;
			}
			if( ! bSleeped ) Sleep( 50 );
			u = .BestTargetInRange( pt, .range );
		}
	}
	else
	{
		u = .BestTargetInRange( pt, range );
		while( u.IsAlive && .IsValidTarget( u ) && .IsVisible)
		{
			.pr("lesser loop");
			bSleeped = false;
			while( ! .GotoAttack( u, 1500, true, -1 ))
			{
				bSleeped = true;
				u = .BestTargetInRange( pt, range );
				if( !u.IsAlive || ! .IsValidTarget( u )) break;
				if( !.IsVisible ) break;
			}
			if( u.IsAlive && .IsValidTarget( u ) && .IsVisible)
			{
				while( .Attack( u ))
				{
					if( ! .IsVisible ) break;
					bSleeped = true;
				}
			}
			if( ! bSleeped ) Sleep( 50 );
			u = .BestTargetInRange( pt, range );
		}
	}
	.pr("main loop");
	if( ! u.IsAlive && ( pt.x != .posRH.x || pt.y != .posRH.y ))
	{
		while( ! .Goto( pt, 0, 2000, false, -1 ));
	}
	else
		.Idle(1900 + rand(100));
}