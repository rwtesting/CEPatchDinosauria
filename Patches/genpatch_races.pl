#!/usr/bin/perl
use strict;
use warnings;

use XML::Simple;

#
# Generate patch to make Dinosauria races compatible with Combat Extended, b18.
#

# Get dino tool melee bodyparts from mod source xml
my $SOURCEFILE = "../../1136958577/Defs/ThingDefs_Races/Races_Animal_Dinosauria.xml";
# print to this output patch file, overwrite existing
my $OUTFILE = "./ThingDefs_Races/Races_Animal_Dinosauria.xml";

# DEFAULT values not in source xml from Dinosauria
my %DEFAULT = (
    bodyShape => "Quadruped",
    MeleeDodgeChance => 0.08,	# Elephant
    MeleeCritChance => 0.79,	# Elephant
);

# armor penetration DEFAULT per bodypart
my $DEFAULT_AP = 0.15;		# default ap for unlisted bodyparts
my %DEFAULT_AP = (
    HeadAttackTool => 0.13,	# Elephant
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
    TyrannosaurusRex => {
	%VALS_RAPTOR,
    },
    Yutyrannus => {
	%VALS_RAPTOR,
    },
    Carnotaurus => {
	%VALS_RAPTOR,
    },
    Allosaurus => {
	%VALS_RAPTOR,
    },
    Spinosaurus => {
	%VALS_RAPTOR,
    },
    Utahraptor => {
	%VALS_RAPTOR,
    },
    Dakotaraptor => {
	%VALS_RAPTOR,
    },
    Dilophosaurus => {
	%VALS_RAPTOR,
    },

    # Raptors, small
    Compsognathus => {
	%VALS_SMRAPTOR,
    },
    Velociraptor => {
	%VALS_SMRAPTOR,
    },

    # Tanks
    Ankylosaurus => {
	%VALS_TANK,
    },
    Minmi => {
	%VALS_TANK,
    },
    Pachycephalosaurus => {
	%VALS_TANK,
    },
    Stygimoloch => {
	%VALS_TANK,
    },
    Stegosaurus => {
	%VALS_TANK,
    },
    Triceratops => {
	%VALS_TANK,
    },

    # Big Vegetarians
    Brachiosaurus => {
	%VALS_BIGVEG,
    },
    Brontosaurus => {
	%VALS_BIGVEG,
    },
    Diplodocus => {
	%VALS_BIGVEG,
    },

    # Medium Vegetarians
    Baryonyx => {
	%VALS_MEDVEG,
    },
    Deinocheirus => {
	%VALS_MEDVEG,
    },
    Therizinosaurus => {
	%VALS_MEDVEG,
    },
    Quetzalcoatlus => {
	%VALS_MEDVEG,
	bodyShape => 'Birdlike',
    },

    # Small
    Magyarosaurus => {
	%VALS_SMVEG,
    },
    Gallimimus => {
	%VALS_SMVEG,
    },
    Gigantoraptor => {
	%VALS_SMVEG,
    },
    Iguanodon => {
	%VALS_SMVEG,
    },
    Parasaur => {
	%VALS_SMVEG,
    },
    Corythosaurus => {
	%VALS_SMVEG,
    },
    Pteranodon => {
	%VALS_SMVEG,
	bodyShape => 'Birdlike',
    },

    # Tiny
    Dryosaurus => {
        %VALS_TINY,
    },
    Protoceratops => {
        %VALS_TINY,
    },
);

# Open source/output files
# Open source/output files
my $source =  XMLin($SOURCEFILE, ForceArray => [qw(ThingDef li)])
    or die("ERR: read source xml $SOURCEFILE: $!\n");
open(OUTFILE, ">", $OUTFILE)
    or die("Failed to open/write $OUTFILE: $!\n");

# Header 
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

#
# Step through source xml.
# Generate a template for each $dino found.
# If dino is found that we don't have CE values for, warn and skip.
#
# (use one sequence per file to reduce load times, short circuit)
# Load times: Defs/ThingDef < /Defs/ThingDef << */ThingDef/ <<< //ThingDef/
#
my($dino, $tool, $ap, $bodyshape);
foreach my $entry ( @{$source->{ThingDef}} )
{
    # Skip non-dinos and unknown dinos
    next unless ($dino = $entry->{defName}) && $entry->{ParentName} eq "AnimalThingBase";

    if (!exists $DINOS{$dino})
    {
        warn(<<EOF);
WARN: New or unknown dino found. Skipping because no CE data:

Name: $dino
Desc:
$entry->{description}

EOF
        next;
    }

    # Start patch
    print OUTFILE (<<EOF);
  <!-- ========== $dino ========== -->

EOF

    # For each bodypartgroup listed for this dino, add CE attribute + armor pen value
    if ($entry->{tools}->{li})
    {
        foreach $tool ( @{ $entry->{tools}->{li} } )
        {
            $ap = $DEFAULT_AP{$tool->{linkedBodyPartsGroup}} || $DEFAULT_AP;
            print OUTFILE (<<EOF);
    <li Class="PatchOperationAttributeSet">
    <xpath>Defs/ThingDef[defName="$dino"]/tools/li[linkedBodyPartsGroup="$tool->{linkedBodyPartsGroup}"]</xpath>
        <attribute>Class</attribute>
        <value>CombatExtended.ToolCE</value>
    </li>

    <li Class="PatchOperationAdd">
    <xpath>Defs/ThingDef[defName="$dino"]/tools/li[linkedBodyPartsGroup="$tool->{linkedBodyPartsGroup}"]</xpath>
    <value>
        <armorPenetration>$ap</armorPenetration>
    </value>
    </li>

EOF
        }
    }

    # Add bodyShape and melee dodge/crit
    $bodyshape = $DINOS{$dino}->{bodyShape} || $DEFAULT{bodyShape};
    print OUTFILE (<<EOF);
    <li Class="PatchOperationAddModExtension">
    <xpath>Defs/ThingDef[defName="$dino"]</xpath>
    <value>
        <li Class="CombatExtended.RacePropertiesExtensionCE">
            <bodyShape>$bodyshape</bodyShape>
        </li>
    </value>
    </li>

    <!-- List dodge/crit last so that we know all previous sequence entries succeeded.
         These values are easy to check in-game. -->
    <li Class="PatchOperationAdd">
    <xpath>Defs/ThingDef[defName="$dino"]/statBases</xpath>
    <value>
        <MeleeDodgeChance>$DINOS{$dino}->{MeleeDodgeChance}</MeleeDodgeChance>
        <MeleeCritChance>$DINOS{$dino}->{MeleeCritChance}</MeleeCritChance>
    </value>
    </li>

EOF
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

=head1 NOTES

=head2 Defined in BodyPartGroups_Dinosaurs.xml

    TailAttackTool
    LeftArmClawAttackTool
    RightArmClawAttackTool
    LeftLegClawAttackTool
    RightLegClawAttackTool
    LeftLeg
    RightLeg

=cut

