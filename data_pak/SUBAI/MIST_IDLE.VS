// void, Obj This

Sacrifice this;
int life, damage, price;

this = This.AsSacrifice();

damage = GetConst("MistDamage");
price = GetConst("MistToll");

//.pr("mist::idle: Sacrifice begins");

.PlayAnim(1, .pos);

life = 1;

while (life > 0) {
  .PlayAnim(2, .pos);
	life = .Consume(price, .GetAnimTime(2), false);
	if (life)
		.MistAction(damage);
	//.pr("mist::idle: Got health: " + life);
}


// .PlayAnim(3, .pos);
.Erase();

//.pr("mist::idle: Sacrifice has ended");


