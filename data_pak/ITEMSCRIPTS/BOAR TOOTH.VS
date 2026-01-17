//void, Obj owner, Obj target
int nHealthToGive, nHealthToTake;
if(!target.AsUnit.IsValid)
{
	UserNotification("unit target only", "", owner.pos, owner.player);
	return;
}
if(!owner.IsEnemy(target))
{
	UserNotification("enemy target only", "", owner.pos, owner.player);
	return;
}
if(owner.DistTo(target) < GetConst("BoarToothUseRadius"))
{
	nHealthToGive = owner.health - owner.maxhealth/5; //20%

	if (nHealthToGive>0) 
	{
		if (target.AsHero().IsValid()) 
		{
			nHealthToTake = target.health - target.maxhealth/2; //50%
		} else 
		{
			nHealthToTake = target.health; //may be killed if ordinary unit
		}
		if (nHealthToTake <= 0) return;
		if (nHealthToTake > nHealthToGive) 
		{
			target.Damage(nHealthToGive);
			owner.Damage(nHealthToGive);
		} else 
		{
			target.Damage(nHealthToTake);
			owner.Damage(nHealthToTake);
		}
		CreateFeedback("Lightning", target.AsUnit());
		//CreateFeedback("Lightning", owner.AsUnit()); 
	}
} else {
	owner.SetCommand("boar_tooth_use", target);
}	
