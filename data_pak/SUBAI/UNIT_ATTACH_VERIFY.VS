// bool, Obj me, Obj h

Unit this;
Hero hero;

hero = me.AsHero();
if(hero.IsValid()) return false;

hero = h.AsHero();
this = me.AsUnit();

if(.HasFreedom) {
	return false;
}

if(!hero.IsValid()) {
  return false;
}

if(!this.IsValid()) {
  return false;
}

return (!.IsEnemy(hero));