//void, Obj owner
Unit this;

this = owner.AsUnit();
if (.health > .maxhealth*9/10) { //if more than 90%
	CreateFeedback("Damage1", .AsUnit());
	.SetLevel(.inherentlevel+1);
	.Damage(.health - .maxhealth/10 - 5); //set to 10%
	ItemUsed(1);
}