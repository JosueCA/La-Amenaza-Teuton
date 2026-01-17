// void, Obj This 

Settlement this;
this = This.AsBuilding.settlement;

if (.gold > .loan) {
	.SetGold(.gold - .loan);
	.SetLoan(0);
} else {
	.SetLoan(.loan - .gold);
	.SetGold(0);
}
