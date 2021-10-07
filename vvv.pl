#!/usr/bin/perl
#
#
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;
use IO::File;
use POSIX qw(tmpnam);

# BREEZLY_POD_BEGIN
# WARNING: DO NOT modify the pod directly!
# Generated from the breezly_defs by breezly.pl version 3.2
# on Wed Oct  6 18:08:32 2021.
=head1 NAME

B<vvv.pl> - veni, vidi, vici: clean up extra version files

=head1 VERSION

version 12.4 of vvv.pl released on Wed Oct  6 18:08:32 2021

=head1 SYNOPSIS

B<vvv.pl> [options]

Options:

    -help               brief help message
    -man                full documentation
    -maxversion         highest version number to retain


=head1 OPTIONS


=over 8

=item B<help>

    Print a brief help message and exits.

=item B<man>

    Prints the manual page and exits.

=item B<maxversion>

    Restricts the number of versions to retain (normally 10)

=back



=head1 DESCRIPTION

vvv is a command-line tool to generate scripts to remove extraneous
versioned files.



=head1 SUPPORT

Address bug reports and comments at https://github.com/t-bc/genezzo/issues

=head1 AUTHORS

Jeff Cohen

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2021 by Jeff Cohen.

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
         "year" : "2014-2021"
      },
      "creation" : {
         "creationdate" : "Sat Jan 18 01:11:38 2014",
         "creationtime" : 1390036298,
         "orig_authors" : [
            "Jeff Cohen"
         ]
      },
      "long" : "vvv is a command-line tool to generate scripts to remove extraneous%0Aversioned files.",
      "short" : "veni, vidi, vici: clean up extra version files",
      "synopsis" : "[options]",
      "version" : {
         "_generator" : "breezly.pl version 3.2",
         "date" : "Wed Oct  6 18:08:32 2021",
         "number" : "12.4",
         "time" : 1633568912
      }
   },
   "args" : [
      {
         "alias" : "?",
         "long" : "Print a brief help message and exits.",
         "name" : "help",
         "required" : "0",
         "short" : "brief help message",
         "type" : "untyped"
      },
      {
         "long" : "Prints the manual page and exits.",
         "name" : "man",
         "required" : "0",
         "short" : "full documentation",
         "type" : "untyped"
      },
      {
         "alias" : "mv",
         "long" : "Restricts the number of versions to retain (normally 10)",
         "name" : "maxversion",
         "required" : "0",
         "short" : "highest version number to retain",
         "type" : "int"
      }
   ]
}

EOF_bigstr

    return ($bigstr);
}
# BREEZLY_END_DEFS

# validate_more(hash of cmdline options)
#
# stub routine for user-supplied command-line validation
#
#
sub validate_more
{
    my $bigh = shift;

    $bigh->{maxversion} = 10
        unless(exists($bigh->{maxversion}) &&
               defined($bigh->{maxversion}));

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
# Generated from the breezly_defs by breezly.pl version 3.2
# on Wed Oct  6 18:08:32 2021.

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
               'maxversion|mv:i'

        ) or pod2usage(2);

    my $glob_id = "vvv.pl";

    pod2usage(-msg => $glob_id, -exitstatus => 1) if $help;
    pod2usage(-msg => $glob_id, -exitstatus => 0, -verbose => 2) if $man;

    # validate some options


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

# main
if (1)
{
    use POSIX qw(strftime);

    my $allfils = `find . | grep '\.[1023456789]'`;

    my @biga = split(/\n/, $allfils);

    my @matcha;
    my %nameh;

    my $regex = '\.[a-z]{1,4}\.(\d){1,2}$';

    # instead of all matching files, use filenames from ARGV.
    # NOTE: the only way to match names like "foobar.1", which
    # doesn't follow the "name.ext.N" model
    if (scalar(@ARGV))
    {
        my @foo;
        for my $fil (@ARGV)
        {
            push @foo, '(' . quotemeta($fil) . '(.*)\.(\d){1,2})';
        }

        # NOTE: no "^" because filename has directory prefix
##        $regex = '^' . join('|', @foo) . '$' ;
        $regex = join('|', @foo) . '$' ;

##        print '#' . $regex . "\n";
    }

    for my $fil (@biga)
    {
        next
            unless ($fil =~ m/$regex/);
##            unless ($fil =~ m/\.[a-z]{1,4}\.(\d){1,2}$/);

        push @matcha, $fil;

        my @ggg = split(/\./, $fil);

        my $fnum = pop @ggg;

#        print "f:", $fnum, "\n";

        my $f2 = join('.', @ggg);

        # build a hash by file number
        # (because an array might have "holes")
        unless (exists($nameh{$f2}))
        {
            $nameh{$f2} = {};
        }
        $nameh{$f2}->{$fnum} = $fil;

    }

    print join("\n", @matcha), "\n\n";

    while ( my ($kk, $vv) = each(%nameh))
    {
        next
            unless (-e $kk);

        my $nvals = scalar(keys(%{$vv}));

        if ($nvals > $breezly_optdef_h->{maxversion})
        {
            my $tot = $nvals;
            my $cnt = 1;

            print "# ", $tot, "\n";

            # sort the file numbers numerically
            my @fnum = sort {$a <=> $b} (keys(%{$vv}));

#            print Data::Dumper->Dump([$vv]);
#            print Data::Dumper->Dump(\@fnum);

            for my $fnn (@fnum)
            {
                my $f3 = $vv->{$fnn};

                $tot--;
                next
                    unless ($f3 && length($f3));

                if ($tot < $breezly_optdef_h->{maxversion})
                {
                    print "mv $f3 $kk" . "." . $cnt . "\n";
                    # remove font lock files too
                    print "rm $f3" . ".flc\n"
                        if (-e $f3 . ".flc");
                    $cnt++;
                }
                else
                {
                    my $datcmt = "";

                    if (-e $f3)
                    {
                        # get date information on file
                        # (among many other things)
                        my ($dev,$ino,$mode,
                            $nlink,$uid,$gid,
                            $rdev,$size,
                            $atime,$mtime,$ctime,
                            $blksize,$blocks)
                            = stat($f3);

                        # add a "date comment" with time in ISO 8601
                        # format (YYYY-MM-DD hh:mm:ss)
                        $datcmt = "\t# " .
                            strftime("%Y-%m-%d %H:%M:%S",
                                     localtime($mtime));

                    }

                    print "rm $f3 $datcmt\n";
                    # remove font lock files too
                    print "rm $f3" . ".flc\n"
                        if (-e $f3 . ".flc");
                }

            }
            print "\n\n";

        }

    }
}
