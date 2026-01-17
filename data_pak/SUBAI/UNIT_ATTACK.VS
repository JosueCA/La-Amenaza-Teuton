// void, Obj me, Obj u

Unit this;
ObjList enemies;

this = me.AsUnit();

//.pr("unit::attack: attacking particular enemy");

if( u.AsBuilding.IsValid ) Sleep( rand( 600 ));
if(.IsEnemy(u) || u.AsBuilding.IsValid)
{
	while(u.IsAlive() && .IsValidTarget(u))
	{
		if(!.IsEnemy(u) && !u.AsBuilding.IsValid)
			return;
		//.pr("unit::attack: going to enemy");
		if(.GotoAttack(u, 5000, true, 2500))
		{
			//.pr("unit::attack: fighting");
			while(.Attack(u)) if(!.IsVisible) .SetVisible(true);
		}
	} 
}
.AddCommand(true, "engage");