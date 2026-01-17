// void, Obj This, Obj other

Unit this;
this = This.AsUnit();
//.pr("The script should be modified to check if the unit is still visible");

while (other.IsAlive()) {
	if(.Goto(other,20,5000,false,20000))
		break;
}
