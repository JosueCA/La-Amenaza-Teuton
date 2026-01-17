//bool, Obj this, Obj other

if( ! .IsWaterUnit && ! .IsEnemy( other ) && ! other.IsEnemy( this ))
	if( other.AsShip.IsValid )
		if( other.AsShip.UnitsCount < other.AsShip.UnitsMax )
			return true;

return false;