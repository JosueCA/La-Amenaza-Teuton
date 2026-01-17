// bool, Obj This, Obj other

if( This.IsEnemy( other ) || other.IsWaterUnit || other.AsBuilding().IsValid() ||
	This.AsShip.UnitsCount == This.AsShip.UnitsMax ) return false;
return true;