//void, Obj This

Obj target;
Catapult this;
bool bRotated;
int ttw;
point ptNew;
int sleeptime;//constant

this = This.AsCatapult;
if(!.IsValid) return;

sleeptime = 1000;

while (.IsAlive)
{
	if (.CmdCount() > 1)
		return;

	if (.settlement.UnitsCount <= 0) break;
  target = .GetCurrentTarget;
	if (!target.IsValid) target = .BestTarget();
	if(target.IsValid())
	{
		bRotated = false;
		while(target.IsAlive && .IsEnemy(target) && .IsValidTarget(target))
		{
			if (.CmdCount() > 1)
				return;

			ttw = .AttackWait;
			if (ttw > 0) Sleep(ttw);
			
			ptNew = .GetPointOnTarget(target);
			if (!.InRange(ptNew)) return;
			ptNew = GetCatapultAttackPoint(ptNew);
			if (bRotated == false)
			{
				.RotateTo(ptNew);
				bRotated = true;
			}
			if (!.IsAlive || .settlement.UnitsCount == 0)
			{
				.ClearTarget();
				return;
			}
			.SetTarget( target );
			.Attack(ptNew);
		}
		.ClearTarget();
	}
	Sleep(sleeptime);
}