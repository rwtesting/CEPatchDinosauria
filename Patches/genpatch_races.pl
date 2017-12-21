#!/usr/bin/perl
use strict;
use warnings;

# print to this output patch file, overwrite existing
my $OUTFILE = "./ThingDefs_Races/Races_Animal_Dinosauria.xml";
open(OUTFILE, ">", $OUTFILE) or die("ERR: open/write $OUTFILE: $!\n");

# output CE patch code for each listed dino, in order:
# (match order to dinosauria xml for easier comparison)
#
my @DINOS = qw(
    TyrannosaurusRex
    Yutyrannus
    Carnotaurus
    Allosaurus
    Spinosaurus
    Baryonyx
    Ankylosaurus
    Minmi
    Brachiosaurus
    Brontosaurus
    Diplodocus
    Magyarosaurus
    Utahraptor
    Dakotaraptor
    Dilophosaurus
    Velociraptor
    Compsognathus
    Gallimimus
    Gigantoraptor
    Iguanodon
    Parasaur
    Corythosaurus
    Deinocheirus
    Therizinosaurus
    Pachycephalosaurus
    Stygimoloch
    Dryosaurus
    Stegosaurus
    Triceratops
    Protoceratops
    Quetzalcoatlus
    Pteranodon
);

# DEFAULT values not in source xml from Dinosauria
my %DEFAULT = (
    bodyShape => "Quadruped",
    MeleeDodgeChance => 0.08,	# Elephant
    MeleeCritChance => 0.79,	# Elephant
);

# armor penetration DEFAULT per bodypart
my $DEFAULT_AP = 0.15;		# default ap for unlisted bodyparts
my %DEFAULT_AP = (
    HeadAttackTool => 0.133,	# Elephant
    TailAttackTool => 0.17,	# (like a leg?)

    HornAttackTool => 0.457,	# Thrumbo (should differentiate between horncut/hornstab
    Teeth          => 0.25,	# Smilodon
    Beak           => 0.3,	# Titanis

    FrontLeftLeg   => 0.17,	# Elephant
    FrontRightLeg  => 0.17,	# Elephant

    LeftLeg        => 0.17,
    RightLeg       => 0.17,

    LeftLegClawAttackTool  => 0.227,	# Megascarab headclaw
    RightLegClawAttackTool => 0.227,	# Megascarab headclaw
    LeftArmClawAttackTool  => 0.227,	# Megascarab headclaw
    RightArmClawAttackTool => 0.227,	# Megascarab headclaw

    
);

# CE values by type
my %VALS_RAPTOR   = (MeleeDodgeChance => 0.20, MeleeCritChance => 0.50); # like Entelodont
my %VALS_SMRAPTOR = (MeleeDodgeChance => 0.29, MeleeCritChance => 0.40); # like Gigantopithecus
my %VALS_TANK     = (MeleeDodgeChance => 0.30, MeleeCritChance => 0.40); # like Smilodon
my %VALS_BIGVEG   = (MeleeDodgeChance => 0.09, MeleeCritChance => 0.80); # like Mammoth/Elephant
my %VALS_MEDVEG   = (MeleeDodgeChance => 0.10, MeleeCritChance => 0.40); # like Megasloth
my %VALS_SMVEG    = (MeleeDodgeChance => 0.29, MeleeCritChance => 0.22); # like Caribou
my %VALS_TINY     = (MeleeDodgeChance => 0.45, MeleeCritChance => 0.15); # like ??

# hash of values per dino
# tools are bodyparts from <tools> entry in source xml
# FIXME: Read tools bodyparts from source XML instead of hardcoding
my %DINOS = (

    # Raptors - fast + hit hard - model after Enelodont a17
    TyrannosaurusRex	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLeg RightLeg Teeth ) ],
    },
    Yutyrannus	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLeg RightLeg Teeth ) ],
    },
    Carnotaurus	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLeg RightLeg Teeth ) ],
    },
    Allosaurus	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLeg RightLeg Teeth ) ],
    },
    Spinosaurus	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLeg RightLeg Teeth ) ],
    },
    Utahraptor	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLegClawAttackTool RightLegClawAttackTool Teeth ) ],
    },
    Dakotaraptor	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLegClawAttackTool RightLegClawAttackTool Teeth ) ],
    },
    Dilophosaurus	=> {
	%VALS_RAPTOR,
	tools => [ qw( LeftLegClawAttackTool RightLegClawAttackTool Teeth ) ],
    },

    # Raptors, small
    Compsognathus	=> {
	%VALS_SMRAPTOR,
	tools => [ qw( LeftLegClawAttackTool RightLegClawAttackTool Teeth ) ],
    },
    Velociraptor	=> {
	%VALS_SMRAPTOR,
	tools => [ qw( LeftLegClawAttackTool RightLegClawAttackTool Teeth ) ],
    },

    # Tanks
    Ankylosaurus	=> {
	%VALS_TANK,
	tools => [ qw( TailAttackTool HeadAttackTool ) ],
    },
    Minmi	=> {
	%VALS_TANK,
	tools => [ qw( TailAttackTool HeadAttackTool ) ],
    },
    Pachycephalosaurus	=> {
	%VALS_TANK,
	tools => [ qw( HeadAttackTool ) ],
    },
    Stygimoloch	=> {
	%VALS_TANK,
	tools => [ qw( HeadAttackTool ) ],
    },
    Stegosaurus	=> {
	%VALS_TANK,
	tools => [ qw( TailAttackTool HeadAttackTool ) ],
    },
    Triceratops	=> {
	%VALS_TANK,
	tools => [ qw( HornAttackTool HeadAttackTool ) ],
    },

    # Big Vegetarians
    Brachiosaurus	=> {
	%VALS_BIGVEG,
	tools => [ qw( TailAttackTool FrontLeftLeg FrontRightLeg  ) ],
    },
    Brontosaurus	=> {
	%VALS_BIGVEG,
	tools => [ qw( TailAttackTool FrontLeftLeg FrontRightLeg  ) ],
    },
    Diplodocus	=> {
	%VALS_BIGVEG,
	tools => [ qw( TailAttackTool FrontLeftLeg FrontRightLeg  ) ],
    },

    # Medium Vegetarians
    Baryonyx	=> {
	%VALS_MEDVEG,
	tools => [ qw( LeftLeg RightLeg Teeth ) ],
    },
    Deinocheirus	=> {
	%VALS_MEDVEG,
	tools => [ qw( LeftArmClawAttackTool RightArmClawAttackTool HeadAttackTool ) ],
    },
    Therizinosaurus	=> {
	%VALS_MEDVEG,
	tools => [ qw( LeftArmClawAttackTool RightArmClawAttackTool HeadAttackTool ) ],
    },
    Quetzalcoatlus	=> {
	%VALS_MEDVEG,
	tools => [ qw( Beak ) ],
    },

    # Small
    Magyarosaurus	=> {
	%VALS_SMVEG,
	tools => [ qw( TailAttackTool FrontLeftLeg FrontRightLeg  ) ],
    },
    Gallimimus	=> {
	%VALS_SMVEG,
	tools => [ qw( LeftLeg RightLeg ) ],
    },
    Gigantoraptor	=> {
	%VALS_SMVEG,
	tools => [ qw( LeftLeg RightLeg ) ],
    },
    Iguanodon	=> {
	%VALS_SMVEG,
	tools => [ qw( HeadAttackTool ) ],
    },
    Parasaur	=> {
	%VALS_SMVEG,
	tools => [ qw( HeadAttackTool ) ],
    },
    Corythosaurus	=> {
	%VALS_SMVEG,
	tools => [ qw( HeadAttackTool ) ],
    },
    Pteranodon	=> {
	%VALS_SMVEG,
	tools => [ qw( Beak ) ],
    },

    # Tiny
    Dryosaurus	=> {
        %VALS_TINY,
	tools => [ qw( HeadAttackTool ) ],
    },
    Protoceratops	=> {
        %VALS_TINY,
	tools => [ qw( HeadAttackTool ) ],
    },
);

# print header
print OUTFILE (<<EOF);
<?xml version="1.0" encoding="utf-8" ?>
<Patch>

  <!-- Warning: This will break if Dinosauria author moves dino defs to separate xml files.
       You would need to create 1 PatchOperationSequence per xml file patched (or per dino)
       (sequence = 1st xpath locates file for sequence = faster load times). -->

  <!-- The script used to generate this file can easily be updated to 1 sequence per dino. -->

  <Operation Class="PatchOperationSequence">
  <success>Always</success>
  <operations>

EOF

# print one patch per dino name
my($bodypart, $ap);
foreach my $dino (@DINOS)
{
    chomp($dino);

    # Auto-generate a template for each $dino name.
    # (use one sequence per dino to reduce load times, short circuit)
    # Load times: Defs/ThingDef < /Defs/ThingDef << */ThingDef/ <<< //ThingDef/
    print OUTFILE (<<EOF);

  <!-- ========== $dino ========== -->

  <li Class="PatchOperationAddModExtension">
    <xpath>Defs/ThingDef[defName="$dino"]</xpath>
    <value>
      <li Class="CombatExtended.RacePropertiesExtensionCE">
        <bodyShape>$DEFAULT{'bodyShape'}</bodyShape>
      </li>
    </value>
  </li>

  <li Class="PatchOperationAdd">
    <xpath>*/ThingDef[defName="$dino"]/statBases</xpath>
	<value>
		<MeleeDodgeChance>$DINOS{$dino}->{'MeleeDodgeChance'}</MeleeDodgeChance>
		<MeleeCritChance>$DINOS{$dino}->{'MeleeCritChance'}</MeleeCritChance>
	</value>
  </li>

EOF

    # For each bodypartgroup listed for this dino, add CE attribute + armor pen value
    foreach $bodypart ( @{ $DINOS{$dino}->{tools} } )
    {
        $ap = $DEFAULT_AP{$bodypart} || $DEFAULT_AP;
        print OUTFILE (<<EOF);
  <li Class="PatchOperationAttributeSet">
    <xpath>*/ThingDef[defName="$dino"]/tools/li[linkedBodyPartsGroup="$bodypart"]</xpath>
    <attribute>Class</attribute>
    <value>CombatExtended.ToolCE</value>
  </li>

  <li Class="PatchOperationAdd">
    <xpath>*/ThingDef[defName="$dino"]/tools/li[linkedBodyPartsGroup="$bodypart"]</xpath>
    <value>
	<armorPenetration>$ap</armorPenetration>
    </value>
  </li>

EOF
    }
}

# print closer
print OUTFILE (<<EOF);
  </operations> <!-- End sequence -->
  </Operation>  <!-- End sequence -->

</Patch>

EOF
close(OUTFILE) or warn("WARN: close $OUTFILE: $!\n");

exit(0);

__END__


