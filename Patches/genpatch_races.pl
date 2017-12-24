#!/usr/bin/perl
use strict;
use warnings;

use lib "../../_lib";
use RWPatcher::Animals;
use XML::Simple;
use File::Basename qw(basename dirname);

#
# Generate patch to make entitiesauria races compatible with Combat Extended, b18.
#

# Get entity tool melee bodyparts from mod source xml
# For each, patch file will be ./<base-dir-name>/<file.xml>
# Source may end with (-REF)?.(txt|xml), which will be replaced with ".xml".
my @SOURCEFILES = qw(
    ../../1136958577/Defs/ThingDefs_Races/Races_Animal_Dinosauria.xml
);
my $SOURCEMOD = 'Dinosauria';  # Only patch if this mod is loaded (leave undefined to skip)

# DEFAULT values not in source xml from entitiesauria
my %DEFAULT = (
    bodyShape => "Quadruped",
    MeleeDodgeChance => 0.08,	# Elephant
    MeleeCritChance => 0.79,	# Elephant
);

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

my $patcher = new RWPatcher::Animals(
    sourcemod   => 'Dinosauria',
    sourcefiles => \@SOURCEFILES,
    cedata      => \%PATCHABLES,
) or die("ERR: Failed new RWPatcher::Animals: $!\n");

$patcher->generate_patches or die("ERR: generate_patches: $!\n");

exit(0);

__END__

