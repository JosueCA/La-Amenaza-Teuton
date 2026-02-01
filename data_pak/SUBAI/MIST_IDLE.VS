// void, Obj This

Sacrifice this;
int life, damage, price, range;
Query qUnits;
ObjList lUnits;
Unit unit;
int i, count;

this = This.AsSacrifice();

damage = GetConst("MistDamage");
price = GetConst("MistToll");
range = GetConst("MistRange");

//.pr("mist::idle: Sacrifice begins");

.PlayAnim(1, .pos);

life = 1;

while (life > 0) {
  .PlayAnim(2, .pos);
	life = .Consume(price, .GetAnimTime(2), false);
	if (life) {
		// Get all units in range
		qUnits = ObjsInRange(this, "Unit", range);
		if (qUnits.count != 0) {
			lUnits = qUnits.GetObjList();
			lUnits.ClearDead();
			count = lUnits.count;

			// Apply damage only to enemies
			for (i = 0; i < count; i += 1) {
				unit = lUnits[i].AsUnit();
				if (unit.IsValid) {
					if (.IsEnemy(unit)) {
						unit.Damage(damage);
						CreateFeedback("Poison", unit);
					}
				}
			}
		}
	}
	//.pr("mist::idle: Got health: " + life);
}


// .PlayAnim(3, .pos);
.Erase();

//.pr("mist::idle: Sacrifice has ended");


