// void, Obj This, Obj other

Unit this;
this = This.AsUnit();
//.pr("The script should be modified to check if the unit is still visible");
while (other.IsAlive())
  {
	 if(.Goto(other,.sight-50,5000, true, 15000))
		Sleep(1500);
  }