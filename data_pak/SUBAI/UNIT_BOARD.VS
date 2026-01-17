// void, Obj This, Obj obj

Unit  this;
Ship  ship;

this = This.AsUnit;
ship = obj.AsShip;

ship.NotifyBoardUnit( this );
.AddCommand( true, "boardshipcommon", obj );