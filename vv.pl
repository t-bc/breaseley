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
# Generated from the breezly_defs by breezly.pl version 2.7
# on Sat May  7 19:07:06 2016.
=head1 NAME

B<vv.pl> - make a backup version of a file

=head1 VERSION

version 11 of vv.pl released on Sat Jan 18 00:50:35 2014

=head1 SYNOPSIS

B<vv.pl> [options] filename...

Options:

    -help           brief help message
    -man            full documentation
    -copy           copy the file to the new version


=head1 OPTIONS


=over 8

=item B<help>

    Print a brief help message and exits.

=item B<man>

    Prints the manual page and exits.

=item B<copy>

    Normally, vv.pl only prints a command to generate the new version.
    However, if "-copy" is specified, then the new copy is constructed.

=back



=head1 DESCRIPTION

vv is a command-line tool to increment the version number of a
file. Normally, it generates the "cp" (copy) command, but if -copy is
specified, the cp is executed.



=head1 SUPPORT

Address bug reports and comments to: jcohen@genezzo.com

=head1 AUTHORS

Jeff Cohen

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014 by Jeff Cohen.

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
            "long" : "Address bug reports and comments to: jcohen@genezzo.com"
         },
         "year" : 2014
      },
      "creation" : {
         "creationdate" : "Sat Jan 18 00:44:29 2014",
         "creationtime" : 1390034669,
         "orig_authors" : [
            "Jeff Cohen"
         ]
      },
      "long" : "vv is a command-line tool to increment the version number of a%0Afile. Normally, it generates the %22cp%22 (copy) command, but if -copy is%0Aspecified, the cp is executed.",
      "short" : "make a backup version of a file",
      "synopsis" : "[options] filename...",
      "version" : {
         "date" : "Sat Jan 18 00:50:35 2014",
         "number" : "11",
         "time" : 1390035035
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
         "long" : "Normally, vv.pl only prints a command to generate the new version.%0AHowever, if %22-copy%22 is specified, then the new copy is constructed.",
         "name" : "copy",
         "required" : "0",
         "short" : "copy the file to the new version",
         "type" : "untyped"
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

    return (1);
} # end validate_more

# BREEZLY_CMDLINE_BEGIN

# WARNING: DO NOT modify parse_cmdline() directly!
# Generated from the breezly_defs by breezly.pl version 2.7
# on Sat May  7 19:07:06 2016.

our $breezly_optdef_h;

sub decode_defstr
{
    my $defstr = shift;

    return JSON::decode_json($defstr)
        if (eval "require JSON");

    return JSON::PP::decode_json($defstr)
        if (eval "require JSON::PP");

    warn "Cannot find JSON or JSON::PP modules!\nPlease download and install from cpan.org";

    my $brz_defs = {};
    $brz_defs->{_defs} = {};
    $brz_defs->{args}  = {};

    return $brz_defs;
} # end decode_defstr

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
               'copy'

        ) or pod2usage(2);

    my $glob_id = "vv.pl";

    pod2usage(-msg => $glob_id, -exitstatus => 1) if $help;
    pod2usage(-msg => $glob_id, -exitstatus => 0, -verbose => 2) if $man;

    # validate some options


    # copy to the global
    while (my ($kk, $vv) = each(%h))
    {
        $breezly_optdef_h->{$kk} = $vv;
    }

    my $defstr = breezly_defs();

    my $brz_defs = decode_defstr($defstr);
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
    for my $filename (@ARGV)
    {
	unless (-e $filename)
	{
            print "# no such file: $filename";
            next;
	}

	next if ($filename =~ m/\~$/); # ignore emacs twiddle files
	next if ($filename =~ m/\.\d+$/); # ignore version files

	my $vfile = $filename . '.*';

	my $foo = `ls $vfile`;

	my @file_list = split(/\n/, $foo);

	my $last_num = 0;

	for my $f2 (@file_list)
	{
            chomp $f2;
            print "# ", $f2, "\n";
            my @baz = split(/\./, $f2);

            my $file_num = pop @baz;

            next
                unless ($file_num =~ m/^\d*$/);

            $last_num = $file_num
                if ($file_num > $last_num);
	}

	$last_num++;

	my $new_name = $filename . '.' . $last_num;

	my $cpstr = "cp $filename $new_name\n";

	if (exists($breezly_optdef_h->{copy}) &&
            defined($breezly_optdef_h->{copy}))
	{
            print "do: $cpstr";
            `$cpstr`;
	}
	else
	{
            print $cpstr;
	}

    }
    exit(0);
}
