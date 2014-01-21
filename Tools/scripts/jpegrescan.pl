#!/usr/bin/perl -ws
# jpegrescan by Loren Merritt
# Last updated: 2008-11-29
# This code is public domain.

sub jpegtran (@) {
	unless(system($ARGV[0], $strip ? ("-copy","none") : ("-copy","all"), @_) == 0) {
		if ($? == -1) {
			die "Error execute jpegtran: $!\n";
		}
		elsif ($? & 128) {
			die sprintf(
				"jpegtran died with signal %d, %s coredump\n",
				($? & 127),  ($? & 128) ? 'with' : 'without'
			);
		}
		else {
			print "jpegtran exited with ERRORLEVEL=" . ($? >> 8) . "\n";
		}
	}
}

# FIXME optimize order for either progressive transfer or decoding speed
sub canonize {
	my $txt = $prefix.$suffix.shift;
	$txt =~ s/\s*;\s*/;\n/g;
	$txt =~ s/^\s*//;
	$txt =~ s/ +/ /g;
	$txt =~ s/: (\d+) (\d+)/sprintf ": %2d %2d", $1, $2/ge;
	# treat u and v identically. I shouldn't need to do this, but with jpegtran overhead it saves 9% speed. cost: .008% bitrate.
	$txt =~ s/^2:.*\n//gm;
	$txt =~ s/^1:(.+)\n/1:$1\n2:$1\n/gm;
	# dc before ac, coarse before fine
	return join( "\n",
		sort {
			"$a\n$b" =~ /: *(\d+) .* (\d);\n.*: *(\d+) .* (\d);/ or die;
			!$3 <=> !$1 or $4 <=> $2 or $a cmp $b;
		}
		split( /\n/, $txt )
	);
}

sub try {
	my $txt = canonize(shift);
	my $rc;
	if (exists $memo{$txt}) {
		$rc = $memo{$txt};
	}
	else {
		open( my $io, "> $ftmp") or die "Error create $ftmp file: $!\n";
		print $io $txt;
		close $io;
		unlink $fout if (-f $fout);
		jpegtran("-scans", $ftmp, "-outfile", $fout, $jtmp);
		unless ($rc = -s $fout) {
			die "jpegtran output file zero size";
		}
		unless ($quiet) {
			print $verbose ? "$txt\n$rc\n\n" : ".";
		}
		$memo{$txt} = $rc;
	}
	return $rc;
}

sub triesn {
	my ($limit, @modes) = @_;
	my $overshoot = 0;
	my ($bmode, $bsize);
	foreach my $mode (@modes) {
		my $s = try($mode);
		if (!$bsize || $s < $bsize) {
			$bsize = $s;
			$bmode = $mode;
			$overshoot = 0;
		}
		elsif ($limit > 0 and ++$overshoot >= $limit) {
			last;
		}
	}
	return $bmode;
}

sub gen_modes {
	my $c = shift;
	my $str = shift;
	map {
		$_ => sprintf( "$c: 1 %d $str;$c: %d 63 $str;", $_, $_+1)
	} 2,5,8,12,18;
}

sub try_splits {
	my $c = shift;
	my $str = shift;
	my %n = gen_modes($c, $str);
	my $mode = triesn(2, "$c: 1 63 $str;", @n{2,8,5});
	if ($mode ne $n{8}) {
		return $mode;
	}
	else {
		return triesn(1, $mode, @n{12,18});
	}
}

sub get_stderr {
	my $code = shift;
	my $rc;
	if (ref $code eq 'CODE') {
		my $old_stderr;
		open $old_stderr, ">&", STDERR;
		open STDERR, ">", $otmp;
		$code->(@_);
		open STDERR, ">&", $old_stderr;
		$rc = do {
			local $/;
			open(my $io, $otmp);
			<$io>;
		};
		unlink( $otmp ) if (-f $otmp);
	}
	return $rc;
}

# sub main {
unless (scalar @ARGV == 3) {
	die "usage: jpegrescan /path/to/jpegtran.exe in.jpg out.jpg\ntries various progressive scan orders\n";
}

$fin = $ARGV[1];
$fout = $ARGV[2];
$verbose = 0;
$quiet = 0;
$strip = 0;
$ftmp = "$fout-$$.scan";
$jtmp = "$fout-$$.jpg";
$otmp = "$fout-$$.out";
undef $/;
$|=1;
$prefix = "";
$suffix = "";

# convert the input to baseline, just to make all the other conversions faster
# FIXME there's still a bunch of redundant computation in separate calls to jpegtran
my $stderr = get_stderr(
	sub {
		jpegtran("-v", "-optimize", "-outfile", $jtmp, $fin);
	}	
);

if ($stderr =~ /components=(\d+)/) {
	my $rgb;
	if ($1 == 3) {
		$rgb = 1;
		# 012 helps very little
		# 0/12 and 0/1/2 are pretty evenly matched in frequency, but 0/12 wins in total size if every image had to use the same mode
		# dc refinement passes never help
		$dc = triesn(0, "0: 0 0 0 0;1: 0 0 0 0;2: 0 0 0 0;" );
		# jpegtran won't let me omit dc entirely, but I can at least quantize it away to make the rest of the tests faster.
		$prefix = "0 1 2: 0 0 0 9;";
	}
	elsif ($1 == 1) {
		$rgb = 0;
		$dc = "0: 0 0 0 0;";
		$prefix = "0: 0 0 0 9;";
	}
	else {
		# die "File $fin is not RGB or grayscale\n"
		jpegtran("-copy", "all", "-progressive", $fin, $fout);
		unlink(
			$jtmp,
			$ftmp,
		);
		exit
	}
	foreach my $c ( 0 .. $rgb ) {
		my $max_i = $c ? 2 : 3;
		my $ml = "";
		my @modes;
		my $refine;
		
		foreach my $i ( 0 .. $max_i ) {
			push @modes, "$c: 1 8 0 $i;$c: 9 63 0 $i;".$ml;
			$ml .= sprintf("$c: 1 63 %d %d;", $i+1, $i);
		}
		$refine = triesn(1, @modes);
		$refine =~ s/.* (0 \d);//;
		$ac .= $refine . try_splits($c, $1);
	}
	# luma can make use of up to 3 refinement passes.
	# chroma can make use of up to 2 refinement passes.
	# refinement passes have some chance of being split (luma: 4%,4%,4%. chroma: 20%,8%) but the total bit gain is negligible.
	# msb pass should almost always be split (luma: 87%, chroma: 81%).
	# I have no theoretical reason for this list of split positions, they're just the most common in practice.
	# splitting into 3 ections is often slightly better, but the total number of bits saved is negligible.
	# FIXME: penalize lots of refinement passes because it's slower to decode. if so, then also force overwrite if bigger than the input.
	$prefix = "";
	%memo = ();
	$mode = $dc.$ac;
	$mode = canonize($mode);
	try($mode);
	$size = $memo{$mode};
	print "\n$mode\n$size\n" unless ($quiet);
	unlink(
		$jtmp,
		$ftmp,
	);
}
else {
	die "Invalud output from jpegtran\n";
}