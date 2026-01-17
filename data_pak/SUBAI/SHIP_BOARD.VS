// void, Obj This, Obj ToBoard

Ship  this;
Unit  u1;
Unit  u2;
bool  bMoved;
point pos, p1;

int   s1,s2,s3;
int   vs,vu;

this = This.AsShip;

u1 = ToBoard.AsUnit;
if( u1.IsValid )
{
	.NotifyBoardUnit( u1 );
	if( u1.AsHero.IsValid )
		u1.SetCommand( "boardshiphero", this );
	else
		u1.SetCommand( "boardship", this );
}
while( .AreUnitsToBoard )
{
	u1 = .BestCandidateToBoard;
	bMoved = false;

	pos = u1.PathDestFound;
	if( pos.x != -1 )
	{
		s1 = .DistTo( u1.pos ) + .radius;
		s2 = .DistTo( pos ) + .radius;
		s3 = u1.DistTo( pos ) + u1.radius;
		vs = .speed;
		vu = u1.speed;
		if( (s1 * vu) < (s3 * vs) || s1 < s2 ) pos = u1.pos;
	}
	else
		pos = u1.pos;

	while( ! .GotoEnter( pos, 0, 1200, true, -1 ))
	{
		bMoved = true;
		u2 = .BestCandidateToBoard;
		if( u2 != u1 && u2.IsValid ) u1 = u2;
		if( ! u1.IsAlive ) break;
		if( .TimeWithoutWalking() > 0 ) break;
		if( .NumUnitsToBoard() == 0 ) return;
		pos = u1.PathDestFound;
		if( pos.x != -1 )
		{
			s1 = .DistTo( u1.pos ) + .radius;
			s2 = .DistTo( pos ) + .radius;
			s3 = u1.DistTo( pos ) + u1.radius;
			vs = .speed;
			vu = u1.speed;
			if( (s1 * vu) < (s3 * vs) || s1 < s2 ) pos = u1.pos;
		}
		else
			pos = u1.pos;
	}
	while( 1 )
	{
//		u1 = .BestCandidateToBoard;
		if( ! u1.IsAlive ) break;
		if( .DistTo( u1.pos ) > 500 && bMoved ) break;
		Sleep( 100 );
	}
	Sleep( 100 );
}