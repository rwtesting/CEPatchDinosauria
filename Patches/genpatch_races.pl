#!/usr/bin/perl
use strict;
use warnings;

use lib $ENV{RWPATCHER_LIB};
use RWPatcher::Animals;

#
# Generate patch to make Dinosauria races compatible with Combat Extended, b18.
#

# Get entity tool melee bodyparts from mod source xml
    # For each, patch file will be ./<base-dir-name>/<file.xml>
# Source may end with (-REF)?.(txt|xml), which will be replaced with ".xml".
my @SOURCEFILES = qw(
    ../../1136958577/Defs/ThingDefs_Races/Races_Animal_Dinosauria.xml
);
my $SOURCEMOD = 'Dinosauria';  # Only patch if this mod is loaded (leave undefined to skip)

# DEFAULT values not in source xml from Dinosauria
my %DEF = (
    bodyShape => "Quadruped",
    MeleeDodgeChance => 0.08,	# Elephant
    MeleeCritChance => 0.79,	# Elephant

    # baseHealthScale: birds=0.8x vanilla, bears=1.2x vanilla (general guide)
    # (dinosauria already seems to keep relative base health per type, so not changing this)
    baseHealthScale   => 3.6,	# Elephant (Thrumbo = 13, Megasloth = 3.6) <-- no CE changes

    # Armor values exist in vanilla but need to be adjusted for CE
    # (ex. CE Thrumbo is ridiculously tanky).
    #
    ArmorRating_Blunt => 0.14,	# Elephant/Megasloth = 0.1,   Thrumbo = 0.2
    ArmorRating_Sharp => 0.16,	# Elephant/Megasloth = 0.125, Thrumbo = 0.3
);

# Vanilla armor is done in 3 sets (from the Dinosauria source file).
# Converting to CE, we'll keep the same multipliers.
# The dinos will have the same armor relative to each other,
# with a lower base (the %DEF settings above).
#
# 1. Base     (2.7 blunt, 2.5 sharp)
# 2. Tanky #1 (Base*1.19 blunt / Base *1.2 sharp)
# 3. Tanky #2 (Base*1.56 blunt / Base *1.2 sharp)
#
$DEF{_Armor_Tank1_B} = _ffmt(1.19*$DEF{ArmorRating_Blunt}); # armor for Tanky #1 - blunt
$DEF{_Armor_Tank1_S} = _ffmt(1.20*$DEF{ArmorRating_Sharp}); # armor for Tanky #1 - slashing
$DEF{_Armor_Tank2_B} = _ffmt(1.56*$DEF{ArmorRating_Blunt}); # armor for Tanky #2 - blunt
$DEF{_Armor_Tank2_S} = _ffmt(1.20*$DEF{ArmorRating_Sharp}); # armor for Tanky #2 - slashing

# CE values by type
my %VALS_RAPTOR   = (MeleeDodgeChance => 0.20, MeleeCritChance => 0.50); # like Entelodont
my %VALS_SMRAPTOR = (MeleeDodgeChance => 0.29, MeleeCritChance => 0.40); # like Gigantopithecus
my %VALS_TANK     = (MeleeDodgeChance => 0.30, MeleeCritChance => 0.40); # like Smilodon
my %VALS_BIGVEG   = (MeleeDodgeChance => 0.09, MeleeCritChance => 0.80); # like Mammoth/Elephant
my %VALS_MEDVEG   = (MeleeDodgeChance => 0.10, MeleeCritChance => 0.40); # like Megasloth
my %VALS_SMVEG    = (MeleeDodgeChance => 0.29, MeleeCritChance => 0.22); # like Caribou
my %VALS_TINY     = (MeleeDodgeChance => 0.45, MeleeCritChance => 0.15); # like ??

# hash of values per animal (using values from a17 MF+CE patch)
# required: dodge, crit (not defined in vanilla)
# optional: bodyShape (else default)
# optional: any/all from @ARMORTYPES
# optional: baseHealthScale
my %PATCHABLES = (

    # Raptors - fast + hit hard - model after Enelodont a17
    TyrannosaurusRex => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 7
    },
    Yutyrannus => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 6.5
    },
    Carnotaurus => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 5.5
    },
    Allosaurus => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 5.5
    },
    Spinosaurus => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 7
    },

    # Raptors, small
    Utahraptor => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 2.5
    },
    Dakotaraptor => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 2.5
    },
    Dilophosaurus => {
	%VALS_RAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 2.5
    },
    Velociraptor => {
	%VALS_SMRAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 1.5
    },
    Compsognathus => {
	%VALS_SMRAPTOR,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 0.75
    },

    # Tanks
    Ankylosaurus => {
	%VALS_TANK,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 3.5
    },
    Minmi => {
	%VALS_TANK,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 2.75
    },
    Pachycephalosaurus => {
	%VALS_TANK,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 4
    },
    Stygimoloch => {
	%VALS_TANK,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 2
    },
    Stegosaurus => {
	%VALS_TANK,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 4.2
    },
    Triceratops => {
	%VALS_TANK,
        ArmorRating_Blunt => $DEF{_Armor_Tank2_B},	# vanilla 4.2
        ArmorRating_Sharp => $DEF{_Armor_Tank2_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 5.2
    },

    # Big Vegetarians
    Brachiosaurus => {
	%VALS_BIGVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 10
    },
    Brontosaurus => {
	%VALS_BIGVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 10
    },
    Diplodocus => {
	%VALS_BIGVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 10
    },

    # Medium Vegetarians
    Baryonyx => {
	%VALS_MEDVEG,
        ArmorRating_Blunt => $DEF{ArmorRating_Blunt},	# vanilla 2.7
        ArmorRating_Sharp => $DEF{ArmorRating_Sharp},	# vanilla 2.5
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 7
    },
    Deinocheirus => {
	%VALS_MEDVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 4
    },
    Therizinosaurus => {
	%VALS_MEDVEG,
	bodyShape => 'Birdlike',
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 4
    },
    Gallimimus => {
	%VALS_SMVEG,
	bodyShape => 'Birdlike',
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 3.7
    },
    Quetzalcoatlus => {
	%VALS_MEDVEG,
	bodyShape => 'Birdlike',
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 5.5
    },

    # Small
    Gigantoraptor => {
	%VALS_SMVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 3
    },
    Iguanodon => {
	%VALS_SMVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 4
    },
    Parasaur => {
	%VALS_SMVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 4
    },
    Corythosaurus => {
	%VALS_SMVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 4
    },
    Pteranodon => {
	%VALS_SMVEG,
	bodyShape => 'Birdlike',
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 1.5
    },
    Magyarosaurus => {
	%VALS_SMVEG,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 3.7
    },

    # Tiny
    Dryosaurus => {
        %VALS_TINY,
        ArmorRating_Blunt => $DEF{_Armor_Tank1_B},	# vanilla 3.2
        ArmorRating_Sharp => $DEF{_Armor_Tank1_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 2
    },
    Protoceratops => {
        %VALS_TINY,
        ArmorRating_Blunt => $DEF{_Armor_Tank2_B},	# vanilla 4.2
        ArmorRating_Sharp => $DEF{_Armor_Tank2_S},	# vanilla 3
	#baseHealthScale   => $DEF{baseHealthScale},	# vanilla 2
    },
);

my $patcher;
foreach my $sourcefile (@SOURCEFILES)
{
    $patcher = new RWPatcher::Animals(
        sourcemod  => $SOURCEMOD,
        sourcefile => $sourcefile,
        cedata     => \%PATCHABLES,
	expected_parents => [ "AnimalThingBase" ],
    ) or die("ERR: Failed new RWPatcher::Animals: $!\n");

    $patcher->generate_patches();
}

exit(0);

# handle floats for rimworld:
# - round up
# - 2 decimal places
sub _ffmt
{
    return sprintf("%.2f", $_[0]);
}

__END__

