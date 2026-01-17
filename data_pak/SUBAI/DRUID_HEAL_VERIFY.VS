// bool, Obj This, Obj target

Unit this;
Druid d;

this = This.AsUnit();

// the healing need not be researched
//if(EnvReadString(This.player, "heal") == "")
//	return false;

if (!.IsValid() || !target.IsValid()) return false;
if (!(target.IsAlive() && !.IsEnemy(target) && .CanSee(target) && target != this && target.health < target.maxhealth)) 
  return false;
if( target.IsAlive ) if( target.AsShip.IsValid )
{
	return false;
}

d = target.AsDruid();
if (d.IsValid()) 
  if (d.GetSacrifice().IsValid()) return false;

return true;
