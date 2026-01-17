// void, Obj This

Sacrifice this;
int life, price;
Unit ghost;

this = This.AsSacrifice();

price = GetConst("GhostToll");

//.pr("ghost_sacrifice::idle: Sacrifice begins");

ghost = Place("GGhost", .pos, .player).AsUnit();

ghost.StartAnim(17, .pos);

life = 1;

while (life > 0 && ghost.IsAlive) {
	life = .Consume(price, 1000, true);
	//.pr("ghost_sacfrifice::idle: Got health: " + life);
}

if(ghost.IsAlive)
	ghost.Damage(ghost.health);

.Erase();

//.pr("ghost_sacrfice::idle: Sacrifice has ended");


