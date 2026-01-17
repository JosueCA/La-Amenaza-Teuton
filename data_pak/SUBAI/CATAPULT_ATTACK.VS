// void, Obj me, Obj target

Catapult  this;
point     ptNew;
int       ttw;
bool      bRotated;

this = me.AsCatapult();
if (!.IsValid) return;
bRotated = false;

.SetTarget( target );
while (.IsAlive)
{
	if (.CmdCount() > 1)
		break;

	if (.settlement.UnitsCount <= 0) break;
	ttw = .AttackWait;
	if (ttw > 0) Sleep(ttw);

	if (!target.IsValid) return;
	if (!target.IsAlive || !.IsEnemy(target) || !.IsValidTarget(target)) return;
	ptNew = .GetPointOnTarget(target);
	if (!.InRange(ptNew)) return;
	if (bRotated == false){ //rotate to the object the user clicked
		.RotateTo(ptNew);
		bRotated = true;
	}
	ptNew = GetCatapultAttackPoint(ptNew);
	
	if (!.IsAlive || .settlement.UnitsCount == 0) break;
	.Attack(ptNew);
}
.ClearTarget();