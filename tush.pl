#!/usr/bin/perl
#
#
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;
use POSIX;

# BREEZLY_POD_BEGIN
# WARNING: DO NOT modify the pod directly!
# Generated from the breezly_defs by breezly.pl version 3.4
# on Sat Jul 27 18:20:24 2024.
=head1 NAME

B<tush.pl> - run a job in the background, with finesse.

=head1 VERSION

version 1.2 of tush.pl released on Sat Jul 27 18:20:24 2024

=head1 SYNOPSIS

B<tush.pl> [options] <cmd>...

Options:

    -help                   brief help message
    -man                    full documentation
    -tushfind               find various processes and output files, various ways
    -tushtail               tail the set of specified files
    -tushnotail             dispatch job without auto tail
    -tushclean              clean the specified directory
    -tushalmanack           get most recent almanack
    -tushstatistics         get the statistics for the named job
    -tushtrack              track active jobs based on statistics


=head1 OPTIONS


=over 8

=item B<help>

    Print a brief help message and exits.

=item B<man>

    Prints the manual page and exits.

=item B<tushfind>


    Obtain lists of jobs, files, and status information.  All options
    except "ps" and "json" use the emacs "find grep" format.
    supply one of the following values:
      all:     lists all log files in the ACTIVE directory
      recent:  lists all recent log files in the ACTIVE directory
      active:  lists active log files in the ACTIVE directory
      done:    lists inactive log files in the ACTIVE directory
      history: lists log files in the history directory
      ps:      return "ps" output for active jobs
      json:    return detailed json on all jobs in the ACTIVE directory


=item B<tushtail>


    Use "emacs" to tail files.
    supply one of the following values:
      all:     tail all output files in the ACTIVE directory
      recent:  tail all recent output files in the ACTIVE directory
      active:  tail active output files in the ACTIVE directory
      done:    tail inactive output files in the ACTIVE directory
      history: tail output files in the history directory


=item B<tushnotail>

    dispatch job without auto tail

=item B<tushclean>


    clean the specified directory.
      active:   move all files for inactive jobs to the history directory.
      done:     remove files for old jobs from the history directory.
      almanack: remove old almanack files from the history directory.


=item B<tushalmanack>

    get most recent almanack

=item B<tushstatistics>

    get the statistics for the named job

=item B<tushtrack>

    track active jobs based on statistics

=back



=head1 DESCRIPTION

nohup and tail and more!
tush.pl will run a command in the background, pipe its output to a file,
and tail the output.  It will automatically reconnect to active jobs.

=head1 BASIC USAGE

Write "tush.pl", followed by the command string, to run the command in
the background.  Any double-quoted arguments need an additional
wrapping pair of single-quotes.

  Example:

  tush.pl echo '"hello world"'

tush.pl will run the command and automatically tail the output using
"less".  Cancelling the tail does *not* kill the background process.
If you run tush.pl without any arguments it will find the output files
for all recent jobs and list them in an emacs buffer.  This emacs
session is configured to automatically tail the tush output buffers.

=head1 CONCEPTS

tush.pl maintains an ACTIVE directory and a history directory.  A job
is active as long as it is running.  Calling tush.pl without any
arguments will create an emacs process that automatically "tails" all
recent jobs.  The "tushclean=active" option will move finished or
inactive jobs from the ACTIVE directory to the history directory and
create a "scoreboard" file which tracks various statistics on the
jobs, such as min, max and average run times, filesize, etc.  Older
entries in the history directory are cleaned up using
"tushclean=done", which removes the log files for old jobs, but
accumulates the job statistics into an "almanack" file.

=head2 SHARED CONFIGURATION

Multiple nodes or users can share a common history directory, if
desired, but each instance should have a separate ACTIVE directory.
In order to do this, replace the "history" directory under each local
~/.tush_dir with a soft link to the shared directory.  Multiple users
can use "--tushclean active" to move log files to the history
directory simultaneously.  However, only one user should run
"--tushclean done" or "--tushclean almanack" to prevent data
corruption.

=head1 LIMITATIONS

Most tush.pl options begin with "--tush..." to distinguish them from
options to the background job, with the exception of "-man" and
"-help".  tush.pl may erroneously process "-m" and "-h" options for
the background job as "-man" and "-help".





=head1 SUPPORT

Address bug reports and comments at https://github.com/t-bc/genezzo/issues

=head1 AUTHORS

Jeff Cohen

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2024 by Jeff Cohen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
=cut
# BREEZLY_POD_END

# BREEZLY_BEGIN_DEFS
#
# The json breezly_defs control command-line parsing and pod
# documentation.  Update these definitions and run breezly.pl to
# rebuild your program.
#
sub breezly_defs
{
    my $bigstr = << 'EOF_bigstr';
{
   "_defs" : {
      "copyright" : {
         "contributors" : [],
         "license" : {
            "long" : "This is free software; you can redistribute it and/or modify it under%0Athe same terms as the Perl 5 programming language system itself.",
            "name" : "Perl Artistic License"
         },
         "maintainers" : [],
         "owner" : "Jeff Cohen",
         "support" : {
            "long" : "Address bug reports and comments at https://github.com/t-bc/genezzo/issues"
         },
         "year" : 2024
      },
      "creation" : {
         "creationdate" : "Wed Apr  3 00:49:28 2024",
         "creationtime" : 1712130568,
         "orig_authors" : [
            "Jeff Cohen"
         ]
      },
      "long" : "nohup and tail and more!%0Atush.pl will run a command in the background, pipe its output to a file,%0Aand tail the output.  It will automatically reconnect to active jobs.%0A%0A= BASIC USAGE%0A%0AWrite %22tush.pl%22, followed by the command string, to run the command in%0Athe background.  Any double-quoted arguments need an additional%0Awrapping pair of single-quotes.%0A%0A  Example:%0A%0A  tush.pl echo %27%22hello world%22%27%0A%0Atush.pl will run the command and automatically tail the output using%0A%22less%22.  Cancelling the tail does *not* kill the background process.%0AIf you run tush.pl without any arguments it will find the output files%0Afor all recent jobs and list them in an emacs buffer.  This emacs%0Asession is configured to automatically tail the tush output buffers.%0A%0A= CONCEPTS%0A%0Atush.pl maintains an ACTIVE directory and a history directory.  A job%0Ais active as long as it is running.  Calling tush.pl without any%0Aarguments will create an emacs process that automatically %22tails%22 all%0Arecent jobs.  The %22tushclean=active%22 option will move finished or%0Ainactive jobs from the ACTIVE directory to the history directory and%0Acreate a %22scoreboard%22 file which tracks various statistics on the%0Ajobs, such as min, max and average run times, filesize, etc.  Older%0Aentries in the history directory are cleaned up using%0A%22tushclean=done%22, which removes the log files for old jobs, but%0Aaccumulates the job statistics into an %22almanack%22 file.%0A%0A== SHARED CONFIGURATION%0A%0AMultiple nodes or users can share a common history directory, if%0Adesired, but each instance should have a separate ACTIVE directory.%0AIn order to do this, replace the %22history%22 directory under each local%0A~/.tush_dir with a soft link to the shared directory.  Multiple users%0Acan use %22--tushclean active%22 to move log files to the history%0Adirectory simultaneously.  However, only one user should run%0A%22--tushclean done%22 or %22--tushclean almanack%22 to prevent data%0Acorruption.%0A%0A= LIMITATIONS%0A%0AMost tush.pl options begin with %22--tush...%22 to distinguish them from%0Aoptions to the background job, with the exception of %22-man%22 and%0A%22-help%22.  tush.pl may erroneously process %22-m%22 and %22-h%22 options for%0Athe background job as %22-man%22 and %22-help%22.  %0A%0A",
      "prog" : {
         "breezly" : {
            "json_module" : "JSON"
         },
         "mijo" : {
            "mjkl_defs" : {
               "copyright" : {
                  "owner" : "Jeff Cohen"
               },
               "creation" : {
                  "orig_authors" : [
                     "Jeff Cohen"
                  ]
               }
            }
         }
      },
      "short" : "run a job in the background, with finesse.",
      "synopsis" : "[options] <cmd>...",
      "version" : {
         "_generator" : "breezly.pl version 3.4",
         "date" : "Sat Jul 27 18:20:24 2024",
         "number" : "1.2",
         "time" : 1722129624
      }
   },
   "args" : [
      {
         "alias" : "?",
         "long" : "Print a brief help message and exits.",
         "name" : "help",
         "required" : 0,
         "short" : "brief help message",
         "type" : "untyped"
      },
      {
         "long" : "Prints the manual page and exits.",
         "name" : "man",
         "required" : 0,
         "short" : "full documentation",
         "type" : "untyped"
      },
      {
         "choices" : [
            "all",
            "recent",
            "active",
            "ps",
            "done",
            "json",
            "history"
         ],
         "long" : "%0AObtain lists of jobs, files, and status information.  All options%0Aexcept %22ps%22 and %22json%22 use the emacs %22find grep%22 format.%0Asupply one of the following values:%0A  all:     lists all log files in the ACTIVE directory %0A  recent:  lists all recent log files in the ACTIVE directory %0A  active:  lists active log files in the ACTIVE directory %0A  done:    lists inactive log files in the ACTIVE directory %0A  history: lists log files in the history directory %0A  ps:      return %22ps%22 output for active jobs%0A  json:    return detailed json on all jobs in the ACTIVE directory%0A",
         "name" : "tushfind",
         "required" : 0,
         "short" : "find various processes and output files, various ways",
         "type" : "string"
      },
      {
         "choices" : [
            "all",
            "recent",
            "active",
            "done",
            "history"
         ],
         "long" : "%0AUse %22emacs%22 to tail files.%0Asupply one of the following values:%0A  all:     tail all output files in the ACTIVE directory%0A  recent:  tail all recent output files in the ACTIVE directory%0A  active:  tail active output files in the ACTIVE directory%0A  done:    tail inactive output files in the ACTIVE directory%0A  history: tail output files in the history directory%0A",
         "name" : "tushtail",
         "required" : 0,
         "short" : "tail the set of specified files",
         "type" : "string"
      },
      {
         "long" : "dispatch job without auto tail",
         "name" : "tushnotail",
         "required" : 0,
         "short" : "dispatch job without auto tail",
         "type" : "untyped"
      },
      {
         "choices" : [
            "active",
            "done",
            "almanack"
         ],
         "long" : "%0Aclean the specified directory.%0A  active:   move all files for inactive jobs to the history directory.%0A  done:     remove files for old jobs from the history directory.%0A  almanack: remove old almanack files from the history directory.%0A",
         "name" : "tushclean",
         "required" : 0,
         "short" : "clean the specified directory",
         "type" : "string"
      },
      {
         "long" : "get most recent almanack",
         "name" : "tushalmanack",
         "required" : 0,
         "short" : "get most recent almanack",
         "type" : "untyped"
      },
      {
         "alias" : "tushstats",
         "long" : "get the statistics for the named job",
         "name" : "tushstatistics",
         "required" : 0,
         "short" : "get the statistics for the named job",
         "type" : "string"
      },
      {
         "long" : "track active jobs based on statistics",
         "name" : "tushtrack",
         "required" : 0,
         "short" : "track active jobs based on statistics",
         "type" : "untyped"
      }
   ]
}

EOF_bigstr

    return ($bigstr);
}
# BREEZLY_END_DEFS

# reconfigure Getopt to pass unknown options to tush command
BEGIN {

    Getopt::Long::Configure("pass_through");
}


# validate_more(hash of cmdline options)
#
# stub routine for user-supplied command-line validation
#
#
sub validate_more
{
    my $bigh = shift;

    return (1);
} # end validate_more

# helper for defstr_decode()
# stub routine for improved JSON activities
sub defstr_decode_more
{
    my $defstr = shift;

    # do nothing
    return undef;
} # end defstr_decode_more

# BREEZLY_CMDLINE_BEGIN

# WARNING: DO NOT modify parse_cmdline() directly!
# Generated from the breezly_defs by breezly.pl version 3.4
# on Sat Jul 27 18:20:24 2024.

our $breezly_optdef_h;

sub defstr_decode
{
    my $defstr = shift;

    return JSON::PP::decode_json($defstr)
        if (eval "require JSON::PP");

    return JSON::decode_json($defstr)
        if (eval "require JSON");

    my $brz_defs;

    # use user-defined routine for more JSON parsing options
    $brz_defs = defstr_decode_more($defstr);
    return $brz_defs
        if (defined($brz_defs));

    warn "Cannot find JSON or JSON::PP modules!\nPlease download and install from cpan.org";

    # build a default, empty structure
    $brz_defs = {};
    $brz_defs->{_defs} = {};
    $brz_defs->{args}  = {};

    return $brz_defs;

} # end defstr_decode

sub parse_cmdline
{
    my $man  = 0;
    my $help = 0;

    my $cmdline = join(" ", @ARGV);

    my %h = (
        'help' => \$help, 'man' => \$man
        );


    GetOptions(\%h,
               'help|?', 'man',
               'tushfind:s',
               'tushtail:s',
               'tushnotail',
               'tushclean:s',
               'tushalmanack',
               'tushstatistics|tushstats:s',
               'tushtrack'

        ) or pod2usage(2);

    my $glob_id = "tush.pl";

    pod2usage(-msg => $glob_id, -exitstatus => 1) if $help;
    pod2usage(-msg => $glob_id, -exitstatus => 0, -verbose => 2) if $man;

    # validate some options
    if (exists($h{tushfind}))
    {
        unless ($h{tushfind} =~ m/^(all|recent|active|ps|done|json|history)$/)
        {
            warn "tushfind: " . $h{tushfind} . " not in (all, recent, active, ps, done, json, history)";
            pod2usage(-msg => $glob_id, -exitstatus => 1, -verbose => 0);
        }
    }

    if (exists($h{tushtail}))
    {
        unless ($h{tushtail} =~ m/^(all|recent|active|done|history)$/)
        {
            warn "tushtail: " . $h{tushtail} . " not in (all, recent, active, done, history)";
            pod2usage(-msg => $glob_id, -exitstatus => 1, -verbose => 0);
        }
    }

    if (exists($h{tushclean}))
    {
        unless ($h{tushclean} =~ m/^(active|done|almanack)$/)
        {
            warn "tushclean: " . $h{tushclean} . " not in (active, done, almanack)";
            pod2usage(-msg => $glob_id, -exitstatus => 1, -verbose => 0);
        }
    }



    # copy to the global
    while (my ($kk, $vv) = each(%h))
    {
        $breezly_optdef_h->{$kk} = $vv;
    }

    my $defstr = breezly_defs();

    my $brz_defs = defstr_decode($defstr);
    $breezly_optdef_h->{_defs}            = $brz_defs->{_defs};
    $breezly_optdef_h->{_defs}->{cmdline} = $cmdline;
    $breezly_optdef_h->{_defs}->{_args}   = $brz_defs->{args};
    $breezly_optdef_h->{_defs}->{_JSON}   = {};

    # call user-supplied validation
    return (validate_more($breezly_optdef_h));
} # end parse_cmdline

BEGIN {
    exit(0)
        unless (parse_cmdline());

}
# BREEZLY_CMDLINE_END

# BREEZLY_UTILITYFUNCS_BEGIN

# The following breezly utility functions were copied from
# breezly.pl version 3.4
# on Sat Jul 27 18:20:24 2024.
#
# Copyright (c) 2014-2022 by Jeff Cohen.


sub breezly_json_setup
{
    my $bop = shift;

    return
        if (exists($bop->{_defs}->{_JSON}->{json}));

    if (eval "require JSON::PP")
    {
        $bop->{_defs}->{_JSON}->{module} = "JSON::PP";
        $bop->{_defs}->{_JSON}->{json}   =
          JSON::PP->new->pretty(1)->indent(1)->canonical(1);
    }
    elsif (eval "require JSON")
    {
        $bop->{_defs}->{_JSON}->{module} = "JSON";
        $bop->{_defs}->{_JSON}->{json}   =
           JSON->new->pretty(1)->indent(1)->canonical(1);
    }

    else
    {
        die "Cannot find JSON or JSON::PP modules!\nPlease download and install from cpan.org";
    }
}

# JSON::to_json
sub breezly_json_encode_pretty
{
    my ($bop, $perlscalar) = @_;

    breezly_json_setup($bop);

    return
        ($bop->{_defs}->{_JSON}->{json}->encode($perlscalar));
}
sub breezly_json_encode_fast
{
    my ($bop, $perlscalar) = @_;

    breezly_json_setup($bop);

    if ("JSON" eq $bop->{_defs}->{_JSON}->{module})
    {
        return JSON::to_json($perlscalar);
    }

    return
        ($bop->{_defs}->{_JSON}->{json}->encode($perlscalar));
}

# JSON::from_json
sub breezly_json_decode
{
    my ($bop, $jsonstr) = @_;

    breezly_json_setup($bop);

    return
        ($bop->{_defs}->{_JSON}->{json}->decode($jsonstr));
}

sub breezly_deep_copy
{
    my ($bop, $perlscalar) = @_;

    if (eval "require Storable")
    {
        use Storable;

        $Storable::Deparse = 1;
        $Storable::Eval    = 1;

        return Storable::dclone($perlscalar);

        # set twice to avoid typo warning
        $Storable::Deparse = 1;
        $Storable::Eval    = 1;

    }

    return breezly_json_decode($bop,
             breezly_json_encode_fast($bop, $perlscalar));

    return breezly_json_decode($bop,
             breezly_json_encode_fast($bop, $perlscalar));

}

# format_with_lead_spaces(input string, substitution pattern,
# replacement value) returns formatted string
#
# helper function for doformat()
#
# does a "leading space-aware" version of regex substitution, where if
# the replacement value is multi-line, the newlines are prefixed with
# the offset of the original string
sub format_with_lead_spaces
{
    my ($instr, $sub1, $val) = @_;

    # do normal substitution unless the replacement value has a
    # newline, and the string has all blanks leading to the
    # substitution pattern
    unless (($val =~ m/\n/) &&
            ($instr =~ m/^\s+$sub1/))
    {
        $instr =~ s/$sub1/$val/gm;
        return $instr;
    }

    # find the leading blanks
    my @spc = ($instr =~ m/^(\s+)$sub1/);

    # split the value by line (retaining the newlines as separate
    # entries)
    my @vvv = split(/(\n)/, $val);

    # add the spaces to the prefix each newline
    for my $ii (0..(scalar(@vvv)-1))
    {
        $vvv[$ii] .= $spc[0]
            if ($vvv[$ii] =~ m/\n/);
    }
    my $val2 = join("", @vvv);

    # if the pattern has leading spaces, use the spaced-out version of
    # the value
    $instr =~ s/^(\s+)$sub1/$1$val2/gm;

    # replace other references to the pattern with the original
    # (unmodified) value.
    # Note: it would be nice to figure out how to adjust the offset
    # for $val for this case, but it's non-trivial
    $instr =~ s/$sub1/$val/gm;
    return $instr;
} # end format_with_lead_spaces

# doformat(input string/template, hash of key/value pairs)
# returns formatted string
#
# format a python-style (PEP 292) template string, and preserve leading whitespace
# NOTE: key must be enclosed in curly braces
sub doformat
{
    my ($bigstr, $kv) = @_;

    my @lin = split(/(\n)/, $bigstr);

    while (my ($kk, $vv) = each (%{$kv}))
    {
        die "doformat: invalid null key"
            unless (defined($kk));

        unless (defined($vv))
        {
            warn "doformat: key $kk has null value";
            $vv = "";
        }

        #        my $sub1 = '{' . quotemeta($kk) . '}';
        my $sub1 = quotemeta('{' . $kk . '}'); # 20220728: must quote braces now

        for my $ii (0..(scalar(@lin)-1))
        {
            next unless ($lin[$ii] =~ m/\w/);

            # check for case of value with newlines, and leading spaces in format
            if ($vv !~ m/\n/)
            {
                $lin[$ii] =~ s/$sub1/$vv/gm;
            }
            else
            {
                # preserve leading spaces
                $lin[$ii] = format_with_lead_spaces($lin[$ii], $sub1, $vv);
            }
        } # end for
    } # end while

    $bigstr = join("", @lin);

    return $bigstr;
}

# quurl(string)
#
# ("quote url")
# "percent-encode" a string (rfc 3986)
# only allow alphanums, and quote all other chars as hex string
sub quurl
{
    my $str = shift;

    $str =~ s/([^a-zA-Z0-9])/uc(sprintf("%%%02lx",  ord $1))/eg;
    return $str;
}

# more "relaxed" version of quurl function -- allow basic punctuation
# with the exception of "%", "|", and quote characters
sub quurl2
{
    my $str = shift;

    my $pat1 = '[^a-zA-Z0-9' .
        quotemeta(' ~!@#$^&*()-_=+{}[]:;<>,.?/') . ']';
    $str =~ s/($pat1)/uc(sprintf("%%%02lx",  ord $1))/eg;
    return $str;
}

# unconvert quoted strings
sub unquurl
{
    my $str = shift;

    $str =~ s/\%([A-Fa-f0-9]{2})/pack('C', hex($1))/seg;
    return $str;
}


# breezly_tbl_split(string, [column sep rex], [eol rex])
#
# split a string representation of a table into an array of rows of
# columns (an array of arrays).  If the regular expressions for the
# column separator and "end of line" are not supplied (via qr{}), then
# the column separator is "|" and eol is "\n";
#
# returns ref to array of arrays
sub breezly_tbl_split
{
    my ($bigstr, $colseprex, $eolrex, $trimrex) = @_;

    $trimrex   = qr/\s*/      unless (defined($trimrex));
    $colseprex = qr/\s*\|\s*/ unless (defined($colseprex));
    $eolrex    = qr/\s*\n/    unless (defined($eolrex));

    my @rows = split($eolrex, $bigstr);

    my $rowa = [];

    for my $rw (@rows)
    {
        $rw =~ s/^$trimrex//;
        $rw =~ s/$trimrex$//;

        my @cols = split($colseprex, $rw);

        my $cola = [];

        push @{$cola}, @cols;
        push @{$rowa}, $cola;
    }

    return $rowa;
} # end breezly_tbl_split

# breezly_tbl_pad
#
# "regularize" the "split" table array so all rows have the same
# number of columns, and the columns are right-padded to identical
# length
sub breezly_tbl_pad
{
    my $rowa = shift;

    my @rowstat;

    # calculate max space per column
    for my $rw (@{$rowa})
    {
        # make sure rowstat is large enough

        my $maxcol = scalar(@{$rw});
        if (scalar(@rowstat) < $maxcol)
        {
            $rowstat[$maxcol-1] = 0;
        }

        for my $ii (0..($maxcol-1))
        {
            $rowstat[$ii] = 0
                unless (defined($rowstat[$ii]));

            my $collen = length($rw->[$ii]);

            $rowstat[$ii] = $collen
                if ($collen > $rowstat[$ii]);
        }
    } # end for my $rw

    my $rowb = [];

    for my $rw (@{$rowa})
    {
        my $cola = [];

        my $maxcol = scalar(@{$rw});

        my $maxi = 0;

        for my $ii (0..($maxcol-1))
        {
            my $collen = length($rw->[$ii]);

            my $extrasp = "";

            # blank pad if necessary
            $extrasp = " "x($rowstat[$ii]-$collen)
                if ($rowstat[$ii]-$collen);

            push @{$cola}, $rw->[$ii] . $extrasp;

            $maxi = $ii;
        }

        $maxi += 1;

        # add extra cols if necessary
        for my $jj ($maxi..(scalar(@rowstat)-1))
        {
            push @{$cola}, " "x$rowstat[$jj];
        }

        push @{$rowb}, $cola;

    } # end for my $rw

    return $rowb;

} # end breezly_tbl_pad

# breezly_tbl_join("padded" array, alignment)
#
# given a "padded", rectangular array of columns, where each column
# has a consistent padded width, align the column spacing on a tab
# width boundary.
#
# align=0 : minimum column spacing is zero spaces
# align=1 : minimum column spacing is one space
#
sub breezly_tbl_join
{
    my ($rowa, $algn) = @_;

    $algn = 0 if ($algn < 0); # deal with negative

    my @biga;

    if (0 == $algn)
    {
        for my $rw (@{$rowa})
        {
            push @biga, join("", @{$rw});
        }
    }
    elsif (1 == $algn)
    {
        for my $rw (@{$rowa})
        {
            push @biga, join(" ", @{$rw});
        }
    }
    else
    {
        my @rowstat;
        my $maxcol = 0;

        for my $rw (@{$rowa})
        {
            $maxcol = scalar(@{$rw});

            for my $col (@{$rw})
            {
                # calculate align based on (column length modulo algn)
                push @rowstat, ($algn - (length($col)%$algn));
            }
            last; # just need first row
        }

        # add extra spacing for tab alignment
        for my $rw (@{$rowa})
        {
            my $rwstr = "";
            for my $ii (0..($maxcol-1))
            {
                $rwstr .= $rw->[$ii];
                $rwstr .= " "x$rowstat[$ii] if ($rowstat[$ii]);
            }
            push @biga, $rwstr;
        }
    }

    my $bigstr = join("\n", @biga) . "\n";

    return $bigstr;
} # end breezly_tbl_join

sub breezly_fmt_tbl
{
    my $instr = shift;

    my $rowa = breezly_tbl_split($instr);

    my $rowb = breezly_tbl_pad($rowa);

    return breezly_tbl_join($rowb, 4);
}

# basic_wikicreole2pod(file name, file contents [as string], breezly defs)
#
# super-crappy wikicreole approximation
sub basic_wikicreole2pod
{
    my $bigstr = shift;

    # headers
    $bigstr =~ s/^\=\s/=head1 /gm;
    $bigstr =~ s/^\=\=\s/=head2 /gm;
    $bigstr =~ s/^\=\=\=\s/=head3 /gm;

    my @lines = split(/\n/, $bigstr);

    # fake fixes for multi-line noformat and lists -- prepend with a
    # space so pod doesn't reformat
    my @lin2;
    my $bNoFormat = 0;
    my $bList     = 0;

    for my $ii (0..(scalar(@lines)-1))
    {
        my $lin = $lines[$ii];

        if ($bNoFormat)
        {
            if ($lin =~ m/^\}\}\}/)
            {
                $bNoFormat = 0;
            }
            $lin = " " . $lin;
        }
        else
        {
            if ($bList)
            {
                if ($lin !~ m/^\*/)
                {
                    $bList = 0;
                }
                else
                {
                    $lin = " " . $lin;
                }
            }
            else
            {
                if (($lin =~ m/^\{\{\{/) &&
                    ($lin !~ m/\}\}\}/))
                {
                    $bNoFormat = 1;
                    $lin = " " . $lin;
                }
                elsif ($lin =~ m/^\*/)
                {
                    if (($ii < (scalar(@lines)-1)) &&
                        ($lines[$ii+1] =~ m/^\*/))
                    {
                        $bList = 1;
                        $lin = " " . $lin;
                    }
                }
            }
        } # end for my ii

        push @lin2, $lin;
    }

    $bigstr = join("\n", @lin2);

    # noformat
    $bigstr =~ s/\{\{\{((?:[^\{\}])*)\}\}\}/$1/gm;
    $bigstr =~ s/\{\{\{//gm;
    $bigstr =~ s/\}\}\}//gm;

    # bold
    $bigstr =~ s/\*\*([^\*]*)\*\*/B\<$1\>/gm;

    # convert definition list to pod item list
    my @fff = split(/(^(?:\;|\:).*$)/m, $bigstr);

    my $indeflist = 0;

    if (scalar(@fff))
    {
        my $newstr = "";

        for my $lin (@fff)
        {
            if ($lin =~ m/^(\;|\:)/)
            {
                if (!$indeflist)
                {
                    $newstr .= "\n=over 8 \n";
                    $indeflist = 1;
                }

                if ($lin =~ m/^\;/)
                {
                    $lin =~ s/^\;/\n=item /;
                }

                if ($lin =~ m/^\:/)
                {
                    $lin =~ s/^\://;
                    $lin =~ s/^/\n    /gm;
                    $lin =~ s/\\\\/\n    /gm;
                }
            }
            else
            {
                if ($indeflist && ($lin =~ m/\w/))
                {
                    $newstr .= "\n\n=back \n";
                    $indeflist = 0;
                }

            }

            $newstr .= $lin;

        } # end for

        if ($indeflist)
        {
            $newstr .= "\n=back \n";
            $indeflist = 0;
        }

        $bigstr = $newstr;
    } # end if (scalar(@fff))

    return $bigstr;
} # end basic_wikicreole2pod

# inc_lastnum(definition string [for error msg], value to be incremented)
#
# helper for do_cmdline_defs()
# increment the last numeric portion of a string
sub inc_lastnum
{
    my ($defstr, $idef) = @_;

    die "entry \"$defstr\": $idef not a number"
        unless ($idef =~ m/\d+/);

    # last digit[s] (with optional suffix)
    my @lastnum = ($idef =~ m/(\d+(?:\D+)?$)/);

    die "entry \"$defstr\": $idef bad number"
        unless (1 == scalar(@lastnum));

    my $num = shift @lastnum;

    # strip the last number suffix
    $idef =~ s/$num$//;

    my $suffix = "";

    # check for non-numeric final suffix
    if ($num =~ m/\D+$/)
    {
        # get non-numeric final suffix
        $suffix = $num;

        # isolate numeric portion
        $suffix =~ s/\d+//g;
        $num    =~ s/\D+$//g;
    }
    $num += 1;

    return ($idef . $num . $suffix);
} # end  inc_lastnum

# breezly_from_encoded_json(breezly optdef hash, percent encoded json string)
# returns a perl hash/array data struct
#
# special treatment for undef/zero length/empty strings
sub breezly_from_encoded_json
{
    my ($bop, $vv) = @_;

    # check for NULL, and treat as undef
    # (don't bother parsing, it won't work)
    # ((allow literal "undef" as alias for null, even though
    #   it's not valid json))
    return undef
        if ((!defined($vv))    ||
            (0 == length($vv)) ||                # empty string
            ($vv =~ m/^\s*$/)  ||                # whitespace
            ($vv =~ m/^\s*(null|undef)\s*$/i));  # "null" string literal

    # unquote and convert to perl
    my $instr = unquurl($vv);
    return (breezly_json_decode($bop, $instr));

} # end breezly_from_encoded_json

# return a nice version/copyright string, ideal for a "--version" option
sub breezly_showversion
{
    my $bigh = shift;

    my $verzion = "unknown version";

    if (exists($bigh->{_defs}->{version}) &&
        exists($bigh->{_defs}->{version}->{number}) &&
        exists($bigh->{_defs}->{version}->{date}))
    {
        $verzion = doformat("version {NUM} of {NAM} released on {DAT}",
                            {
                                NUM => $bigh->{_defs}->{version}->{number},
                                NAM => $0,
                                DAT => $bigh->{_defs}->{version}->{date}
                            });
    }

    my $copynlic = "";

    if (exists($bigh->{_defs}->{copyright}->{year}) &&
        exists($bigh->{_defs}->{copyright}->{owner}))
    {
        $copynlic = doformat("Copyright (c) {CYEAR} by {COWNER}.\n",
                             {
                                 CYEAR  => $bigh->{_defs}->{copyright}->{year},
                                 COWNER => $bigh->{_defs}->{copyright}->{owner}
                             });
    }

    if (exists($bigh->{_defs}->{copyright}->{license}) &&
        exists($bigh->{_defs}->{copyright}->{license}->{long}))
    {
        $copynlic .= "\n" if (length($copynlic));
        $copynlic .=
            unquurl($bigh->{_defs}->{copyright}->{license}->{long}) .
            "\n";
    }

    return $verzion . "\n\n" . $copynlic . "\n";

} # end breezly_showversion

# helper function for extending cmdline_defs
#
# if given an array of "named hashes" (ie hashes with a "name"
# attribute), we allow a hash-style reference with "dot name"
# notation.  For examples, the "args" array has named hashes for each
# command-line argument like "man", so a reference like
# "args.man.required = 1" looks up which array entry has name "man" and
# gets converted to something like "args[1].required = 1".
sub named_array_conversion
{
    my ($na_keyprefix, $na_h, $entry, $kkey, $delapp) = @_;

    # an entry is in the form <na_keyprefix>.<argname>[.<...>]
    # Note that the <na_keyprefix> can contain ".", so remove it
    # first, then split the entry into three parts.  The first part is
    # the "key prefix", the second part is the "argname", and the
    # third part (if it exists) is the suffix
    my $ent2      = $entry . "";
    my $na_keyrex = quotemeta($na_keyprefix);

    # remove the named array key prefix (with any embedded dots) so
    # can just split into 3 parts...
    $ent2 =~ s/^$na_keyrex//;

    my @zzz = split(/\./, $ent2, 3);

    die "illegal argdef reference $entry"
        unless (scalar(@zzz) >= 2);

    shift @zzz; # pop the named array key prefix (which should be empty)

    # if treat as hash by name, get the name
    my $argname = shift @zzz;
    my $argidx;

    # iterate over array, looking for the index of the hash with the
    # specified name
    for my $ii (0..(scalar(@{$na_h})-1))
    {
        if (exists($na_h->[$ii]->{name}) &&
            ($na_h->[$ii]->{name} eq $argname))
        {
            $argidx = $ii;
            last;
        }
    }

    if (defined($argidx)) # entry already exists
    {
        # convert the entry to the array ref
        $entry = $na_keyprefix . '[' . $argidx . ']';

        # append final bit if exists
        $entry .= "." . $zzz[0] if (scalar(@zzz));

    }
    else # add new named entry
    {
        # entry must already exist if deleting or appending
        die "no such named argument \"$argname\" for $kkey"
            if ($delapp);

        my $nentry = {name=>$argname};
        push @{$na_h}, $nentry;

        # new entry is last one (zero based)
        $argidx = scalar(@{$na_h}) - 1;

        # convert the entry to the array ref
        $entry = $na_keyprefix . '[' . $argidx . ']';

        # append final bit if exists
        $entry .= "." . $zzz[0] if (scalar(@zzz));

    }

    return $entry;
} # end named_array_conversion

# extend the cmdline_defs
#
# version and copyright are examples of "shortcuts", ie "version" is a
# hash, so when you perform a scalar assignment, it sets the
# "version.number" (and updates the date/time as well).
#
# argdef is a bit a weirder, and it conflates several concepts that
# should be separated.  First, while the normal cmdline processing
# only modifies the contents of the "_defs" hash under the main "bigh"
# hash, the argdef lets you modify the top-level "args" hash.  In
# addition, the argdef is an alias for "args" in all definitions.  And
# finally, argdef does the conversion of treating an array of named
# hashes like a hash by name reference, eg the reference "args.man"
# gets converted to the appropriate "args[...]" array reference.
sub cmdline_defs_extension2
{
    my ($bop,
        $argdef, $brzvz, $filnam, $bigh, $defh, $blong, $delapp,
        $bdel, $bapp, $binc, $kkey, $vval, $do_def, $defstr,
        $cdxfunc
        ) = @_;

    my $cdxh;

    if (!$blong) # shorthand for scalar update to version/copyright
    {
        if ($kkey =~ m/^(version|copyright)$/)
        {
            if ($kkey =~ m/^version$/)
            {
                my $dt = localtime();
                my $tm = time();

                # build defs with values for date, time, _generator
                # fields, then call do_cmdline_defs()
                my $defh1 = {
                    "version.date" => $dt,
                    "version.time" => $tm
                };

                $defh1->{"version._generator"} =
                    "breezly.pl version $brzvz"
                    if (defined($brzvz) &&
                        length($brzvz));

                do_cmdline_defs2($bop,
                                undef, $brzvz, $filnam, $bigh, $defh1,
                                $blong,
                                0, # not del/app/inc
                                $cdxfunc);

                # reset current key to version.number
                $cdxh = {
                    key   => "version.number",
                    value => $vval
                };

            }
            elsif ($kkey =~ m/^copyright$/)
            {
                $cdxh = {
                    key   => "copyright.year",
                    value => $vval
                };
            }

            return $cdxh;

        } # end if version|copyright
    } # end if !blong

    # check if possibly an "argdef"
    if (defined($argdef))
    {
        my $adef = $argdef;

        if ($kkey =~ m/^$adef(((\.|\[).*)?)$/)
        {
            $do_def = $bigh; # not bigh->{args},
            $defstr = '';

            # reset do_def, defstr
            $cdxh = {
                do_def => $do_def,
                defstr => $defstr
            };

            my $entry = $kkey;

            # substitute "args" for the argdef alias
            $entry =~ s/^$adef/args/;

            # check if argdef "by name" reference, ie
            #   -getdef args.argname
            # vs args[argnum]
            if ($entry =~ m/^args\./)
            {
                my @zzz = split(/\./, $entry, 3);

                die "illegal argdef reference $entry"
                    unless (scalar(@zzz) >= 2);

                shift @zzz; # pop "args"

                # if treat "args" as hash by name, get the name
                my $argname = shift @zzz;
                my $argidx;

                for my $ii (0..(scalar(@{$bigh->{args}})-1))
                {
                    if (exists($bigh->{args}->[$ii]->{name}) &&
                        ($bigh->{args}->[$ii]->{name} eq $argname))
                    {
                        $argidx = $ii;
                        last;
                    }
                }

                if (defined($argidx)) # entry already exists
                {
                    # convert the entry to the array ref
                    $entry = 'args[' . $argidx . ']';

                    # append final bit if exists
                    $entry .= "." . $zzz[0] if (scalar(@zzz));

                }
                else # add new named entry
                {
                    die "no such named argument \"$argname\" for $kkey"
                        if ($delapp);

                    my $nentry = {name=>$argname};
                    push @{$bigh->{args}}, $nentry;

                    # new entry is last one (zero based)
                    $argidx = scalar(@{$bigh->{args}}) - 1;

                    # convert the entry to the array ref
                    $entry = 'args[' . $argidx . ']';

                    # append final bit if exists
                    $entry .= "." . $zzz[0] if (scalar(@zzz));

                }
            }
            $kkey = $entry;

            $cdxh->{key} = $kkey;

            return $cdxh;

        } # end if key =~ adef
    } # end if defined argdef

    # do nothing
    return undef;
} # end cmdline_defs_extension

# do_cmdline_defs(breezly optdef hash,
#                 argdef name [if defined], breezly version,
#                 file name, breezly defs, cmdline defs,
#                 bool longdef, enum delete/append,
#                 cmdline defs extension function))
#
# update the breezly defs via command line options (defs and
# longdefs).  defs are simple scalars, but ldefs are percent-encoded
# JSON objects
#
# if delete/append=1, then delete    the entry from the hash/array
# if delete/append=2, then append    the entry to   the hash/array
# if delete/append=3, then increment the entry in   the hash/array
sub do_cmdline_defs2
{
    my ($bop,
        $argdef, $brzvz, $filnam, $bigh, $defh, $blong, $delapp,
        $cdxfunc) = @_;

    my $bdel = (defined($delapp) && ($delapp == 1));
    my $bapp = (defined($delapp) && ($delapp == 2));
    my $binc = (defined($delapp) && ($delapp == 3));

    while (my ($kk, $vv) = each(%{$defh}))
    {
        # input is "percent-encoded" JSON string
        if ($blong)
        {
            # convert json to perl
            $vv = breezly_from_encoded_json($bop, $vv);

            die "Cannot append NULL value to entry \"$kk\""
                if ($bapp && (!defined($vv)));
        }

        #  normal case (not unadorned version/copyright special case)
        my $do_def = $bigh->{_defs};
        my $defstr = '{_defs}';

        # run the extension code (if it exists)
        my $cdxh;

        if (defined($cdxfunc))
        {
            die "cdxfunc not a coderef"
                unless (ref($cdxfunc) eq "CODE");

            $cdxh = $cdxfunc->(
                $bop,
                $argdef, $brzvz, $filnam, $bigh, $defh, $blong, $delapp,
                $bdel, $bapp, $binc, $kk, $vv, $do_def, $defstr,
                $cdxfunc);
        }

        if (defined($cdxh))
        {
            $kk = $cdxh->{key}
                if (exists($cdxh->{key}));
            $vv = $cdxh->{value}
                if (exists($cdxh->{value}));

            $do_def = $cdxh->{do_def}
                if (exists($cdxh->{do_def}));
            $defstr = $cdxh->{defstr}
                if (exists($cdxh->{defstr}));
        }

        my @foo = split(/\./, $kk);

        my @xdef;

        # build "eXtended definitions", marking the hash and array
        # components
        for my $pp (@foo)
        {
            # allow negative offsets
            if ($pp !~ m/(\[(\-)?\d+\])+$/)
            {
                # "normal" case -- no array offset

                push @xdef, { def => $pp, typ => "HASH", val => $vv};
                next;
            }

            # [nn] suffix -- array notation
            my @p2 = split(/\[/, $pp, 2);

            # strip the array offset -- add it back later after
            # determining if this entry exists, and is an array
            $pp = shift @p2;

            my $tail = shift @p2;

            $tail =~ s/\]$//; # trim last bracket

            # array of offsets
            my @zzz;

            if ($tail =~ m/\]\[/)
            {
                @zzz = split(/\]\[/, $tail);
            }
            else
            {
                push @zzz, $tail;
            }
            push @xdef, { def => $pp, typ => "HASH"};

            for my $adef (@zzz)
            {
                push @xdef, { def => $adef, typ => "ARRAY"};
            }

            # save the value
            $xdef[-1]->{val} = $vv;

        } # end for my $pp

        my $prev = shift @xdef;

        # XXX XXX
        # NOTE: the "typ" of xdef is the type of the "previous",
        # not the "current".  So the first def is **always** a
        # HASH because "_defs" is a hash.
        #
        die "bad def $prev->{def}"
            unless (exists($prev->{typ}) &&
                    ($prev->{typ} =~ m/^(HASH)$/));

        my $cur = $prev;

        # build the defstr and the "do_def" using knowledge of the
        # type of the previous def and the current def.  For
        # example, if the prior def was a hash and it points to an
        # array, we may need to construct an empty array, eg:
        #  do_def->{prev} = [];
        #
        while (scalar(@xdef))
        {
            $cur = shift @xdef;

            die "bad def $cur->{def}"
                unless (exists($cur->{typ}) &&
                        ($cur->{typ} =~ m/^(HASH|ARRAY)$/));

            if ($prev->{typ} eq "HASH")
            {
                if (length($defstr))
                {
                    $defstr .= '->{' . $prev->{def} . '}';
                }
                else
                {
                    $defstr = '{' . $prev->{def} . '}';
                }

                unless (exists($do_def->{$prev->{def}}))
                {
                    die "no such entry \"$defstr\""
                        if ($delapp);

                    if ($cur->{typ} eq "HASH")
                    {
                        $do_def->{$prev->{def}} = {};
                    }
                    else
                    {
                        $do_def->{$prev->{def}} = [];
                    }
                }

                $do_def = $do_def->{$prev->{def}};

            }
            else # array
            {
                if (length($defstr))
                {
                    $defstr .= '->[' . $prev->{def} . ']';
                }
                else
                {
                    $defstr = '[' . $prev->{def} . ']';
                }

                unless (defined($do_def->[$prev->{def}]))
                {
                    die "no such entry \"$defstr\""
                        if ($delapp);

                    if ($cur->{typ} eq "HASH")
                    {
                        $do_def->[$prev->{def}] = {};
                    }
                    else
                    {
                        $do_def->[$prev->{def}] = [];
                    }
                }

                $do_def = $do_def->[$prev->{def}];

            }

            # check here: types must match
            unless (ref($do_def) eq $cur->{typ})
            {
                my $diemsg = "entry \"$defstr\" is not a " .
                    (($cur->{typ} eq "HASH") ? "hash" : "array") .
                    " -- illegal deref \"$cur->{def}\"";

                die $diemsg;
            }

            $prev = $cur;
        } # end while scalar @xdef

        die "bad def - no val"
            unless (exists($cur->{val}) || ($bdel || $binc) );

        # Finally, do the actual assignment of the value
        if ($cur->{typ} eq "HASH")
        {
            $defstr .= '->{' . $prev->{def} . '}';

            if ($delapp)
            {
                die "no such entry \"$defstr\""
                    unless (exists($do_def->{$prev->{def}}));
            }

            if ($bdel)
            {
                delete $do_def->{$prev->{def}};
            }
            else
            {
                if (!$bapp)
                {
                    if (!$binc)
                    {
                        # normal assignment
                        $do_def->{$prev->{def}} = $cur->{val};
                    }
                    else
                    {
                        my $idef = $do_def->{$prev->{def}};

                        # replace the incremented suffix
                        $do_def->{$prev->{def}} =
                            inc_lastnum($defstr, $idef);
                    }
                }
                else
                {
                    my $ktyp = ref($do_def->{$prev->{def}});
                    my $vtyp = ref($cur->{val});

                    if ($ktyp ne "ARRAY")
                    {
                        my $diemsg = "Cannot append $vtyp value to " .
                            "entry \"$defstr\"";

                        die $diemsg
                            if ($blong && $vtyp && ($vtyp ne "SCALAR"));

                        $do_def->{$prev->{def}} .= $cur->{val};
                    }
                    else
                    {
                        if ($blong && ($vtyp eq "ARRAY"))
                        {
                            push @{$do_def->{$prev->{def}}}, @{$cur->{val}};
                        }
                        else
                        {
                            push @{$do_def->{$prev->{def}}}, $cur->{val};
                        }
                    }
                }
            }

        }
        else # array
        {
            $defstr .= '->[' . $prev->{def} . ']';

            if ($delapp)
            {
                die "no such entry \"$defstr\""
                    if (($prev->{def} >= scalar(@{$do_def})) ||
                        # negative subscript
                        ( 0 > ($prev->{def} + scalar(@{$do_def}))));
            }

            if ($bdel)
            {
                # for an array, remove the specified reference
                splice(@{$do_def}, $prev->{def}, 1);
            }
            else
            {
                if (!$bapp)
                {

                    if (!$binc)
                    {
                        # normal assignment
                        $do_def->[$prev->{def}] = $cur->{val};
                    }
                    else
                    {
                        my $idef = $do_def->[$prev->{def}];

                        # replace the incremented suffix
                        $do_def->[$prev->{def}] =
                            inc_lastnum($defstr, $idef);
                    }
                }
                else
                {
                    my $ktyp = ref($do_def->[$prev->{def}]);
                    my $vtyp = ref($cur->{val});

                    if ($ktyp ne "ARRAY")
                    {
                        my $diemsg = "Cannot append $vtyp value to " .
                            "entry \"$defstr\"";

                        die $diemsg
                            if ($blong && $vtyp && ($vtyp ne "SCALAR"));

                        $do_def->[$prev->{def}] .= $cur->{val};
                    }
                    else
                    {
                        if ($blong && ($vtyp eq "ARRAY"))
                        {
                            push @{$do_def->[$prev->{def}]}, @{$cur->{val}};
                        }
                        else
                        {
                            push @{$do_def->[$prev->{def}]}, $cur->{val};
                        }
                    }
                }
            } # end !$bdel
        } # end array case

        # end normal case

    } # end while kk vv

} # end do_cmdline_defs


sub triple_quote_fixup
{
    my ($defstr, $tqf) = @_;

    my $tqfprefix = (defined($tqf) && length($tqf)) ? $tqf : "";

    return $defstr
        unless ($defstr =~ m/\"\"\"/);

    # NOTE: unconverted breezly_defs may contain triple-quotes.

    # triple quote fixup
    my @zzz = split(/(\"\"\")/, $defstr);

    my $fixstr = "";

    if (scalar(@zzz))
    {
        my $inquote = 0;

        # for each triple quoted region, convert to a single line using quurl2

        for my $chunk (@zzz)
        {
            if ($inquote) # in a quoted region
            {
                if ($chunk =~ m/\"\"\"/)
                {
                    $chunk =~ s/\"\"\"/\"/gm;
                    $inquote = 0;

                    # prefix the fixed up line with the "tqf prefix"
                    if (length($tqfprefix))
                    {
                        my @lin = split(/\n/, $fixstr);

                        if (scalar(@lin))
                        {
                            my $lastlin = $lin[-1];
                            $lin[-1] = $tqfprefix . $lastlin;

                            $fixstr = join("\n", @lin);
                        }
                    }
                }
                else
                {
                    $chunk = quurl2($chunk);
                }
            }
            else # not in a quoted region yet
            {
                if ($chunk =~ m/\"\"\"/)
                {
                    $chunk =~ s/\"\"\"/\"/gm;
                    $inquote = 1;
                }
            }

            $fixstr .= $chunk;

        } # end for my $chunk

        # should have terminated triple quote before end of loop
        die("unterminated triple quote in definitions")
            if ($inquote);

        $defstr = $fixstr;
    }

    return $defstr;
} # end triple_quote_fixup

# # do_initdefs(breezly optdef hash, initdef filename,
#               argdef name [if defined], breezly version,
#               file name, breezly defs)
#
# read a set of definitions from an init file and
# update the breezly definitions
#
# the grammar is:
#
# [define|jsondefine|append] <key> = <value>
# [delete|increment] <key>
#
# where a <key> uses the "dot" notation and
# a <value> is
#   a simple scalar value like a number,
#   a single-line, single-quoted string (eg president = "Abe Lincoln")
#   or a multi-line, triple-quoted string.
#
# Unlike the command-line functions, the json definitions don't take
# "pre-encoded" strings.  If the json def is a single-line, it can be
# single-quoted, and if it takes multiple lines, it should be
# triple-quoted.
#
# If you want a multi-line string to get assigned as a
# "percent-encoded" value, then prefix the definition with "keeplong",
# eg:
#
#   keeplong define a_long_string = """this string will be
#                                      spread over two lines"""
#
# For simple scalar assignment, the "define" is optional, ie
#
#   a.b = c
#   d.e = 3.14
#
# is the equivalent of the command-line:
#   -def a.b=c   -def d.e=3.14
#
sub do_initdefs_string2
{
    my ($bop,
        $bigstr, $initfilnam, $argdef, $brzvz, $filnam, $bigh, $cdxfunc) = @_;

    my $blong  = 0;
    my $delapp = 0;

    # in addition to updating the defs, build a list of the
    # definitions in order, parsed out into key/value pairs tagged
    # with the operation (eg "delete", "append")
    my $ilist = [];

    my $defstr = triple_quote_fixup($bigstr, "__TQ_FIXUP__ ");

    my @lines = split(/\n/, $defstr);

    for my $lin (@lines)
    {
        # skip spaces, comments
        next if ($lin =~ m/^\s*$/);
        next if ($lin =~ m/^\s*\#/);

        $blong  = 0;
        $delapp = 0;

        if ($lin !~ m/\=/)
        {
            # only for "delete", "increment"

            my $kk = $lin;

            # see what type of definition
            die "$lin: no define in file $initfilnam"
                unless ($kk =~ m/\w+\s+\w+/);

            die "$lin: unknown define option in file $initfilnam"
                if ($kk !~ m/^((del|delete)|(inc|increment))\s+/i);

            my @defopt = ($kk =~ m/^(\w+)\s+\w+/);

            die "$lin: bad define option in file $initfilnam"
                unless (1 == scalar(@defopt));

            my $dfo = shift @defopt;

            # trim def option prefix
            $kk =~ s/^$dfo\s*//;

            if ($dfo =~ m/^d/i)
            {
                # delete
                $delapp = 1;
            }
            elsif ($dfo =~ m/^i/i)
            {
                # increment

                $delapp = 3;
            }
            else
            {
                die "$lin: unknown define option \"$dfo\" in file $initfilnam";
            }

            my $defh = { $kk => 0 };

            do_cmdline_defs2($bop,
                            $argdef, $brzvz, $filnam, $bigh, $defh,
                            $blong, $delapp, $cdxfunc);

            push @{$ilist},
            {line => $lin,
             blong => $blong, key => $kk, delapp => $delapp};
        }
        else
        {
            # some type of "key = value " pair
            my @kv = split(/\s*\=\s*/, $lin, 2);

            die "$lin: invalid key=value pair in file $initfilnam"
                unless (2 == scalar(@kv));

            my $kk = $kv[0];
            my $vv = $kv[1];

            # trim quoted strings for value
            if ($vv =~ m/^\s*\".*\"\s*$/)
            {
                $vv =~ s/^\s*\"//;
                $vv =~ s/\"\s*$//;
            }
            else
            {
                # trim leading, trailing spaces
                $vv =~ s/^\s*//;
                $vv =~ s/\s*$//;
            }

            # fixup triple quoted strings
            if ($kk =~ m/^\_\_TQ\_FIXUP\_\_\s*/)
            {
                $vv = unquurl($vv);
                $kk =~ s/^\_\_TQ\_FIXUP\_\_\s*//;
            }

            # change value to its "long" (percent-encoded) form
            if ($kk =~ m/^keeplong\s*/i)
            {
                $vv = quurl2($vv);
                $kk =~ s/^keeplong\s*//;
            }

            # trim leading, trailing spaces
            $kk =~ s/^\s*//;
            $kk =~ s/\s*$//;

            # see what type of definition
            if ($kk =~ m/\w+\s+\w+/)
            {
                die "$lin: unknown define option in file $initfilnam"
                    if ($kk !~ m/^((def|define)|(jsondefine|jsondef|jdef)|(append|app)|(jsonappend|jsonapp|japp))\s+/i);

                my @defopt = ($kk =~ m/^(\w+)\s+\w+/);

                die "$lin: bad define option in file $initfilnam"
                    unless (1 == scalar(@defopt));

                my $dfo = shift @defopt;

                # trim def option prefix
                $kk =~ s/^$dfo\s*//;

                if ($dfo =~ m/^d/i)
                {
                    # do nothing...
                }
                elsif ($dfo =~ m/^j/i)
                {
                    # jsondef
                    $blong = 1;

                    # requote the value (do_cmdline_defs() will unquote)
                    $vv = quurl($vv);

                    if ($dfo =~ m/^jsonapp|japp/i)
                    {
                        # append
                        $delapp = 2;
                    }
                }
                elsif ($dfo =~ m/^a/i)
                {
                    # append
                    $delapp = 2;
                }
                else
                {
                    die "$lin: unknown define option \"$dfo\" in file $initfilnam";
                }

            } # end if type of definition


            my $defh = { $kk => $vv };

            do_cmdline_defs2($bop,
                            $argdef, $brzvz, $filnam, $bigh, $defh,
                            $blong, $delapp, $cdxfunc);

            push @{$ilist},
            {line => $lin,
             blong => $blong, key => $kk, delapp => $delapp, value => $vv };

        } # end else $lin =~ m/=/


##        print $lin, "\n";

    } # end for my lin

    return $ilist;

} # end do_initdefs_string

sub do_initdefs2
{
    my ($bop, $initfilnam, $argdef, $brzvz, $filnam, $bigh, $cdxfunc) = @_;

    my $infil;

    open ($infil, "< $initfilnam")
        or die "Could not open $initfilnam for reading : $! \n";

    # $$$ $$$ undefine input record separator (\n")
    # and slurp entire file into variable
    local $/;
    undef $/;

    my $bigstr = <$infil>;

    close $infil;

    return do_initdefs_string2($bop,
                              $bigstr,
                              $initfilnam, $argdef, $brzvz, $filnam, $bigh,
                              $cdxfunc);
}


# BREEZLY_UTILITYFUNCS_END

sub tush_find
{
    my ($bop, $fstyle) = @_;

    my $tush_dir = $bop->{homedir};
    my $actdir   = $bop->{actdir};
    my $hstdir   = $bop->{histdir};
    my $elfilnam = $bop->{elfile};

    my $bHistory = ($fstyle =~ m/history/i);


    # find all .cmd files in ACTIVE directory (or history)
    my $allfilstr   = 'ls -1c ' .
        (($bHistory) ? $hstdir : $actdir) . '/*.cmd';
    my $cmdstr      = $allfilstr . "";

    if ($fstyle =~ m/all|recent|active|ps|done|json/i)
    {
        # find active jobs in ps,
        $cmdstr =
            'ps auxww | grep TUSH | grep ACTIVE | grep -v "grep ACTIVE" ' ;

        # get the .out file, which is the last word of the giant
        # command string in the ps output, and convert it to .cmd
        $cmdstr .=
            ' | awk \'{print $NF}\' | sort | uniq ' .
            ' | sed \'s/out$/cmd/\' '
            if ($fstyle =~ m/all|recent|active|done|json/i);
    }
    my $allcmd   = `$cmdstr`;

    # for PS, just print out and exit
    if ($fstyle =~ m/ps/i)
    {
        print $allcmd, "\n";
        exit(0);
    }

    my %activeh; # for filtering active jobs
    my %bigh;

    my $bDone = ($fstyle =~ m/done/i);

    if ($fstyle =~ m/done|json|all|recent/i)
    {
        # build a hash of all active jobs
        for my $cmdfilnam (split(/\n/, $allcmd))
        {
#        print $cmdfilnam, "\n";
            my $hnam = $cmdfilnam . "";
            $hnam =~ s/\.cmd$//;
            $activeh{$hnam} = 1;
        }

        # get all .cmd files, and filter out active jobs from %activeh
        # in next loop
        $allcmd  = `$allfilstr`;
    }

    # for ACTIVE,  this is only active jobs from ps
    # for ALL,     this is all jobs from ACTIVE directory
    # for RECENT,  this is all recent jobs from ACTIVE directory
    # for HISTORY, this is all jobs from history directory
    # for DONE,    this is all jobs from ACTIVE directory, but use
    #              activeh hash to filter out active jobs from ps
    for my $cmdfilnam (split(/\n/, $allcmd))
    {
#        print $cmdfilnam, "\n";
        my $hnam = $cmdfilnam . "";
        $hnam =~ s/\.cmd$//;
        my $outnam = $hnam . ".out";

        my $bActive = 0;

        # for "done", skip all active jobs, so only list "done" jobs.
        # For cases other than json, all, recent the activeh hash is
        # not populated.
        if (exists($activeh{$hnam}))
        {
            next if ($bDone);
            $bActive = 1;
        }

        my $infil;

        open ($infil, "< $cmdfilnam")
            or die "Could not open $cmdfilnam for reading : $! \n";

        # $$$ $$$ undefine input record separator (\n")
        # and slurp entire file into variable
        local $/;
        undef $/;

        my $cmdstr = <$infil>;

        close $infil;

        chomp ($cmdstr);

        # remove newlines
        $cmdstr =~ s/\n/ /gm;

        $bigh{$hnam} = { cmdfil => $cmdfilnam, outfil => $outnam,
                         cmdstr => $cmdstr, isActive => $bActive };

    } # end for

    # NOTE: figure out elapsed time, command status, etc because this
    # function is called by tush_clean as "--tushfind=json" to build
    # the hash for the scoreboard
    while (my ($kk, $vv) = each(%bigh))
    {
        my $outnam = $vv->{outfil};

        $bigh{$kk}->{startdt} = "";

        my $c1 = "head -n 1 $outnam " . ' | grep TUSHSTART\: ' ;

        my $getstart = `$c1`;

        chomp ($getstart);
        my @foo = split(/\s+/, $getstart);

        next
            if (scalar(@foo) < 2);

        # get start date (iso8601) and start epoch seconds
        $bigh{$kk}->{startdt} = $foo[-2]; # iso8601 date
        $bigh{$kk}->{startep} = $foo[-1]; # epoch seconds

        $c1 = "tail -n 2 $outnam ";

        my $getend = `$c1`;

        if ($getend !~ m/TUSH_END\:\s+/gm)
        {
            # no END, so either active or aborted
            #
            # note: for fstyle=active, should only have active jobs in bigh
            if (
                ($fstyle =~ m/active/i) ||
                $bigh{$kk}->{isActive})
            {
                $bigh{$kk}->{status}  = "active";

                # track elapsed time for active jobs
                $bigh{$kk}->{elapsed} = time() - $bigh{$kk}->{startep};
            }
            else
            {
                $bigh{$kk}->{status}  = "aborted";
            }

            next;
        }

        my $bJobSuccess = ($getend =~ m/TUSH_SUCCESS\:/);

        for my $tlin (split(/\n/, $getend))
        {
            next unless ($tlin =~ m/TUSH_END\:\s+/);

            @foo = split(/\s+/, $getend);

            # XXX XXX: better have something, otherwise fake it
            if (scalar(@foo) < 2)
            {
                # make elapsed time zero by copying start time
                push @foo, $bigh{$kk}->{startep} + 0;
            }
        }

        my $cwdnam = $kk . ".cwd";
        if (-e $cwdnam)
        {
            my $cwddir = `head -n 1 $cwdnam`;
            chomp($cwddir);
            $bigh{$kk}->{cwd} = $cwddir;
        }

        my $wcall = `wc -l $outnam`;
        chomp($wcall);
        $wcall =~ s/^\s+//;
        my @wca = split(/\s+/, $wcall, 2);
        $bigh{$kk}->{flines} = $wca[0]
            if (2 == scalar(@wca));

        my $osname = $^O; # linux vs mac (darwin)
        my $fsz;
        if ($osname =~ m/darwin/)
        {
            # freebsd stat
            # file size in bytes
            $fsz = `stat -f%z $outnam`;
        }
        else ## linux (gnu stat)
        {
            $fsz = `stat --format=%B $outnam`;
        }
        chomp($fsz);
        $bigh{$kk}->{fsize}  = $fsz;

        # end epoch seconds
        $bigh{$kk}->{status}  = ($bJobSuccess) ? "SUCCESS" : "FAILED";
        $bigh{$kk}->{endep}   = $foo[-1];
        $bigh{$kk}->{elapsed} = $bigh{$kk}->{endep} - $bigh{$kk}->{startep}
    } # end while

    if ($fstyle =~ m/json/i)
    {
#        print Data::Dumper->Dump([\%bigh]);
        print breezly_json_encode_pretty($bop, \%bigh);
        exit(0);
    }

    my %stat1h = qw(
        active  A
        aborted B
        SUCCESS S
        FAILED  F
        );
    my %stat4h = qw(
        active  ACTV
        aborted ABRT
        SUCCESS SUCC
        FAILED  FAIL
        );


    my $checkRecent; # undef unless tushfind=recent

    # define a 3 hr cutoff for "recent" jobs
    if ($fstyle =~ m/recent/i)
    {
#        $checkRecent = `date -v -1M "+%Y%m%dT%H%M%S "`;
#        $checkRecent = `date -v -3H "+%Y%m%dT%H%M%S "`;
        # use epoch seconds
        $checkRecent = time() - (3 * 60 * 60);

        # XXX XXX: do this by endep, but handle the abort case -- want
        # to see all jobs that *ended* recently, ie in the last N
        # hours, or are still active, but aborted jobs don't have an
        # enddt or endep
        #
        # define tushrecent=x hr/x min?
    }

    # sort by start time,
    # print in "find grep" format, with a null terminator after the file name
    for my $kk (sort { $bigh{$a}->{startdt} cmp $bigh{$b}->{startdt}} keys %bigh)
    {
        my $vv = $bigh{$kk};

        # skip non-recent jobs
        if (defined($checkRecent) &&
            (
             (!exists($vv->{status})) ||
             (exists($vv->{status}) &&
              (($vv->{status}) ne "active"))
            ))
        {
            # check if recently finished
            if (exists($vv->{endep}))
            {
                next
                    unless ($checkRecent lt $vv->{endep});
            }
            else # not finished, but not active
            {
                # if job aborted, use start time
                if (exists($vv->{startep}))
                {
                    next
                        unless ($checkRecent lt $vv->{startep});
                }
            }
        } # end if checkrecent

        my $statcode = " ";
        $statcode = $stat1h{$vv->{status}}
            if (exists($vv->{status}) &&
                exists($stat1h{$vv->{status}}));

        my $stat4code = "    ";
        $stat4code = $stat4h{$vv->{status}}
            if (exists($vv->{status}) &&
                exists($stat4h{$vv->{status}}));

        my $elapt = "";

        $elapt = compact_human_duration($vv->{elapsed})
            if (($statcode =~ m/a|s|f/i) &&
                exists($vv->{elapsed}));

        # list the file, startline (1), date, single char status code,
        # and command string for "find grep"
        # plus 4 char status, elapsed time
        print $vv->{outfil}, "\x00", "1: ",
            $vv->{startdt}, " ", $statcode, " ",
            $vv->{cmdstr},  " ", $stat4code, " ", $elapt,
            "\n";
    }
#    print Data::Dumper->Dump([\%bigh]);

    exit(0);
} # end tush_find

sub get_uuid
{
    my $prefix = shift;

    $prefix = "" unless defined($prefix);

    # NOTE: "chomp" won't work if you use "local $/" to
    # undefine the input record separator (aka \n).  So
    # don't do that...
    my $uuid = `uuidgen`;
    $uuid =~ s/\n$//; # chomp
    $uuid =  $prefix . uc($uuid); # linux vs mac

    return $uuid;
} # end get_uuid

sub get_tush_dir
{
    my $tushdir =
        File::Spec->catfile($ENV{HOME},
                            ".tush_dir");

    return $tushdir;
} # end get_tush_dir

sub mkdir_or_die
{
    my ($bop, $nam) = @_;

    unless (-e $nam)
    {
        `mkdir $nam`;
    }

    die "no such directory: $nam"
        unless (-e $nam);
}

sub setup_emacs
{
    my ($bop, $tush_dir) = @_;

    # extra ".emacs" file to force automatic "tail mode"
    # for .out files
    my $elfilnam = File::Spec->catfile($tush_dir,
                                       "tush.el");

    # XXX XXX: add force to force recreate
    return $elfilnam
        if (-e $elfilnam);

    my $bigstr = << 'EOF_bigstr';
;; Generated by tush.pl version {TUSH_VERSION}
;; on {TUSH_DATE}

(add-to-list 'auto-mode-alist '("\\.out\\'" . auto-revert-tail-mode))

EOF_bigstr

    my $dt  = localtime();
    my $vzn = $bop->{_defs}->{version}->{number};

    my $elstr = doformat($bigstr,
                         {
                             TUSH_VERSION => $vzn,
                             TUSH_DATE    => $dt
                         });

    my $elfil;

    open ($elfil, "> $elfilnam") or
        die "Could not open $elfilnam for writing : $! \n";

    print $elfil $elstr;

    close $elfil;

    return $elfilnam;
} # end setup_emacs

sub setup_env
{
    my $bop = shift;

    my $tush_dir = get_tush_dir();

    mkdir_or_die($bop, $tush_dir);

    my $elfilnam = setup_emacs($bop, $tush_dir);

    my $actdir =
        File::Spec->catfile($tush_dir,
                            "ACTIVE");
    mkdir_or_die($bop, $actdir);

    my $hstdir =
        File::Spec->catfile($tush_dir,
                            "history");
    mkdir_or_die($bop, $hstdir);

    $bop->{homedir} = $tush_dir;
    $bop->{actdir}  = $actdir;
    $bop->{histdir} = $hstdir;
    $bop->{elfile}  = $elfilnam;
} # end setup_env

## use emacs in auto revert tail on active .out files
## versus "less +F $actfil"
sub tush_tail
{
    my ($bop, $tstyle) = @_;

    my $tush_dir = $bop->{homedir};
    my $elfilnam = $bop->{elfile};
    my $tushexe  = $0;

    # use "tushfind" to simulate "find grep", and use
    # tush.el to force auto-revert-tail-mode on .out files
    my $estr = "emacs -l $elfilnam " .
        ' --exec \'(find-grep "' . $tushexe .  ' --tushfind ' . $tstyle . ' ")\' ';

    exec ($estr);
} # end tush_tail

# initialize statistics hash - scoreboard helper function
sub doscbdstatinit
{
    my $bop = shift;

    my $stath = {};

    $stath->{count}  = 0;
    $stath->{avg}    = 0;
    $stath->{max}    = 0;
    $stath->{min}    = undef;
    $stath->{stddev} = 0;
    $stath->{sum}    = 0;

    # https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
    # calculate variance in a crappy way using sum of squares...
    $stath->{sumsq}  = 0;
    $stath->{var}    = 0;

    return $stath;
} # end doscbdstatinit

# aggregate value in statistics hash - scoreboard helper function
sub doscbdstatagg
{
    my ($bop, $stath, $val) = @_;

    $stath->{count} += 1;

    $stath->{min} = $val
        unless (defined($stath->{min}));

    $stath->{min} = $val if ($stath->{min} > $val);
    $stath->{max} = $val if ($stath->{max} < $val);

    $stath->{sum}    += $val;
    $stath->{sumsq}  += ($val * $val);
} # end doscbdstatagg

# merge two statistics hashes
# merge left
sub doscbdstatmerge
{
    my ($bop, $stath, $stath2) = @_;

    $stath->{count} += $stath2->{count};

    if (defined($stath->{min}) ||
        defined($stath2->{min}))
    {
        $stath->{min} = $stath2->{min}
            unless (defined($stath->{min}));

        $stath->{min} = $stath2->{min}
            if (defined($stath2->{min}) &&
                ($stath->{min} > $stath2->{min}));
    }
    $stath->{max} = $stath2->{max}
        if ($stath->{max} < $stath2->{max});

    $stath->{sum}    += $stath2->{sum};
    $stath->{sumsq}  += $stath2->{sumsq};
} # end doscbdstatmerge

# finalize statistics hash - scoreboard helper function
sub doscbdstatfinal
{
    my ($bop, $stath, $humane) = @_;

    my $ct = $stath->{count};

    # arithmetic mean
    $stath->{avg}    = $stath->{sum}/$ct if ($ct > 0);

    if ($ct > 1)
    {
        $stath->{var}    =
            ($stath->{sumsq} - ($stath->{sum} * $stath->{sum})/$ct)/($ct - 1);
        # NOTE: see SSDBM18-covariance-authorcopy.pdf
        # Numerically Stable Parallel Computation of (Co-)Variance
        # Erich Schubert, Michael Gertz
        # for a better approach...
    }
    $stath->{stddev} = sqrt($stath->{var});

    if (defined($humane))
    {
        # assuming time values in seconds, convert to human-readable
        # values
        if ($humane =~ m/^time/i)
        {
#            use Time::Seconds;

            my %hh;

            for my $jj (qw(avg max min stddev))
            {
                #                my $ts1 = Time::Seconds->new($stath->{$jj});
                #                $hh{$jj} = $ts1->pretty;
                my $ts1 = compact_human_duration($stath->{$jj});
                $hh{$jj} = $ts1;
            }
            $stath->{human} = \%hh;
        }

    }

} # end doscbdstatfinal


sub doscoreboard
{
    my ($bop, $bigh) = @_;

    use File::Basename;

    #    print Data::Dumper->Dump([$bigh]);

    my $scbd  = {}; # scoreboard
    my $doneh = {}; # donejobs (emended bigh)
    my $mindt = 0;
    my $maxdt = 0;

    my $tm    = time();

    while (my ($kk, $vv) = each(%{$bigh}))
    {
        next unless (exists($vv->{cmdstr}));

        # only want done jobs - not active
        next unless (exists($vv->{status}) &&
                     ($vv->{status} !~ m/active/i));

        # XXX XXX: besides active jobs, exclude recent jobs
        # TODO: establish a cutoff - older than 1 day? 3 days?
        # make this an option.
        # Currently moves all inactive (done/aborted) jobs to history
        if (exists($vv->{startep}))
        {
            if (0 == $mindt)
            {
                $mindt = $vv->{startep};
            }
            $mindt = $vv->{startep} if ($mindt > $vv->{startep});
            $maxdt = $vv->{startep} if ($maxdt < $vv->{startep});
        }

        my $k2 = basename($kk);

        $doneh->{$k2} = $vv;

        # check for current working dir file (cwd)
        my $cwdfil = $kk . ".cwd";

        $vv->{cwdfil} = basename($cwdfil)
            if (-e $cwdfil);

        # fix other names
        $vv->{cmdfil} = basename($vv->{cmdfil})
            if (exists($vv->{cmdfil}));
        $vv->{outfil} = basename($vv->{outfil})
            if (exists($vv->{outfil}));

        my @cmd = split(/\s+/, $vv->{cmdstr}, 2);

        next unless (scalar(@cmd));

        my $cmd1 = $cmd[0];

        $scbd->{$cmd1} = {joba => [] }
            unless (exists($scbd->{$cmd1}));

        push @{$scbd->{$cmd1}->{joba}}, $k2;
    } # end while bigh

    # build a scoreboard for the jobs
    while (my ($kk, $vv) = each(%{$scbd}))
    {
        my $jsuc = 0;      # number of successful jobs
        my $jfal = 0;      # number of failed     jobs
        my $jabt = 0;      # number of aborted    jobs

        $vv->{flines} = doscbdstatinit($bop); # file line count
        $vv->{fsize}  = doscbdstatinit($bop); # file size in bytes
        $vv->{time}   = doscbdstatinit($bop); # elapsed time for job

        for my $jobnam (@{$vv->{joba}})
        {
            next unless (exists($doneh->{$jobnam}) &&
                         exists($doneh->{$jobnam}->{status}));

            # find failed or aborted jobs
            # they aren't part of the min/max/sum statistics...
            if ($doneh->{$jobnam}->{status} !~ m/SUCCESS/)
            {
                $jabt += 1 if ($doneh->{$jobnam}->{status} =~ m/aborted/);
                $jfal += 1 if ($doneh->{$jobnam}->{status} =~ m/FAIL/);
                next;
            }

            # aggregate stats for successful jobs only
            $jsuc += 1;

            doscbdstatagg($bop, $vv->{flines}, $doneh->{$jobnam}->{flines});
            doscbdstatagg($bop, $vv->{fsize},  $doneh->{$jobnam}->{fsize});
            doscbdstatagg($bop, $vv->{time},   $doneh->{$jobnam}->{elapsed});
        } # end for my jobnam

        $vv->{numsuc}   = $jsuc;
        $vv->{numfail}  = $jfal;
        $vv->{numabort} = $jabt;
        $vv->{totnum}   = scalar(@{$vv->{joba}});

        # finalize statistics - avg, var, stddev
        doscbdstatfinal($bop, $vv->{flines});
        doscbdstatfinal($bop, $vv->{fsize});
        doscbdstatfinal($bop, $vv->{time}, "time");

    } # end while each scbd

#    print Data::Dumper->Dump([$scbd]);

    my $timh = {};

    $timh->{min_job} = {};
    $timh->{max_job} = {};
    $timh->{scbd}    = {};

    $timh->{num_scbd} = 1;

    $timh->{scbd}->{numjobs} = scalar(keys(%{$doneh}));

    my $vzn = $bop->{_defs}->{version}->{number};

    $timh->{_generator} = "tush.pl version $vzn";

    do_scoreboard_timespan($bop, $timh, $mindt, $maxdt);

    return { scoreboard => $scbd, donejobs => $doneh,
             date_stats => $timh
    };

} # end doscoreboard

# helper function for doscoreboard
sub do_scoreboard_timespan
{
    my ($bop, $timh, $mindt, $maxdt) = @_;

#    use Time::Seconds;

    $timh->{min_job}->{tm}  = $mindt;
    $timh->{min_job}->{dt}  = localtime($mindt);
    $timh->{max_job}->{tm}  = $maxdt;
    $timh->{max_job}->{dt}  = localtime($maxdt);
    $timh->{scbd}->{tm}     = time();
    $timh->{scbd}->{dt}     = localtime();

    my $elap1 = $maxdt - $mindt;

    $timh->{scbd}->{span} = {};
    $timh->{scbd}->{span}->{secs}  = $elap1;

    #    my $ts1 = Time::Seconds->new($elap1);
    #     $timh->{scbd}->{span}->{human} = $ts1->pretty;
    my $ts1 = compact_human_duration($elap1);
    $timh->{scbd}->{span}->{human} = $ts1;

} # end do_scoreboard_timespan

sub get_old_almanack_name
{
    my ($bop, $actdir, $hstdir) = @_;

    # Note: find -L follow soft link
    my $fndstr = << 'EOF_fndstr';
find -L {DONEDIR} -name '*.lmak' | sort -r
EOF_fndstr

    my $fndcmd = doformat($fndstr,
                          {
                              DONEDIR => $hstdir
                          });
        #        print $fndcmd, "\n";
    my $allalm = `$fndcmd`;

    return undef
        unless(defined($allalm) &&
               length($allalm));

    my @foo = split(/\n/, $allalm);

    return undef
        unless (scalar(@foo) &&
                (-e $foo[0]));

    my $alnam = $foo[0];

    return $alnam ;
} # end get_old_almanack_name

sub get_old_almanack
{
    my ($bop, $actdir, $hstdir) = @_;

    my $alnam = get_old_almanack_name($bop, $actdir, $hstdir);
    return undef
        unless(defined($alnam) &&
               length($alnam));

    my $alfil;

    open ($alfil, "< $alnam")
        or die "Could not open $alnam for reading : $! \n";

    # $$$ $$$ undefine input record separator (\n")
    # and slurp entire file into variable
    local $/;
    undef $/;

    my $fullfil = <$alfil>;

    close $alfil;

    my $almnkh = breezly_json_decode($bop, $fullfil);

#    print Data::Dumper->Dump([$almnkh]);

    return $almnkh;

} # end get_old_almanack

# merge the old almanack into scbdh
sub merge_almanack
{
    my ($bop, $scbdh, $old_almnk) = @_;

    return
        unless (defined($scbdh) &&
                exists($scbdh->{date_stats}));

    my $timh    = $scbdh->{date_stats};

    $timh->{almanack}->{tm}     = time();
    $timh->{almanack}->{dt}     = localtime();

    return
        unless(defined($old_almnk) &&
               defined($scbdh));

    my $oldtimh = $old_almnk->{date_stats};

    $timh->{num_scbd}        += $oldtimh->{num_scbd};
    $timh->{scbd}->{numjobs} += $oldtimh->{scbd}->{numjobs};

    my $mindt = ($timh->{min_job}->{tm} < $oldtimh->{min_job}->{tm}) ?
        $timh->{min_job}->{tm} : $oldtimh->{min_job}->{tm};

    my $maxdt = ($timh->{max_job}->{tm} > $oldtimh->{max_job}->{tm}) ?
        $timh->{max_job}->{tm} : $oldtimh->{max_job}->{tm};

    my $vzn = $bop->{_defs}->{version}->{number};

    $timh->{_generator} = "tush.pl version $vzn";

    do_scoreboard_timespan($bop, $timh, $mindt, $maxdt);


    # merge stats from matching jobs from almanack
    # to scbdh (newalmanack)
    while (my ($kk, $vv) = each(%{$scbdh->{scoreboard}}))
    {
        next unless (exists($old_almnk->{scoreboard}) &&
                     exists($old_almnk->{scoreboard}->{$kk}));

        doscbdstatmerge($bop, $vv->{flines}, $old_almnk->{scoreboard}->{$kk}->{flines});
        doscbdstatmerge($bop, $vv->{fsize},  $old_almnk->{scoreboard}->{$kk}->{fsize});
        doscbdstatmerge($bop, $vv->{time},   $old_almnk->{scoreboard}->{$kk}->{time});

        $vv->{numabort} += $old_almnk->{scoreboard}->{$kk}->{numabort};
        $vv->{numfail}  += $old_almnk->{scoreboard}->{$kk}->{numfail};
        $vv->{numsuc}   += $old_almnk->{scoreboard}->{$kk}->{numsuc};
        $vv->{totnum}   += $old_almnk->{scoreboard}->{$kk}->{totnum};
    }

    # copy stats from non-matching jobs from almanack
    # to scbdh (newalmanack)
    while (my ($kk, $vv) = each(%{$old_almnk->{scoreboard}}))
    {
        next if (exists($scbdh->{scoreboard}) &&
                 exists($scbdh->{scoreboard}->{$kk}));

        $scbdh->{scoreboard}->{$kk} =
                        $old_almnk->{scoreboard}->{$kk};
    }

    while (my ($kk, $vv) = each(%{$scbdh->{scoreboard}}))
    {
        doscbdstatfinal($bop, $vv->{flines});
        doscbdstatfinal($bop, $vv->{fsize});
        doscbdstatfinal($bop, $vv->{time}, "time");
    }

} # end merge_almanack

# as it is deleted, merge the scoreboard stats into a new almanack
sub do_almanack
{
    my ($bop, $actdir, $hstdir, $scbdh) = @_;

    my $old_almnk = get_old_almanack($bop, $actdir, $hstdir);

    my $tm    = time();
    my $alnam = File::Spec->catfile($hstdir, "almanack_". $tm . ".lmak");

    # cleanup donejobs hash and all scoreboard entries joba array -
    # only want to rollup historical stats
    delete $scbdh->{donejobs}
        if (exists($scbdh->{donejobs}));

    while (my ($kk, $vv) = each(%{$scbdh->{scoreboard}}))
    {
        delete $scbdh->{scoreboard}->{$kk}->{joba}
            if (exists($scbdh->{scoreboard}->{$kk}->{joba}));
    }

    # merge old almanack stats in scbdh (new almanack)
    merge_almanack($bop, $scbdh, $old_almnk);

    my $alfil;

    open ($alfil, "> $alnam")
        or die "Could not open $alnam for writing : $! \n";

    print $alfil breezly_json_encode_pretty($bop, $scbdh);

    close $alfil;

} # end do_almanack

# helper for tush_clean
#
# split a jsref (perl hash ref derived from tush json)
# into daily slices, skipping (retaining) jobs within
# the "retain" time in seconds
#
# returns a date ordered array of hashes, where each hash contains the
# completed jobs for a single slice
#
sub split_jsref
{
    my ($bop, $jsref, $slice, $retain) = @_;
    my $jsa = [];
    my %sliceh;

    # NOTE: ignore "slice" option - only does "DAY"

    my $rtdt = time() - $retain;

    while (my ($kk, $vv) = each(%{$jsref}))
    {
#        print $kk, "\n";
        next
            unless (exists($vv->{endep}) &&
                    ($vv->{endep} < $rtdt));

        my $ymd; # iso 8601 string for the slice corresponding to the
                 # end epoch, eg YYYYMMDD for a daily slice
        {
            my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                localtime($vv->{endep});
            $mon++;
            $mon  = "0" . $mon  if ($mon  < 10);
            $mday = "0" . $mday if ($mday < 10);
            my $yy = $year += 1900;
            $ymd = $yy . $mon . $mday;
        }
#        print $ymd, "\n";

        $sliceh{$ymd} = {}
            unless (exists($sliceh{$ymd}));

        # can just copy in the kk, vv values because tushid's are
        # unique
        $sliceh{$ymd}->{$kk}=$vv;

    } # end while kk,vv

#    print Data::Dumper->Dump([\%sliceh]);

    # load the jsa array with the hash for each slice
    for my $ddt (sort(keys(%sliceh)))
    {
#        print $ddt, "\n";
        push @{$jsa} , $sliceh{$ddt};
    }

#    print Data::Dumper->Dump($jsa);

    return $jsa;
} # end split_jsref

sub tush_clean_move
{
    my ($bop, $actdir, $hstdir, $filnam) = @_;

    my $srcfil = File::Spec->catfile($actdir, $filnam);

    if (-e $srcfil)
    {
        print "mv $srcfil $hstdir\n";
        `mv $srcfil $hstdir`;
    }

} # end tush_clean_move

sub tush_clean_rm
{
    my ($bop, $dirnam, $filnam) = @_;

    my $srcfil = File::Spec->catfile($dirnam, $filnam);

    if (-e $srcfil)
    {
        print "rm $srcfil\n";
        `rm $srcfil`;
    }

} # end tush_clean_rm

# tush_clean
#
# retain: clean all jobs older than the retention period
#
# slice: range of time for a scoreboard
#
# for clean ACTIVE, retain the last day, and slice cleanup
# into a scoreboard for each day.
#
# for clean DONE, retain the last 2 weeks
sub tush_clean
{
    my ($bop, $cstyle) = @_;

    my $tush_dir = $bop->{homedir};
    my $actdir   = $bop->{actdir};
    my $hstdir   = $bop->{histdir};

    my $bActive  = ($cstyle =~ m/active/i);

    my $jsref;
    my $scbd;

    # move done jobs from ACTIVE directory to history
    if ($bActive)
    {
        my $jstr = `$0 --tushfind json`;

        die "bad json"
            unless (defined($jstr) &&
                    length($jstr));
        #        print $jstr;
        $jsref = breezly_json_decode($bop, $jstr);
        #        print Data::Dumper->Dump([$jsref]);

        # slice the active "done jobs" hash into daily chunks,
        # retaining (skipping) the last 24 hours (60*60*24 seconds)
        my $jsa = split_jsref($bop, $jsref, "DAY", 60*60*24);

        # create a separate scoreboard for each daily slice
        for my $js1 (@{$jsa})
        {
            $scbd = doscoreboard($bop, $js1);

            # don't write a scoreboard file if no jobs!
            if (exists($scbd->{donejobs}) &&
                scalar(keys(%{$scbd->{donejobs}})))
            {
                my $uuid = get_uuid("TUSH-");
                my $scbdfilnam =
                    File::Spec->catfile($hstdir, $uuid . ".scbd");
                my $scbdfil;

                open ($scbdfil, "> $scbdfilnam")
                    or die "Could not open $scbdfilnam for writing : $! \n";

                print $scbdfil breezly_json_encode_pretty($bop, $scbd);

                close $scbdfil;

                while (my ($kk, $vv) = each(%{$scbd->{donejobs}}))
                {
                    # XXX XXX: check endep for retention

                    tush_clean_move($bop, $actdir, $hstdir, $vv->{cmdfil})
                        if (exists($vv->{cmdfil}));
                    tush_clean_move($bop, $actdir, $hstdir, $vv->{cwdfil})
                        if (exists($vv->{cwdfil}));
                    tush_clean_move($bop, $actdir, $hstdir, $vv->{outfil})
                        if (exists($vv->{outfil}));
                } # end while
            } # end if scbd->donejobs
        } # end for my js1

        exit(0);
    } # end if active

    ## was: stat -f '%Sm %N' -t %Y%m%d%H%M%S

    my $osname = $^O; # linux vs mac (darwin)
    my $statcmd;

    if ($osname =~ m/darwin/)
    {
        # freebsd stat
        # display timestamp (-t) in epoch form (%s) and print as a string
        # for modification time (%Sm) plus the filename (%N)
        $statcmd = << 'EOF_statdarwin';
stat -f '%Sm %N' -t %s
EOF_statdarwin
    }
    else ## linux (gnu stat)
    {
        # get modification time in epoch form plus the filename
        $statcmd = << 'EOF_statlinux';
stat --format='%Y %n'
EOF_statlinux
    }
    chomp($statcmd); # remove newline

    # stat: get modification time in epoch form plus the filename
    # Note: find -L follow soft link
    my $fndstr = << 'EOF_fndstr';
find -L {DONEDIR} -name '*.{FILTYP}' | xargs {STATCMD} | sort -n
EOF_fndstr

    # remove old done jobs from history directory
    if ($cstyle =~ m/done/i)
    {
        my $tm = time(); # seconds since epoch

        my $fndcmd = doformat($fndstr,
                              {
                                  DONEDIR => $hstdir,
                                  FILTYP  => "scbd",
                                  STATCMD => $statcmd
                              });
        #        print $fndcmd, "\n";
        my $allscbd = `$fndcmd`;

        my @scfils = split(/\n/, $allscbd);

        # for ordered list of scoreboards
        for my $sclin (@scfils)
        {
#            print $sclin, "\n";
            my @baz = split(/\s+/, $sclin, 2);

#            print Data::Dumper->Dump(\@baz);

            # XXX XXX: establish a retention policy.  Only cleanup
            # files if older than XXX days.  Currently removes all
            # files from oldest scoreboard.

            my $scbdfilnam = $baz[1];

            next unless (-e $scbdfilnam);

            my $scbdfil;

            open ($scbdfil, "< $scbdfilnam")
                or die "Could not open $scbdfilnam for reading : $! \n";

            # $$$ $$$ undefine input record separator (\n")
            # and slurp entire file into variable
            local $/;
            undef $/;

            my $allfil = <$scbdfil>;

            close $scbdfil;

            my $scbdh = breezly_json_decode($bop, $allfil);

            #            print Data::Dumper->Dump([$scbdh->{donejobs}]);
            next unless (defined($scbdh) &&
                         exists($scbdh->{donejobs}));

            while (my ($kk, $vv) = each(%{$scbdh->{donejobs}}))
            {
                tush_clean_rm($bop, $hstdir, $vv->{cmdfil})
                    if (exists($vv->{cmdfil}));
                tush_clean_rm($bop, $hstdir, $vv->{cwdfil})
                    if (exists($vv->{cwdfil}));
                tush_clean_rm($bop, $hstdir, $vv->{outfil})
                    if (exists($vv->{outfil}));

            }
            use File::Basename;
            my $bnam = basename($scbdfilnam);
            tush_clean_rm($bop, $hstdir, $bnam);

            # add the stats from the deleted scoreboard to an almanack
            do_almanack($bop, $actdir, $hstdir, $scbdh);

            last;
        }

        exit(0);
    } # end if done

    if ($cstyle =~ m/almanack/i)
    {
        my $tm = time(); # seconds since epoch

        my $fndcmd = doformat($fndstr,
                              {
                                  DONEDIR => $hstdir,
                                  FILTYP  => "lmak",
                                  STATCMD => $statcmd
                              });
        #        print $fndcmd, "\n";
        my $allmak = `$fndcmd`;

        my @mkfils = split(/\n/, $allmak);

        exit(0)
            unless (2 < scalar(@mkfils));

        # for ordered list of almanacks
        for my $mklin (@mkfils)
        {
#            print $mklin, "\n";

            my @baz = split(/\s+/, $mklin, 2);

#            print Data::Dumper->Dump(\@baz);

            # XXX XXX: establish a retention policy.  Only cleanup
            # files if older than XXX days.  Currently removes oldest
            # almanack

            my $mkfilnam = $baz[1];

            next unless (-e $mkfilnam);

            use File::Basename;
            my $bnam = basename($mkfilnam);
            tush_clean_rm($bop, $hstdir, $bnam);

            last;
        }
        exit(0);
    } # end if almanack

    exit(0);
} # end tush_clean

sub tush_cat_almanack
{
    my ($bop, $alk) = @_;

    my $tush_dir = $bop->{homedir};
    my $actdir   = $bop->{actdir};
    my $hstdir   = $bop->{histdir};

    my $alnam = get_old_almanack_name($bop, $actdir, $hstdir);

    if (defined($alnam) &&
        length($alnam) &&
        (-e $alnam))
    {
        exec("cat $alnam");
    }

    exit(0);
} # end tush_cat_almanack

sub pretty_print_stats
{
    my ($bop, $stath) = @_;

    print Data::Dumper->Dump([$stath]);
} # end pretty_print_stats

sub get_stats
{
    my ($bop, $jobnamstr) = @_;

    my $tush_dir = $bop->{homedir};
    my $actdir   = $bop->{actdir};
    my $hstdir   = $bop->{histdir};

    my $old_almnk = get_old_almanack($bop, $actdir, $hstdir);

    return undef
        unless (defined($old_almnk) &&
                defined($jobnamstr) &&
                length($jobnamstr));

    $jobnamstr =~ s/^\s+//;
    $jobnamstr =~ s/\s+$//;

    my $jobnam = $jobnamstr;

    if ($jobnamstr =~ m/\s/)
    {
        my @foo = split(/\s+/, $jobnamstr);
        $jobnam = $foo[0];
    }

    return undef
        unless (defined($jobnamstr) &&
                length($jobnamstr));

    return ($old_almnk->{scoreboard}->{$jobnam})
        if (exists($old_almnk->{scoreboard}) &&
            exists($old_almnk->{scoreboard}->{$jobnam}));

    return undef;
} # end get_stats

sub print_stats
{
    my ($bop, $jobnamstr) = @_;

    my $jobstats = get_stats($bop, $jobnamstr);
    exit(1)
        unless (defined($jobstats));

    pretty_print_stats($bop, $jobstats);

    exit(0);
} # end print_stats

# compact human duration
#
# convert seconds to ISO8601 "P" duration of fixed length
#
# hours/minutes/seconds as PT99H99M99S
# longer intervals [D]ay, [W]eek, [Y]ear, eg
# P99.99D
#
# max year 99999
#
# supports negative duration
#
# aka chud
sub compact_human_duration
{
    my $elap    = shift;
    my $ehumstr = "";
    my $isMinus = " "; # lead space for positive durations, else "-"

    # deal with uninitialized elapsed time for failed/aborted jobs
    $elap = 0 unless (defined($elap));

    if ($elap < 0)
    {
        $isMinus = "-";
        $elap = $elap * -1;
    }

    # compact human duration array, in order of largest interval to
    # smallest, eg years, weeks, days
    my $chda = [
        [86400*365.25, "Y"], # year
        # NOTE: no months to prevent confusion with minutes
        [86400*7,      "W"], # week
        [86400,        "D"]  # day
        ];

    # loop over an array of durations (largest to smallest).
    #
    # if the elapsed time is larger than the interval, divide it by
    # that value and present it as a fixed precision decimal, followed
    # by the name for the unit.  For example, a day has 86400 seconds.
    # if the elapsed time is > 86400, calculated elapsed/86400 as the
    # number of days, and return something like "P03.13D" for 3.13 days.
    for my $drtn (@{$chda})
    {
        my $drsecs = $drtn->[0];
        my $drnam  = $drtn->[1];

        # don't break on the exact "border" of the interval, eg go
        # from 6.99D to 1.00W, because numeric rounding may give
        # improper perception of precision.  So switch from 8.10D to
        # 01.32W for example.
        next
            unless ($elap > (1.3*$drsecs));

        my $numdr = $elap/$drsecs;

        if ($numdr < 99)
        {
            $ehumstr = sprintf("%02.2f", $numdr);
        }
        else # allow potentially large years
        {
            $ehumstr = sprintf("%05f", $numdr);

            # NOTE: could use SI prefixes if necessary
            # Kilo Mega Giga Tera Peta Exa Zetta Yotta Ronna Quetta
            #  3    6    9   12   15   18  21    24    27    30
        }

        # XXX XXX: prepend a zero
        if (length($ehumstr) < 5)
        {
            $ehumstr = '0' . $ehumstr;
        }

        # pad to keep all strings as same length
        #
        # P99.99Y
        # P99.99W
        # PT41M12S
        $ehumstr  = $isMinus . "P" . $ehumstr . $drnam . " ";

        return $ehumstr;
    } # end for my $drtn

    my $ehr = 0;
    my $emi = 0;

    $ehr  = (int $elap/3600);    # integer hours
    $elap = (int $elap%3600);    # remainder (less than an hour)
    $emi  = (int $elap/60);      # integer minutes
    $elap = (int $elap%60);      # remaining seconds

    # PT 99H 99M 99S
    # NOTE: it's a duration not a time so hours can exceed 24
    # NOTE2: use lowercase hms for readability

    ##       $ehumstr = sprintf("PT%02dH%02dM%02dS", $ehr, $emi, $elap;)
    if ($ehr > 0)
    {
        $ehumstr = sprintf("%sPT%02dh%02dm", $isMinus, $ehr, $emi);
    }
    else
    {
        $ehumstr = sprintf("%sPT%02dm%02ds", $isMinus, $emi, $elap);
    }

    return $ehumstr;
} # end compact_human_duration

sub tush_track
{
    my ($bop, $ttrack) = @_;

    my $jsref;

    my $jstr = `$0 --tushfind json`;

    die "bad json"
        unless (defined($jstr) &&
                length($jstr));

    $jsref = breezly_json_decode($bop, $jstr);

    while (my ($kk, $vv) = each(%{$jsref}))
    {
        next
            unless (exists($vv->{isActive}) &&
                    $vv->{isActive});

        print "job: " . $vv->{cmdstr} . "\n";
        my $elap = 0;

        if (exists($vv->{elapsed}))
        {
            print "elapsed: " . compact_human_duration($vv->{elapsed}) . " ";
            $elap = $vv->{elapsed};
        }

        my $jobstats = get_stats($bop, $vv->{cmdstr});

        unless (defined($jobstats))
        {
            # need eol for "elapsed" print statment if no avg/max
            # stats...
            print "\n\n";
            next;
        }

        my $avg = $jobstats->{time}->{avg};
        my $mxx = $jobstats->{time}->{max};

        print "avg: " . compact_human_duration($avg) . " ";
        print "max: " . compact_human_duration($mxx) . "\n";

        if ($elap)
        {
            printf "avg completion: [%.2f",
                (100 - ((($avg - $elap)*100)/$avg));
            print "%] " .
                compact_human_duration($avg - $elap) . " remaining\n";

            printf "max completion: [%.2f",
                (100 - ((($mxx - $elap)*100)/$mxx));
            print "%] " .
                compact_human_duration($mxx - $elap) . " remaining\n";
        }
        print "\n";
    } # end while
    exit(0);
} # end tush_track

# MAIN
if (1)
{
    my $bop = $breezly_optdef_h;

    # make tush dir
    # cleanup old stuff
    # tush uuid
    # tush noargs tails last open item for this pid
    setup_env($bop);

    tush_find($bop, $bop->{tushfind})
        if (defined($bop->{tushfind}) &&
            exists($bop->{tushfind}));

    tush_tail($bop, $bop->{tushtail})
        if (defined($bop->{tushtail}) &&
            exists($bop->{tushtail}));

    tush_clean($bop, $bop->{tushclean})
        if (defined($bop->{tushclean}) &&
            exists($bop->{tushclean}));

    tush_cat_almanack($bop, $bop->{tushalmanack})
        if (defined($bop->{tushalmanack}) &&
            exists($bop->{tushalmanack}));

    print_stats($bop, $bop->{tushstatistics})
        if (defined($bop->{tushstatistics}) &&
            exists($bop->{tushstatistics}));

    tush_track($bop, $bop->{tushtrack})
        if (defined($bop->{tushtrack}) &&
            exists($bop->{tushtrack}));

    if (!scalar(@ARGV))
    {
        tush_tail($bop, "recent");
    }
    else
    {
        my $uuid = get_uuid("TUSH-");

        # substitute quote characters in ARGV
        ##        my @arjv = map {local $_ = $_; s/QQ/\\\'/gm ; $_ } @ARGV ;
        ##        my @arjv = map {local $_ = $_; printf("%q", $_) } @ARGV ;

        ##        my $cmd = join(" ", @arjv);
        my $cmd = join(" ", @ARGV);

        print $cmd, "\n";

        my $outfil =
            File::Spec->catfile($bop->{actdir}, $uuid . ".out");

        my $cwdfilnam =
            File::Spec->catfile($bop->{actdir}, $uuid . ".cwd");
        my $cmdfilnam =
            File::Spec->catfile($bop->{actdir}, $uuid . ".cmd");

        # save current working directory and hostname
        if (1)
        {
            use Cwd;

            my $cfil;

            open ($cfil, "> $cwdfilnam")
                or die "Could not open $cwdfilnam for writing : $! \n";

            my $cwdnam = getcwd();

            # get hostname
            my $hnam   = `uname -n`;
            chomp($hnam);

            print $cfil $hnam, ":", $cwdnam, "\n";

            close $cfil;
        }

        # save command string in file
        if (1)
        {
            my $cfil;

            open ($cfil, "> $cmdfilnam")
                or die "Could not open $cmdfilnam for writing : $! \n";

            print $cfil $cmd, "\n";

            close $cfil;
        }

        # open the logfile (outfile) for the command, and write a
        # header with the start time --
        # date as: human date, ISO8601, epoch seconds
        `date "+TUSHSTART: %c %Y%m%dT%H%M%S %s" > $outfil`;

        # build a bash command to execute the user $cmd in the
        # background
        $cmd = "nohup bash -c \'" .
            $cmd .
            " >> $outfil 2>&1 && echo \"TUSH_SUCCESS: \" >> $outfil " .
            " ; date \"+TUSH_END:  %c %Y%m%dT%H%M%S %s\" >> $outfil " .
            "\' " . " > /dev/null 2>&1 & ";

        print $cmd, "\n";

        # execute the user $cmd in the background and tail the output
        # file
        system($cmd);

        #        exec("tail -f $outfil");
        exec("less +F $outfil")
            unless (defined($bop->{tushnotail}) &&
                    exists($bop->{tushnotail}));
    }
} # end MAIN

## tuks - configure tush
## tush - no args - last tush cmd=?
##  date "+DATE: %Y-%m-%d%nTIME: %H:%M:%S"
##           locale date, iso8601, epoch
##  date "+TUSHSTART: %c %Y%m%dT%H%M%S %s"
## tushstats: wc, elapsed human, secs
## wc --libxo=json,pretty tush.pl
## https://www.perl.com/article/quoting-the-shell/
### XXX XXX: tricks with local $ENV{MY_VAR} variables...
##
## cwd
## tush.lock - pid
## https://superuser.com/questions/360966/how-do-i-use-a-bash-variable-string-containing-quotes-in-a-command
## https://unix.stackexchange.com/questions/433055/printf-escape-q-string-vs-variable

## https://stackoverflow.com/questions/19589493/follow-buffer-in-emacs-a-la-tail-f-or-less-f
##
## (add-to-list 'auto-mode-alist '("\\.out\\'" . auto-revert-tail-mode))
##
##emacs --eval '(add-to-list \'auto-mode-alist \'("\\\\.out\\\\\'" . auto-revert-tail-mode))'
## emacs -l tush.el
## ./tush.pl echo '"hi mom"' # single quote surrounding the double quotes
## or
## ./tush.pl echo '"'hi mom'"' # single quote surrounding each double quote
##
## https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings
## tushkill - use pslay.pl TUSH
## add tush version, generation date to almanack, scbd
## option to drop a soft link to .out file in cwd?
## tushtrack an active job
### supply the uuid, and it should get the start time, jobname, stats,
### and figure out elapsed time
##
## compact human duration
## 00:00:00   24  hrs  - could go to 48
## 00.00 days 07  days - could go to 14
## 00.00 wks  52  wks  .14 .29 .42 .57 .71 .86
## 00.00 yrs  99  yrs  .08 .17 .25 .33 .42 .50 .58 .67 .75 .83 .92
## if yr > 99  switch to 000.0 format
## if yr > 999 switch to 00000 format
## 00.00 Kyrs 99K yrs K M G

## should be able to have local ACTIVE dir, and use a link to history dir on a share

# recent: range/period/duration/retention, ie 3hr, 1 day, 2 wk, and partition/chunk ?
#         ie clean=active retains last day, and cleans up older jobs in 1 day chunks
# track: pid
#
# tushinfo: use json, dump cmd cwd status elapsed for matching tushid

if (0)
{
    for my $ii (1..10)
    {
        my $jj = 10 ** $ii;
        print  compact_human_duration($jj), "  $jj \n";
    }
}
if (0)
{
    for my $ii (1..10000)
    {
        print  compact_human_duration((10000-$ii)*10000), "  $ii \n";
    }
}
