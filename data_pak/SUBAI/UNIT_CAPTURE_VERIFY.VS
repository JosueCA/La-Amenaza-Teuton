//bool, Obj this, Obj other
Unit me,him;
Building bld;
me = this.AsUnit();
bld = other.AsBuilding();


if (bld.IsValid()) 
	if (me.IsValidCaptureTarget(bld))
		return me.IsEnemy(bld);

return false; //in all other cases

