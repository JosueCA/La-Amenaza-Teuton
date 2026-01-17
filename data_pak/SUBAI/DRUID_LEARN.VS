// void, Obj This, Obj target

Druid this;
Unit tgt;
int  exp;

this = This.AsDruid();
tgt = target.AsUnit();

while (tgt.IsValid()) {

	while (tgt.IsAlive()) {
		if(.IsEnemy(tgt) || !.CanSee(tgt) || tgt.experience <= .experience || tgt.InHolder() || .InHolder()) {
			Sleep(513);
			break;
		}
		if (!.InRange(tgt)) .GotoAttack(tgt, 5000, false, 2500);
		if (.InRange(tgt)) {
			.StartAnim(19, tgt.pos);
			Sleep(.TimeToActionMoment());
			if (tgt.IsAlive()) // fix the full expression evaluation
			if (!.IsEnemy(tgt) && .CanSee(tgt) && tgt.experience > .experience && !tgt.InHolder() && !.InHolder()) {
			  exp = .experience + (.inherentlevel + 3) / 4;
			  if (exp > tgt.experience) exp = tgt.experience;
			  .SetExperience(exp);
				CreateFeedback("Teach", this);
			}
			Sleep(.TimeToAnimFinish());
		}
	}

	tgt = .FindUnit2HTL(3);
}