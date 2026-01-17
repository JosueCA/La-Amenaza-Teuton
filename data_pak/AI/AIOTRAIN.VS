// void, int nSetIdx, str UnitType, int nCount

return; /* obsolette
int      i;
Barrack  brk;
str      cmd;
point    ptDummy;
Obj      objDummy;

brk = GetBestBarrackForTrain( nSetIdx );
if( brk.IsValid() == false ) return;
cmd = GetTrainCmdByUnitType( UnitType );
for( i = 0; i < nCount; i+=1 )
{
	brk.ExecCmd( cmd, ptDummy, objDummy, false );
}
*/