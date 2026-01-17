//void, Obj me, point pt

Hero  this;
point dest;
int   formed,i;

this = me.AsHero();

dest = GetVec( .posRH, pt, 16 );
.FormSetupAndMoveTo(.posRH + dest,0,0,true);
for( i = 0; i < .army.count; i += 1 )
{
	.army[i].AddCommand( false, "stand_position" );
}
while(.HasPath())
{
	.FormKeepMoving(1500);
}
.AddCommand( false, "stand_position" );