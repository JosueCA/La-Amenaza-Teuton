// void, Obj gate

Gate this;
this = gate.AsGate();

if (.IsValid() == false)
{
  pr("Ivalid gate!");
  while(1) Sleep(1000);  // fixme!!
}

while(1)
{
  .LookAround(350);
  if (.AreEnemiesAround())
    .CloseNow();
  else
    if (.AreFriendsAround())
	  .OpenNow();
	else
	  .CloseNow();
  Sleep(500);
}