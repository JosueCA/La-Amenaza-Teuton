//bool, Obj this, Obj other
Unit me,him;
Building bld;
me = this.AsUnit();

if (other.class=="Inn" && GetInnState(other)==1 && me.GetParty()) return true;


return false; //in all other cases

