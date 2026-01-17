$s= <<SCRIPTCLASS
<class id="wall_name" cpp_class="CVXBuilding" parent="Building" entity="assets/entities/tobj/wall_ent.ent.xml">

<properties health="10000" maxhealth="10000"/>

</class>
SCRIPTCLASS
;

opendir DIR, '.';
while($_ = readdir(DIR)) {
	if( m/(.*?)\.ent\.xml/ ) {
		$name = $1;
		open FL, ">$name.sc.xml";
		$snow = $s;
		$snow =~ s/wall_name/$name/;
		$snow =~ s/wall_ent/$name/;
		print FL $snow;
		close FL;
		print "$name.sc.xml"; print "\n";
	}
}


