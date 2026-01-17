// bool, Obj this, Obj other

Unit me;
Building it;

me = this.AsUnit();
it = other.AsBuilding();

if( other.IsHeirOf("BaseRuins"))
	return .AsHero().IsValid;


if(!me.IsValid()) return false;
if(!it.IsValid()) return false;
if(!it.IsCentralBuliding()) return false;

if (it.IsHeirOf("Catapult")) {
	//see build_catapult command in commands.xml
	if (!me.IsHeirOf("Military")) return false;
	//if (me.IsHeirOf("ShipL")) return false; doesnt use this verifier
	if (me.IsHeirOf("Hero")) return false;
}

if(it.settlement.max_units==0) return false;
if(!DiplGetShareView(it.player, me.player)) return false;

return (!me.IsEnemy(it));