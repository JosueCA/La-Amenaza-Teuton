// bool, Obj this, Obj other

Unit me;
Building it;

me = this.AsUnit();
it = other.AsBuilding();


if(!me.IsValid()) return false;
if(!it.IsValid()) return false;
if( it.IsHeirOf("BaseRuins")) return false;

//if(!it.IsCentralBuliding()) return false;
//if(it.settlement.max_units==0) return false;
return (!me.IsEnemy(it));