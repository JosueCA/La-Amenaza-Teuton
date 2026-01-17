// void, Obj This, Obj target
Hero this;
point pt;
int i;
this = This.AsHero;
//.pr("hero::attack: approaching target");

if (!target.IsValid)
	return;

if (.InHolder || .PathTo(target, .FormRadius, 0) > .sight) {
.FormSetupAndMoveTo(target, 0, 0, true);
while (1)
{
	if (!.HasPath) break;
	if (!target.IsAlive) break;
	if (.DistTo(target) <= .sight * 2 / 3) break;
	.FormKeepMoving(1500);	
}
}

while (!.IsArmyOutside)
	.FormKeepMoving(500);

//.pr("hero::attack: target locked!!!");

if (!target.IsValid)
	return;
if (target.AsBuilding)
{
	for (i = 0; i < .army.count; i += 1)
		if (.army[i].IsValidTarget(target))
			.army[i].SetCommand("attack", target);
		else
			.army[i].SetCommand("idle");
	return;
}

// attack the target with all ranged units
for (i = 0; i < .army.count; i += 1)
	if (.army[i].IsHeirOf("Ranged"))
		.army[i].SetCommand("attack", target);
	else
		.army[i].SetCommand("engage");

while (target.IsAlive)
{
	if (!.IsEnemy(target))
		return;
	//.pr("hero::attack: going to enemy");
	if (.GotoAttack(target, 5000, true, 2500))
	{
		//.pr("hero::attack: fighting");
		while (target.IsAlive)
		{
			if (!.Attack(target))
				break;
			if (!.IsVisible)
				.SetVisible(true);
			Sleep(19);
		}
	}

	Sleep(17);
}

.AddCommand(true, "engage");
