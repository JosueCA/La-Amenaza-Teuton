// void, Obj This, Obj other

Unit this;
int range;
this = This.AsUnit();

if (this.sight > 200)
{
	range = this.sight - 100;
}
else
{
	range = 100;
}

if (other.IsAlive())
{
	while (!.Goto(other,range,5000,true,15000));
	if (.IsAlive() && other.IsAlive())
	{
		EndConvSetup(This,other);
	}
}