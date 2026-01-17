// void, Obj me

Unit this;
  
this = me.AsUnit();

while (!.Stop(1000));

//.pr("peaceful::idle: started");
while(1)
{
  if (.Stop(2000)) {
	  //.pr("peaceful::idle: idling");
	  .Idle(2000);
  }
}
