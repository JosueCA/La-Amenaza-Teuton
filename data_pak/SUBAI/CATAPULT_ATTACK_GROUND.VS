// void, Obj me, point pt

Catapult this;
point ptNew;
int ttw;
bool bRotated;

this = me.AsCatapult();

if (!.IsValid) return;
if (!.InRange(pt)) return;


.ClearTarget();
bRotated = false;
while (.IsAlive)
{
	if (.CmdCount() > 1)
		break;

	if (.settlement.UnitsCount <= 0) break;
	ttw = .AttackWait();
	if (ttw > 0) Sleep(ttw);
	
	if (bRotated == false)
	{
		.RotateTo(pt);
		bRotated = true;
	}
	ptNew = GetCatapultAttackPoint(pt);

	
	if (!.IsAlive || .settlement.UnitsCount == 0) return;
	.Attack(ptNew);
}
