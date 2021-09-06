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
# Generated from the breezly_defs by breezly.pl version 3.2 
# on Fri Nov 29 23:34:12 2019.
=head1 NAME

B<breezly.pl> - making things a breeze

=head1 VERSION

version 3.2 of breezly.pl released on Fri Oct 25 23:42:04 2019

=head1 SYNOPSIS

B<breezly.pl> [options] filename...

Options:

    -help                       brief help message                                  
    -man                        full documentation                                  
    -define                     define breezly defs                                 
    -getdef                     extract a breezly defs entry                        
    -checkdef                   check if a breezly defs entry exists                
    -jsondefine                 define breezly defs as JSON                         
    -getjsondef                 extract a breezly defs entry as an encoded string   
    -append                     append a value to a breezly defs entry              
    -jsonappend                 append a JSON value to a breezly defs entry         
    -delete                     delete a breezly defs entry                         
    -increment                  increment a breezly defs entry                      
    -argdef                     alias for defining command-line arguments           
    -initdef                    file of multiple breezly def commands               
    -dump                       dump the command line optdef hash                   
    -show                       show the breezly defs                               
    -maketemplate               make a generic template for a breezly script        
    -triplequote                unconvert breezly def to triple-quoted long strings 
    -preferences                dump the breezly defs for a preference files        
    -version                    print the version and copyright information         
    -wikimarkup                 print the documentation in wikicreole markup form   
    -replace                    replace the target file                             
    -compgen                    generate compgen-style completion                   
    -compoptionname             breezly compgen option name                         
    -compoptionvalue            breezly compgen option value                        
    -compoptionposition         breezly compgen option position                     
    -compoptionwords            breezly compgen option words                        
    -compoptionfunction         generate a bash completion function                 


=head1 OPTIONS


=over 8 

=item B<help>

    Print a brief help message and exits.

=item B<man>

    Prints the manual page and exits.

=item B<define>

    Takes a <key>=<value> pair as an argument, 
    and inserts or updates an entry under "_defs" in 
    the breezly defs.  Multiple definitions are possible, e.g:
    
      -def foo=bar -def baz=ztesch
    
    In addition, "dot" and array notation, e.g. 
    a.b.c[0]="foo", is supported.  Note that "-define" 
    only supports simple scalar string or numeric
    value assignment.  Use "-jdefine" to assign a 
    NULL or more complex strucure.

=item B<getdef>

    Takes a <key> as an argument, and dumps an entry under 
    "_defs" in the breezly defs as JSON. Multiple definitions 
    are possible, e.g:
    
      -getdef foo -getdef baz
    

=item B<checkdef>

    Takes a <key> as an argument, and returns the 
    type of an entry under "_defs" in the breezly defs  
    if it exists. Multiple definitions are possible, e.g:
    
      -checkdef foo -checkdef baz
    
    Returns the type of the entry (HASH, ARRAY, SCALAR, 
    or UNDEF) if it exists, else it returns an empty string.
    

=item B<jsondefine>

    Takes a <key>=<value> pair as an argument, where
    the <value> is a "percent-encoded" JSON object, and  
    inserts or updates an entry under "_defs" in the 
    breezly defs.  Multiple definitions are possible, e.g:
    
      -jdef foo=bar -jdef baz=ztesch
    
    Note that literal JSON object that don't contain
    embedded percent signs are valid arguments, so the
    following options are an acceptable way to construct
    an empty array "foo", and an array "baz" with two
    NULL values, and a NULL entry for a.b:
    
      -jdef foo="[]" -jdef baz="[null,null]" a.b="null"
    
    

=item B<getjsondef>

    Takes a <key> as an argument, and dumps an entry under 
    "_defs" in the breezly defs as "percent-encoded" 
    JSON string.  Multiple definitions are possible, e.g:
    
      -getjdef foo -getjdef baz
    
    
    

=item B<append>

    Takes a <key>=<value> pair as an argument, and appends
    it to an existing entry under "_defs" in the breezly defs.  
    If the entry specified by the key is a string, then the 
    new value is concatenated to the existing string.  If the 
    specified entry is an array, then the new entry is appended 
    to the array.
    Multiple definitions are possible, e.g:
    
      -app foo=bar -app baz=ztesch
    
    Note be careful about appending to an array, versus appending
    to an array entry.  For example, if you create an array:
    
      breezly.pl -define a.b[0]=foo foo.pl
      cp foo.pl.brzly foo.pl
      breezly.pl -getdef a foo.pl
    
    returns:
    
    {
       "b" : [
          "foo"
       ]
    }
    
      -append a.b[0]=bar
    
    results in:
    
    {
       "b" : [
          "foobar"
       ]
    }
    
    In order to append to the end of the array, do:
    
      -append a.b=baz
    
    which results in:
    
    {
       "b" : [
          "foobar",
          "baz"
       ]
    }
    
    

=item B<jsonappend>

    Takes a <key>=<value> pair as an argument, where
    the value is a "percent=encoded" JSON string, and 
    appends it to a breezly defs entry.  
    
    Multiple definitions are possible, e.g:
    
      -jsonapp foo="[1,2,3]"  -jsonapp baz='["alpha","bravo"]'
    
    Note that appending an array to an existing array 
    results in concatenation.
    
    

=item B<delete>

    Takes a <key> as an argument, and deletes
    an existing entry under "_defs" in the breezly defs.  Note 
    that this action is quite distinct from setting the entry 
    to NULL. If the entry specified by the key is a hash key, 
    then the existing entry is removed completely.  If the 
    specified entry is an array entry, then the entry is 
    removed ("spliced") from the array.  
    Multiple definitions are possible, e.g:
    
      -del foo -del baz
    

=item B<increment>

    Takes a <key> as an argument, and increments
    an existing entry under "_defs" in the breezly defs.  
    Note that the entry may be a string with an embedded 
    number, e.g. you can increment the string "foo4a" to 
    "foo5a". If the string contains multiple numbers only 
    the final numeric value is incremented.   "increment" 
    does not treat numbers as decimals, so incrementing a
    value like "1.9" results in "1.10", not "2.0".  
    
    The key "version" may be used as a "shortcut" to 
    increment "version"."number", i.e.
    
        -inc version
    
    will increment version.number and update the version
    date and time.  Similarly, the option
    
        -inc copyright
    
    will update the copyright year.

=item B<argdef>

    Normally, the various "defs" commands
    (-define, -getdef, -jsondefine, -append, etc) only
    work on the "_defs" section of the "breezly_defs", 
    which contains the copyright, owner, etc.  Set "-argdef"
    to provide an alias for modifying the "args" array,
    e.g.: 
    
        -argdef=args -getdef args[0]
    
    will dump the first args entry, which is usually the 
    "-help" option.  Note that although "args" is
    an array, breezly supports a special syntax to 
    specify args by name, e.g:
    
        -argdef=args -getdef args.help
    
    finds the arg array entry with the name "help".
    Similarly, you can add a new argument to a
    breezly program by name.  The following example
    will update an existing args entry, or create a
    new one:
    
        -argdef=args -define args.foobar.type=file
    
    The result is an argument named "foobar", of
    type "file".
    

=item B<initdef>

    Supply multiple breezly definitions in
    a single file, using "define", "jsondefine", "append",
    "jsonappend", "delete", and "increment".  Example:
    
      # this is a comment
      define version = 52
      increment version
      jsondefine copyright.contributors = "[]"
      append copyright.maintainers = "Cousin Bob"
    
    

=item B<dump>

    Parse the command line, and dump the hash of the parsed 
    options (the optdef hash) to stdout.  "-dump" shows 
    the breezly.pl commandline, while "-show" dumps the 
    breezly_defs of the input file.

=item B<show>

    Extract the "breezly_defs" definitions from the input file, 
    and apply basic fixup, preferences, and command line 
    options, then dump the result to stdout.  "-dump" shows the 
    breezly.pl commandline, while "-show" dumps the 
    breezly_defs of the input file.

=item B<maketemplate>

    make a generic template for a breezly script

=item B<triplequote>

    Extracts the "breezly_defs" from the input file, and 
    rewrites the output so each "long" definition is in 
    "triple-quoted" form.  Note that while breezly can read these definitions, 
    the resulting JSON object is B<not> in a valid format.  Processing the 
    file B<without> the "triplequote" option will reverse the process.

=item B<preferences>

    Extracts the "breezly_defs" from the input file, filters 
    out dynamic information (like "creationdate"), and writes 
    a json def to stdout, suitable for the breezlyprefs.json 
    file.  If this file exists (in your home directory), it will 
    modify the default definitions (for owner, author, 
    license, etc) when a new template is generated.

=item B<version>

    print the version and copyright information

=item B<wikimarkup>

    Extracts "breezly_defs" definitions from the 
    input file, and print the documentation in wikicreole 
    markup form.  This markup output may be converted to html.

=item B<replace>

    Normally, the target file is not modified, and 
    the results are written to a separate ".brzly" file. 
    If "-replace" is specified, a numbered backup copy
    of the target is made, and the original target file
    is replaced.
    

=item B<compgen>

    Extract the breezly options from the target file
    and generate bash compgen-style completion, based upon
    "--compoptionname" and "--compoptionvalue" options.
    Normally, this option is invoked in the bash completion
    function generated by "--compoptionfunction".
    

=item B<compoptionname>

    Given an argument starting with a dash ("-"),
    it returns the list of matching options for the input file
    (see "--compgen"). If no leading dash is supplied, the 
    argument is treatd as a file name.
    

=item B<compoptionvalue>

    Processes the argument according to
    the breezly option type of the "--compoptionname" (if one
    is supplied).  For example, if the option type is "file", 
    then the "--compoptionvalue" uses compgen-style 
    file name expansion.
    

=item B<compoptionposition>

    Takes the bash COMP_CWORD.  If supplied, 
    use to check for positional arguments.
    

=item B<compoptionwords>

    Takes the bash COMP_WORDS array as rfc 3986
    encoded string.
    

=item B<compoptionfunction>

    Build a bash completion function which
    uses the breezly "compgen" options for interactive command
    completion.  This completion command may be stored in a file
    and "sourced", or installed in /etc/bash_completion.d
    

=back 



=head1 DESCRIPTION


breezly is a simplified system to build scripts using JSON and
Getopt::Long. breezly.pl can generate a simple template which users
can extend to suit their needs.  The template relies on a JSON
definition called the "breezly defs".  This structure contains an
"args" array that defines the names, types, and basic documentation
for each command line option.  

breezly generates [[http://perldoc.perl.org/perlpod.html|POD]] 
documentation, but uses it uses wiki markup templates in 
[[http://wikicreole.org/wiki/Home|WikiCreole]] format, which
it converts to POD.  

=head2 breezly_defs

The command line options and documentation are stored in the
breezly_defs() function at the beginning of each breezly-generated
script.  This function returns a string for a JSON object, which has
two parts: a "_defs" section with basic "metadata" about the program
creation, ownership, copyright, etc, and an "args" section that
defines the command line options.  

=head3 defs

The "_defs" section is automatically populated with "creation"
metadata when the initial template is created: the date string and the
time (seconds since the Epoch).  The initial copyright date is set to
the current year, and the default copyright owner is the author (the
user who invoked breezly).  Users can optionally update the
"maintainers" and "contributors" with lists of names, and add
licensing and support information.

=head3 args

The "args" section is an array of command line option definitions.  At
minimum, each option must have a "name" field and a type.

The "primitive" types are int, float, string, and "untyped".  
An "untyped" option does not take a value -- it can only
be said to exist or not exist.  

By default, all options have a "required" status of zero,
which means that if the option is specified, it does not
have to take a value.  If "required" = 1, then if the
option is specified, it B<must> be followed by a value.
If "required" = 2, then "option" is mandatory, and it
must always be specified with a value.  

For documentation purposes, each option has a one-line
"short" description, which is a simple string.  In addition,
each option has a "long" description in the form of a
"percent-encoded" string in WikiCreole format.

breezly also has an extensible set of built-in types under 
prog.breezly.cmdline_option_types.all_types.  These type
definitions can have a boolean "test" spec plus an
error message for validation failures, and a "long"
description for documentation.  These types are:


=over 8 

=item file

    When an argument is of type file, type validation checks 
    that the file exists.  Use outfile to specify the name 
    of an output file (that does not exist yet).

=item outfile

    Use type file for input files that must exist, 
    and outfile to specify output file names, where 
    the file does not exist yet

=item json

    A percent=encoded JSON object. 

=back 






=head1 SUPPORT

Address bug reports and comments to: jcohen@genezzo.com

=head1 AUTHORS

Jeff Cohen

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2014-2019 by Jeff Cohen.

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
         "year" : "2014-2019"
      },
      "creation" : {
         "creationdate" : "Sat Jan 18 00:25:02 2014",
         "creationtime" : 1390033502,
         "orig_authors" : [
            "Jeff Cohen"
         ]
      },
      "long" : "%0Abreezly is a simplified system to build scripts using JSON and%0AGetopt::Long. breezly.pl can generate a simple template which users%0Acan extend to suit their needs.  The template relies on a JSON%0Adefinition called the %22breezly defs%22.  This structure contains an%0A%22args%22 array that defines the names, types, and basic documentation%0Afor each command line option.  %0A%0Abreezly generates [[http://perldoc.perl.org/perlpod.html%7CPOD]] %0Adocumentation, but uses it uses wiki markup templates in %0A[[http://wikicreole.org/wiki/Home%7CWikiCreole]] format, which%0Ait converts to POD.  %0A%0A== breezly_defs%0A%0AThe command line options and documentation are stored in the%0Abreezly_defs() function at the beginning of each breezly-generated%0Ascript.  This function returns a string for a JSON object, which has%0Atwo parts: a %22_defs%22 section with basic %22metadata%22 about the program%0Acreation, ownership, copyright, etc, and an %22args%22 section that%0Adefines the command line options.  %0A%0A=== defs%0A%0AThe %22_defs%22 section is automatically populated with %22creation%22%0Ametadata when the initial template is created: the date string and the%0Atime (seconds since the Epoch).  The initial copyright date is set to%0Athe current year, and the default copyright owner is the author (the%0Auser who invoked breezly).  Users can optionally update the%0A%22maintainers%22 and %22contributors%22 with lists of names, and add%0Alicensing and support information.%0A%0A=== args%0A%0AThe %22args%22 section is an array of command line option definitions.  At%0Aminimum, each option must have a %22name%22 field and a type.%0A%0AThe %22primitive%22 types are int, float, string, and %22untyped%22.  %0AAn %22untyped%22 option does not take a value -- it can only%0Abe said to exist or not exist.  %0A%0ABy default, all options have a %22required%22 status of zero,%0Awhich means that if the option is specified, it does not%0Ahave to take a value.  If %22required%22 = 1, then if the%0Aoption is specified, it **must** be followed by a value.%0AIf %22required%22 = 2, then %22option%22 is mandatory, and it%0Amust always be specified with a value.  %0A%0AFor documentation purposes, each option has a one-line%0A%22short%22 description, which is a simple string.  In addition,%0Aeach option has a %22long%22 description in the form of a%0A%22percent-encoded%22 string in WikiCreole format.%0A%0Abreezly also has an extensible set of built-in types under %0Aprog.breezly.cmdline_option_types.all_types.  These type%0Adefinitions can have a boolean %22test%22 spec plus an%0Aerror message for validation failures, and a %22long%22%0Adescription for documentation.  These types are:%0A%0A{ARGS_DESCRIPTION}%0A%0A",
      "prog" : {
         "breezly" : {
            "cmdline_option_types" : {
               "all_types" : [
                  {
                     "long" : "When an argument is of type file, type validation checks %5C%5Cthat the file exists.  Use outfile to specify the name %5C%5Cof an output file (that does not exist yet).",
                     "msg" : "Value \\\"{VAL}\\\" invalid for option {NAM}: file \\\"{VAL}\\\" does not exist",
                     "name" : "file",
                     "parent" : "string",
                     "test" : "length({VAL}) && (-e {VAL})"
                  },
                  {
                     "long" : "Use type file for input files that must exist, %5C%5Cand outfile to specify output file names, where %5C%5Cthe file does not exist yet",
                     "name" : "outfile",
                     "parent" : "string"
                  },
                  {
                     "long" : "A percent=encoded JSON object. ",
                     "name" : "json",
                     "parent" : "string"
                  }
               ],
               "primitives" : {
                  "float" : "f",
                  "int" : "i",
                  "string" : "s",
                  "untyped" : ""
               }
            },
            "documentation" : {
               "format_functions" : {
                  "ARGS_DESCRIPTION" : "breezly_args_tmpl"
               }
            }
         }
      },
      "short" : "making things a breeze",
      "synopsis" : "[options] filename...",
      "version" : {
         "_generator" : "breezly.pl version 3.2",
         "date" : "Fri Nov 29 23:33:20 2019",
         "number" : "3.2",
         "time" : 1575099200
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
         "long" : "Takes a {{{<key>=<value>}}} pair as an argument, %0Aand inserts or updates an entry under %22_defs%22 in %0Athe breezly defs.  Multiple definitions are possible, e.g:%0A%0A  -def foo=bar -def baz=ztesch%0A%0AIn addition, %22dot%22 and array notation, e.g. %0Aa.b.c[0]=%22foo%22, is supported.  Note that %22-define%22 %0Aonly supports simple scalar string or numeric%0Avalue assignment.  Use %22-jdefine%22 to assign a %0ANULL or more complex strucure.",
         "name" : "define",
         "required" : "0",
         "short" : "define breezly defs",
         "type" : "string%"
      },
      {
         "long" : "Takes a {{{<key>}}} as an argument, and dumps an entry under %0A%22_defs%22 in the breezly defs as JSON. Multiple definitions %0Aare possible, e.g:%0A%0A  -getdef foo -getdef baz%0A",
         "name" : "getdef",
         "required" : "0",
         "short" : "extract a breezly defs entry",
         "type" : "string[]"
      },
      {
         "alias" : "exists",
         "long" : "Takes a {{{<key>}}} as an argument, and returns the %0Atype of an entry under %22_defs%22 in the breezly defs  %0Aif it exists. Multiple definitions are possible, e.g:%0A%0A  -checkdef foo -checkdef baz%0A%0AReturns the type of the entry (HASH, ARRAY, SCALAR, %0Aor UNDEF) if it exists, else it returns an empty string.%0A",
         "name" : "checkdef",
         "required" : "0",
         "short" : "check if a breezly defs entry exists",
         "type" : "string[]"
      },
      {
         "alias" : "jdefine|longdefine|ldefine",
         "long" : "Takes a {{{<key>=<value>}}} pair as an argument, where%0Athe {{{<value>}}} is a %22percent-encoded%22 JSON object, and  %0Ainserts or updates an entry under %22_defs%22 in the %0Abreezly defs.  Multiple definitions are possible, e.g:%0A%0A  -jdef foo=bar -jdef baz=ztesch%0A%0ANote that literal JSON object that don%27t contain%0Aembedded percent signs are valid arguments, so the%0Afollowing options are an acceptable way to construct%0Aan empty array %22foo%22, and an array %22baz%22 with two%0ANULL values, and a NULL entry for a.b:%0A%0A  -jdef foo=%22[]%22 -jdef baz=%22[null,null]%22 a.b=%22null%22%0A%0A",
         "name" : "jsondefine",
         "required" : "0",
         "short" : "define breezly defs as JSON",
         "type" : "string%"
      },
      {
         "alias" : "getjdef|getlongdef|getldef",
         "long" : "Takes a {{{<key>}}} as an argument, and dumps an entry under %0A%22_defs%22 in the breezly defs as %22percent-encoded%22 %0AJSON string.  Multiple definitions are possible, e.g:%0A%0A  -getjdef foo -getjdef baz%0A%0A%0A",
         "name" : "getjsondef",
         "required" : "0",
         "short" : "extract a breezly defs entry as an encoded string",
         "type" : "string[]"
      },
      {
         "long" : "Takes a {{{<key>=<value>}}} pair as an argument, and appends%0Ait to an existing entry under %22_defs%22 in the breezly defs.  %0AIf the entry specified by the key is a string, then the %0Anew value is concatenated to the existing string.  If the %0Aspecified entry is an array, then the new entry is appended %0Ato the array.%0AMultiple definitions are possible, e.g:%0A%0A  -app foo=bar -app baz=ztesch%0A%0ANote be careful about appending to an array, versus appending%0Ato an array entry.  For example, if you create an array:%0A%0A  breezly.pl -define a.b[0]=foo foo.pl%0A  cp foo.pl.brzly foo.pl%0A  breezly.pl -getdef a foo.pl%0A%0Areturns:%0A%0A{%0A   %22b%22 : [%0A      %22foo%22%0A   ]%0A}%0A%0A  -append a.b[0]=bar%0A%0Aresults in:%0A%0A{%0A   %22b%22 : [%0A      %22foobar%22%0A   ]%0A}%0A%0AIn order to append to the end of the array, do:%0A%0A  -append a.b=baz%0A%0Awhich results in:%0A%0A{%0A   %22b%22 : [%0A      %22foobar%22,%0A      %22baz%22%0A   ]%0A}%0A%0A",
         "name" : "append",
         "required" : "0",
         "short" : "append a value to a breezly defs entry",
         "type" : "string%"
      },
      {
         "alias" : "jappend",
         "long" : "Takes a {{{<key>=<value>}}} pair as an argument, where%0Athe value is a %22percent=encoded%22 JSON string, and %0Aappends it to a breezly defs entry.  %0A%0AMultiple definitions are possible, e.g:%0A%0A  -jsonapp foo=%22[1,2,3]%22  -jsonapp baz=%27[%22alpha%22,%22bravo%22]%27%0A%0ANote that appending an array to an existing array %0Aresults in concatenation.%0A%0A",
         "name" : "jsonappend",
         "required" : "0",
         "short" : "append a JSON value to a breezly defs entry",
         "type" : "string%"
      },
      {
         "alias" : "undef",
         "long" : "Takes a {{{<key>}}} as an argument, and deletes%0Aan existing entry under %22_defs%22 in the breezly defs.  Note %0Athat this action is quite distinct from setting the entry %0Ato NULL. If the entry specified by the key is a hash key, %0Athen the existing entry is removed completely.  If the %0Aspecified entry is an array entry, then the entry is %0Aremoved (%22spliced%22) from the array.  %0AMultiple definitions are possible, e.g:%0A%0A  -del foo -del baz%0A",
         "name" : "delete",
         "required" : "0",
         "short" : "delete a breezly defs entry",
         "type" : "string[]"
      },
      {
         "long" : "Takes a {{{<key>}}} as an argument, and increments%0Aan existing entry under %22_defs%22 in the breezly defs.  %0ANote that the entry may be a string with an embedded %0Anumber, e.g. you can increment the string %22foo4a%22 to %0A%22foo5a%22. If the string contains multiple numbers only %0Athe final numeric value is incremented.   %22increment%22 %0Adoes not treat numbers as decimals, so incrementing a%0Avalue like %221.9%22 results in %221.10%22, not %222.0%22.  %0A%0AThe key %22version%22 may be used as a %22shortcut%22 to %0Aincrement %22version%22.%22number%22, i.e.%0A%0A    -inc version%0A%0Awill increment version.number and update the version%0Adate and time.  Similarly, the option%0A%0A    -inc copyright%0A%0Awill update the copyright year.",
         "name" : "increment",
         "required" : "0",
         "short" : "increment a breezly defs entry",
         "type" : "string[]"
      },
      {
         "alias" : "argsdef",
         "long" : "Normally, the various %22defs%22 commands%0A(-define, -getdef, -jsondefine, -append, etc) only%0Awork on the %22_defs%22 section of the %22breezly_defs%22, %0Awhich contains the copyright, owner, etc.  Set %22-argdef%22%0Ato provide an alias for modifying the %22args%22 array,%0Ae.g.: %0A%0A    -argdef=args -getdef args[0]%0A%0Awill dump the first args entry, which is usually the %0A%22-help%22 option.  Note that although %22args%22 is%0Aan array, breezly supports a special syntax to %0Aspecify args by name, e.g:%0A%0A    -argdef=args -getdef args.help%0A%0Afinds the arg array entry with the name %22help%22.%0ASimilarly, you can add a new argument to a%0Abreezly program by name.  The following example%0Awill update an existing args entry, or create a%0Anew one:%0A%0A    -argdef=args -define args.foobar.type=file%0A%0AThe result is an argument named %22foobar%22, of%0Atype %22file%22.%0A",
         "name" : "argdef",
         "required" : "0",
         "short" : "alias for defining command-line arguments",
         "type" : "string"
      },
      {
         "alias" : "initfile",
         "long" : "Supply multiple breezly definitions in%0Aa single file, using %22define%22, %22jsondefine%22, %22append%22,%0A%22jsonappend%22, %22delete%22, and %22increment%22.  Example:%0A%0A  # this is a comment%0A  define version = 52%0A  increment version%0A  jsondefine copyright.contributors = %22[]%22%0A  append copyright.maintainers = %22Cousin Bob%22%0A%0A",
         "name" : "initdef",
         "required" : "0",
         "short" : "file of multiple breezly def commands",
         "type" : "file"
      },
      {
         "long" : "Parse the command line, and dump the hash of the parsed %5C%5Coptions (the optdef hash) to stdout.  %22-dump%22 shows %5C%5Cthe breezly.pl commandline, while %22-show%22 dumps the %5C%5Cbreezly_defs of the input file.",
         "name" : "dump",
         "required" : "0",
         "short" : "dump the command line optdef hash",
         "type" : "untyped"
      },
      {
         "long" : "Extract the %22breezly_defs%22 definitions from the input file, %5C%5Cand apply basic fixup, preferences, and command line %5C%5Coptions, then dump the result to stdout.  %22-dump%22 shows the %5C%5Cbreezly.pl commandline, while %22-show%22 dumps the %5C%5Cbreezly_defs of the input file.",
         "name" : "show",
         "required" : "0",
         "short" : "show the breezly defs",
         "type" : "untyped"
      },
      {
         "alias" : "template",
         "long" : "make a generic template for a breezly script",
         "name" : "maketemplate",
         "required" : "0",
         "short" : "make a generic template for a breezly script",
         "type" : "untyped"
      },
      {
         "long" : "Extracts the %22breezly_defs%22 from the input file, and %5C%5Crewrites the output so each %22long%22 definition is in %5C%5C%22triple-quoted%22 form.  Note that while breezly can read these definitions, %5C%5Cthe resulting JSON object is **not** in a valid format.  Processing the %5C%5Cfile **without** the %22triplequote%22 option will reverse the process.",
         "name" : "triplequote",
         "required" : "0",
         "short" : "unconvert breezly def to triple-quoted long strings",
         "type" : "untyped"
      },
      {
         "alias" : "prefs",
         "long" : "Extracts the %22breezly_defs%22 from the input file, filters %5C%5Cout dynamic information (like %22creationdate%22), and writes %5C%5Ca json def to stdout, suitable for the breezlyprefs.json %5C%5Cfile.  If this file exists (in your home directory), it will %5C%5Cmodify the default definitions (for owner, author, %5C%5Clicense, etc) when a new template is generated.",
         "name" : "preferences",
         "required" : "0",
         "short" : "dump the breezly defs for a preference files",
         "type" : "untyped"
      },
      {
         "long" : "print the version and copyright information",
         "name" : "version",
         "required" : "0",
         "short" : "print the version and copyright information",
         "type" : "untyped"
      },
      {
         "long" : "Extracts %22breezly_defs%22 definitions from the %5C%5Cinput file, and print the documentation in wikicreole %5C%5Cmarkup form.  This markup output may be converted to html.",
         "name" : "wikimarkup",
         "required" : "0",
         "short" : "print the documentation in wikicreole markup form",
         "type" : "untyped"
      },
      {
         "long" : "Normally, the target file is not modified, and %0Athe results are written to a separate %22.brzly%22 file. %0AIf %22-replace%22 is specified, a numbered backup copy%0Aof the target is made, and the original target file%0Ais replaced.%0A",
         "name" : "replace",
         "required" : "0",
         "short" : "replace the target file",
         "type" : "untyped"
      },
      {
         "long" : "Extract the breezly options from the target file%0Aand generate bash compgen-style completion, based upon%0A%22--compoptionname%22 and %22--compoptionvalue%22 options.%0ANormally, this option is invoked in the bash completion%0Afunction generated by %22--compoptionfunction%22.%0A",
         "name" : "compgen",
         "required" : "0",
         "short" : "generate compgen-style completion",
         "type" : "untyped"
      },
      {
         "long" : "Given an argument starting with a dash (%22-%22),%0Ait returns the list of matching options for the input file%0A(see %22--compgen%22). If no leading dash is supplied, the %0Aargument is treatd as a file name.%0A",
         "name" : "compoptionname",
         "required" : "0",
         "short" : "breezly compgen option name",
         "type" : "string"
      },
      {
         "long" : "Processes the argument according to%0Athe breezly option type of the %22--compoptionname%22 (if one%0Ais supplied).  For example, if the option type is %22file%22, %0Athen the %22--compoptionvalue%22 uses compgen-style %0Afile name expansion.%0A",
         "name" : "compoptionvalue",
         "required" : "0",
         "short" : "breezly compgen option value",
         "type" : "string"
      },
      {
         "long" : "Takes the bash COMP_CWORD.  If supplied, %0Ause to check for positional arguments.%0A",
         "name" : "compoptionposition",
         "required" : "0",
         "short" : "breezly compgen option position",
         "type" : "int"
      },
      {
         "long" : "Takes the bash COMP_WORDS array as rfc 3986%0Aencoded string.%0A",
         "name" : "compoptionwords",
         "required" : "0",
         "short" : "breezly compgen option words",
         "type" : "string"
      },
      {
         "long" : "Build a bash completion function which%0Auses the breezly %22compgen%22 options for interactive command%0Acompletion.  This completion command may be stored in a file%0Aand %22sourced%22, or installed in /etc/bash_completion.d%0A",
         "name" : "compoptionfunction",
         "required" : "0",
         "short" : "generate a bash completion function",
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

    # default value for "argdef" is args if not set
    $bigh->{argdef} = "args"
        if (exists($bigh->{argdef}) &&
            defined($bigh->{argdef}) &&
            (0 == length($bigh->{argdef})));

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
# on Fri Nov 29 23:34:12 2019.

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
               'define:s%',
               'getdef:s@',
               'checkdef|exists:s@',
               'jsondefine|jdefine|longdefine|ldefine:s%',
               'getjsondef|getjdef|getlongdef|getldef:s@',
               'append:s%',
               'jsonappend|jappend:s%',
               'delete|undef:s@',
               'increment:s@',
               'argdef|argsdef:s',
               'initdef|initfile:s',
               'dump',
               'show',
               'maketemplate|template',
               'triplequote',
               'preferences|prefs',
               'version',
               'wikimarkup',
               'replace',
               'compgen',
               'compoptionname:s',
               'compoptionvalue:s',
               'compoptionposition:i',
               'compoptionwords:s',
               'compoptionfunction'
               
        ) or pod2usage(2);

    my $glob_id = "breezly.pl";

    pod2usage(-msg => $glob_id, -exitstatus => 1) if $help;
    pod2usage(-msg => $glob_id, -exitstatus => 0, -verbose => 2) if $man;

    # validate some options
    if (exists($h{initdef}))
    {
        unless (length($h{initdef}) && (-e $h{initdef}))
        {
            warn "Value \"$h{initdef}\" invalid for option initdef: file \"$h{initdef}\" does not exist";
            pod2usage(-msg => $glob_id, -exitstatus => 1, -verbose => 0);
        }
    }
    
        

    # copy to the global
    while (my ($kk, $vv) = each(%h))
    {
        $breezly_optdef_h->{$kk} = $vv;
    }

    my $defstr = breezly_defs();
    
    # NOTE: unconverted breezly_defs may contain triple-quotes.  
    if ($defstr =~ m/\"\"\"/)
    {
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
                    }
                    else
                    {
                        # quurl2 (inlined)
                        my $pat1 = '[^a-zA-Z0-9' .
                            quotemeta(' ~!@#$^&*()-_=+{}[]:;<>,.?/') . ']';
                        
                        $chunk =~ s/($pat1)/uc(sprintf("%%%02lx",  ord $1))/eg;
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
            die("$glob_id: unterminated triple quote in breezly definitions")
                if ($inquote);
            
            $defstr = $fixstr;
        } 
    }
    
    
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
# breezly.pl version 2.4 
# on Fri Mar  4 23:25:56 2016.
#
# Copyright (c) 2016 by Jeff Cohen.


sub breezly_json_setup
{
    my $bop = shift;

    return
        if (exists($bop->{_defs}->{_JSON}->{json}));

    if (eval "require JSON") 
    {
        $bop->{_defs}->{_JSON}->{module} = "JSON";
        $bop->{_defs}->{_JSON}->{json}   = 
           JSON->new->pretty(1)->indent(1)->canonical(1);
    }
    elsif (eval "require JSON::PP")
    {
        $bop->{_defs}->{_JSON}->{module} = "JSON::PP";
        $bop->{_defs}->{_JSON}->{json}   = 
          JSON::PP->new->pretty(1)->indent(1)->canonical(1);
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

        my $sub1 = '{' . quotemeta($kk) . '}';
        
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

# return true if file name = "breezly.pl"
sub isBreezly
{
    my $filnam = shift;

    use File::Basename;

    return 0
        unless (defined($filnam) &&
                length($filnam));

    my $bnam = basename($filnam);

    return ($bnam =~ m/^breezly\.pl$/);
}

sub breezly_pod_warn
{
    my $bigstr = << 'EOF_bigstr';

# WARNING: DO NOT modify the pod directly!  
# Generated from the breezly_defs by breezly.pl version {BRZ_VERSION} 
# on {BRZ_DATE}.
EOF_bigstr

    return ($bigstr);
}

# pod template (in wikicreole)
sub breezly_pod_tmpl
{
    my $bigstr = << 'EOF_bigstr';
= NAME

{SHORT_DESCRIPTION}

= VERSION

{VERSION_STR}

= SYNOPSIS

{SYNOPSIS_HDR}

Options:

{SHORT_OPTIONS}

= OPTIONS

{LONG_OPTIONS}

= DESCRIPTION

{LONG_DESCRIPTION}

{CONTRIBUTORS}
= AUTHORS

{AUTHORS}

= COPYRIGHT AND LICENSE

{COPYRIGHTANDLICENSE}

EOF_bigstr

} # end breezly_pod_tmpl

sub breezly_validate_more_tmpl
{
    my $bigstr = << 'EOF_bigstr';

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
EOF_bigstr

    return $bigstr;
} # end breezly_validate_more_tmpl

# special template for additional fixup in parse_cmdline()
#
# NOTE: when breezly.pl operates on *itself*, it may need to deal with
# triple-quotes in the breezly_defs.  Patch parse_cmdline() -- only
# for breezly.pl -- to perform the fixup from fixup_breezly_defs()
sub special_breezly_def_cmdline_triplequote_fixup_tmpl
{
    my $bigstr = << 'EOF_bigstr';

# NOTE: unconverted breezly_defs may contain triple-quotes.  
if ($defstr =~ m/\"\"\"/)
{
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
                }
                else
                {
                    # quurl2 (inlined)
                    my $pat1 = '[^a-zA-Z0-9' .
                        quotemeta(' ~!@#$^&*()-_=+{}[]:;<>,.?/') . ']';
                    
                    $chunk =~ s/($pat1)/uc(sprintf("%%%02lx",  ord $1))/eg;
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
        die("$glob_id: unterminated triple quote in breezly definitions")
            if ($inquote);
        
        $defstr = $fixstr;
    } 
}

EOF_bigstr

    return $bigstr;
} # end special_breezly_def_cmdline_triplequote_fixup_tmpl

sub breezly_parse_cmdline_tmpl
{
    my $bigstr = << 'EOF_bigstr';

# WARNING: DO NOT modify parse_cmdline() directly!  
# Generated from the breezly_defs by breezly.pl version {BRZ_VERSION} 
# on {BRZ_DATE}.

our {OPTDEFH};

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

    {NUDE_POS}
    GetOptions(\%h, 
               'help|?', 'man', 
               {GETOPTIONS}
        ) or pod2usage(2);

    my $glob_id = "{PROG_ID}";

    pod2usage(-msg => $glob_id, -exitstatus => 1) if $help;
    pod2usage(-msg => $glob_id, -exitstatus => 0, -verbose => 2) if $man;

    # validate some options
    {CHECKOPTIONS}    

    # copy to the global
    while (my ($kk, $vv) = each(%h))
    {
        {OPTDEFH}->{$kk} = $vv;
    }

    my $defstr = breezly_defs();
    {SPECIAL_FIXUP}
    my $brz_defs = defstr_decode($defstr);
    {OPTDEFH}->{_defs}            = $brz_defs->{_defs};
    {OPTDEFH}->{_defs}->{cmdline} = $cmdline;
    {OPTDEFH}->{_defs}->{_args}   = $brz_defs->{args};
    {OPTDEFH}->{_defs}->{_JSON}   = {};

    # call user-supplied validation
    return (validate_more({OPTDEFH}));
} # end parse_cmdline

BEGIN {
    exit(0)
        unless (parse_cmdline());
    
}
EOF_bigstr

    return $bigstr;
} # end breezly_parse_cmdline_tmpl

# build a template for extended args types
sub breezly_args_tmpl
{
    my $bigh = shift;

    my $bigstr = "";

    return $bigstr
        unless (exists($bigh->{_defs}->{prog}) &&
                exists($bigh->{_defs}->{prog}->{breezly}));
    
    my $brprog = $bigh->{_defs}->{prog}->{breezly};

    return $bigstr
        unless (exists($brprog->{cmdline_option_types}) &&
                exists($brprog->{cmdline_option_types}->{all_types}));

    my $coth = $brprog->{cmdline_option_types};
    
    my @tdefa;

    for my $ii (0..(scalar(@{$coth->{all_types}})-1))
    {
        my $typdef = $coth->{all_types}->[$ii];

        # build a dummy string if no "long" description
        my $ldef = "Argument " . $typdef->{name};

        $ldef = unquurl($typdef->{long})
            if (exists($typdef->{long}));

        push @tdefa, ";" . $typdef->{name} . "\n:" . $ldef;
    }

    $bigstr = join("\n", @tdefa);

    return $bigstr;
} # end breezly_args_tmpl

# fixup_breezly_pod(breezly.pl optdef hash (not target defs),
#                   file name, file contents [as string], breezly defs)
# returns formatted string
#
# if markup_only is set, return the markup text (vs a modified version
# of the file contents)
sub fixup_breezly_pod
{
    my ($breezly_bop, $filnam, $bigstr, $bigh, $markup_only) = @_;

    # find the basic region with the breezly definitions
    my $prefx = quotemeta("BREEZLY_POD_BEGIN");
    my $suffx = quotemeta("BREEZLY_POD_END");

    my @ddd = 
        ($bigstr =~ m/^\s*\#\s*$prefx\s*$(.*)^\s*\#\s*$suffx\s*$/ms);

    die ("$filnam: could not fixup breezly pod")
        unless (scalar(@ddd));

    # save the original region as a regex so we can replace it later
    my $orig_rex = quotemeta($ddd[0]);

    my $fnam = "**" . $filnam . "**";

    my $short_options = "";
    my $long_options  = "";

    if (exists($bigh->{args}) &&
        scalar(@{$bigh->{args}}))
    {
        for my $ii (0..((scalar(@{$bigh->{args}})-1)))
        {
            my $arg1 = $bigh->{args}->[$ii];

            my $nam     = $arg1->{name};
            my $shortop = $arg1->{short};
            my $longop  = unquurl($arg1->{long});

            # check "xtra" for long headers/footers
            my ($longhdr, $longftr);
            my ($shorthdr, $shortftr);

            if (exists($arg1->{xtra}))
            {
                my $xtra = $arg1->{xtra};

                if (exists($xtra->{hidden}) && $xtra->{hidden})
                {
                    # don't output hidden option
                    next; 
                }

                if (exists($xtra->{aheader}))
                {
                    $longhdr = unquurl($xtra->{aheader}->{long})
                        if (exists($xtra->{aheader}->{long}));

                    $shorthdr = $xtra->{aheader}->{short}
                        if (exists($xtra->{aheader}->{short}));
                }
                if (exists($xtra->{footer}))
                {
                    $longftr = unquurl($xtra->{footer}->{long})
                        if (exists($xtra->{footer}->{long}));

                    $shortftr = $xtra->{footer}->{short}
                        if (exists($xtra->{footer}->{short}));
                }
            } # end if "xtra"

            # replace newline with \\
            $longop =~ s/\n/\\\\/gm;

            $short_options .= $shorthdr . "\n\n"
                if (defined($shorthdr));

            # short options cannot contain carriage returns 
            # (should have been caught in check_breezly_defs() )
            if ($shortop =~ m/\n/)
            {
                # just fix it crappily in the pod with spaces 
                # (to avoid screwed up formatting)
                warn "$filnam: arg $nam cannot have carriage return in short description";
                $shortop =~ s/\n/ /gm;
            }

            $short_options .= "|-" . $nam . "|||" . $shortop . "\n";

            $short_options .= $shortftr . "\n\n"
                if (defined($shortftr));

            $long_options  .= "\n" . $longhdr . "\n"
                if (defined($longhdr));

            $long_options  .= ";**" . $nam . "**\n:" . $longop . "\n";

            $long_options  .= $longftr . "\n\n"
                if (defined($longftr));

        } # end for
    } # end if (exists(bigh->{args})...

    my $fmt_short = $short_options;

    # if not markup, then format the short options
    if (length($short_options) && !$markup_only)
    {
        # NOTE: format the short options as a single block to get identical
        # alignment *before* applying headers/footers.
        # 
        # so resplit the unformatted short descriptions, and separate
        # into the table of options and headers and footers.
        my @shortlines = split(/\n/, $short_options);
        
        my $ii = 0;

        my (@stbl, @shorthdrs);

        for my $lin (@shortlines)
        {
            # save tbl def
            if ($lin =~ m/^\|\-/)
            {
                push @stbl, $lin;
                $ii += 1;
                next;
            }

            if (defined($shorthdrs[$ii]))
            {
                $shorthdrs[$ii] .= "\n";
            }
            else
            {
                $shorthdrs[$ii] = "";
            }

            # save hdr for this line
            $shorthdrs[$ii] .= $lin;
        }

        $short_options = join("\n", @stbl);

        # format as table (sans headers/footers)
        $fmt_short = breezly_fmt_tbl($short_options);

        # if have short headers/footers, resplit the formatted table
        # and apply them now
        if (scalar(@shorthdrs))
        {
            # resplit the formatted table
            @shortlines = split(/\n/, $fmt_short);

            for my $ii (0..(scalar(@shorthdrs)-1))
            {
                next unless (defined($shorthdrs[$ii]));

                # Note: would prefer if header directly preceded option
                # and footer directly followed (i.e, a single carriage
                # return vs two carriage returns as separators) but the
                # POD formatting may mess up otherwise

                $shortlines[$ii] = 
                    "\n" . $shorthdrs[$ii] .
                    "\n" . $shortlines[$ii];

            }

            $fmt_short = join("\n", @shortlines);            
        }
    } # end if length short_options and !markup_only

    my $shortdesc    = $fnam;
    my $synopsis     = $fnam . " [options]";
    my $longdesc     = "";
    my $verzion      = "";

    my $authors      = "";
    my $contributors = "";
    my $maintainers  = "";
    my $support      = "";

    $synopsis = $fnam . " " . $bigh->{_defs}->{synopsis}
        if (exists($bigh->{_defs}->{synopsis}));

    $shortdesc = $fnam . " - " . $bigh->{_defs}->{short}
        if (exists($bigh->{_defs}->{short}));

    $longdesc = unquurl($bigh->{_defs}->{long})
        if (exists($bigh->{_defs}->{long}));

    $authors = 
        join(",\n", 
             @{$bigh->{_defs}->{creation}->{orig_authors}})
        if (exists($bigh->{_defs}->{creation}->{orig_authors}));

    $contributors = 
        join(",\n", 
             @{$bigh->{_defs}->{copyright}->{contributors}})
        if (exists($bigh->{_defs}->{copyright}->{contributors}));

    # add a header for contributors if have any
    if (length($contributors))
    {
        $contributors = "\n\n= CONTRIBUTORS\n\n" . $contributors . "\n";
    }

    if (exists($bigh->{_defs}->{copyright}->{support}) &&
        exists($bigh->{_defs}->{copyright}->{support}->{long}) &&
        length($bigh->{_defs}->{copyright}->{support}->{long}))
    {
        $contributors = 
            "\n\n= SUPPORT\n\n" . 
            unquurl($bigh->{_defs}->{copyright}->{support}->{long}) .
            $contributors . "\n";
    }

    $maintainers = 
        join(",\n", 
             @{$bigh->{_defs}->{copyright}->{maintainers}})
        if (exists($bigh->{_defs}->{copyright}->{maintainers}));

    if (length($maintainers))
    {
        $authors .= 
            "\n\n= MAINTAINERS\n\nThis software is maintained by:\n" .
            $maintainers . "\n";
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

    if (exists($bigh->{_defs}->{version}) &&
        exists($bigh->{_defs}->{version}->{number}) &&
        exists($bigh->{_defs}->{version}->{date}))
    {
        $verzion = doformat("version {NUM} of {NAM} released on {DAT}",
                            {
                                NUM => $bigh->{_defs}->{version}->{number},
                                NAM => $filnam,
                                DAT => $bigh->{_defs}->{version}->{date}
                            });
    }

    # version info for breezly generator
    # NOTE: the $breezly_optdef_h here is the definitions for this
    # program (breezly.pl), not the generated output (which goes into
    # $bigh)
    my $dt    = localtime();
    my $brzvz = $breezly_bop->{_defs}->{version}->{number};

    my $podstr = doformat(breezly_pod_tmpl(),
                          {
                              SHORT_DESCRIPTION => $shortdesc,
                              VERSION_STR       => $verzion,
                              SYNOPSIS_HDR      => $synopsis,
                              SHORT_OPTIONS     => $fmt_short,
                              LONG_OPTIONS      => $long_options,
                              LONG_DESCRIPTION  => $longdesc,
                              CONTRIBUTORS      => $contributors,
                              AUTHORS           => $authors,
                              BRZ_VERSION       => $brzvz,
                              BRZ_DATE          => $dt,

                              COPYRIGHTANDLICENSE => $copynlic
                          });


    # check if the documentation has additional "format functions"
    if (exists($bigh->{_defs}->{prog}) &&
        exists($bigh->{_defs}->{prog}->{breezly}))
    {
        my $brprog = $bigh->{_defs}->{prog}->{breezly};

        if (exists($brprog->{documentation}) &&
            exists($brprog->{documentation}->{format_functions}))
        {
            my $ff = $brprog->{documentation}->{format_functions};

            my %docffh;

            # the format function "key" is a "{FIELD}" in the podstr,
            # and the value is the name of a template function that
            # takes $bigh as input and constructs a formatted string.
            # Use doformat() to update the pod string with the
            # additional formatted text.
            while (my ($kk, $vv) = each(%{$ff}))
            {
                my $tmplstr = "";

                die ("$filnam: no such format function $vv")
                    unless (exists(&$vv));

                eval { $tmplstr = (\&$vv)->($bigh) }; warn $@ if $@;
                $docffh{$kk} = $tmplstr;
            }
            
            # augment pod string with additional formatting functions
            $podstr = doformat($podstr, \%docffh)
                if (scalar(keys(%docffh)));
        }
    }
    
    # NOTE: just dump the podstr in wikicreole markup form -- don't
    # fixup the file
    return ($podstr)
        if ($markup_only);

    $podstr = basic_wikicreole2pod($podstr);

    # NOTE: prefix the podstr with the "WARNING" comment after
    # processing markup (because the perl comment "#" converts to a
    # numeric list!)
    $podstr = doformat(breezly_pod_warn(),
                          {
                              BRZ_VERSION       => $brzvz,
                              BRZ_DATE          => $dt,
                          }) . $podstr;
                          
    $podstr .= "\n=cut\n";

    $bigstr =~ s/$orig_rex/$podstr/gm;

    return $bigstr;
} # end fixup_breezly_pod

# get_primitive_option_type(hash of cmdline option types, 
#                           file name, argument name, typename)
#
# returns "primitive" type for GetOpt
#
sub get_primitive_option_type
{
    my ($coth, $filnam, $argnam, $tpnam) = @_;

    my $primt = undef; # underlying primitive type
    my $multi = "";    # multiple values suffix: % for hash, @ for array

    # check for array/hash
    # save the suffix, fixup the name, and append suffix later
    if ($tpnam =~ m/(\%|\@|\[\])$/)
    {
        $multi = ($tpnam =~ m/\%$/) ? '%' : '@';

        # trim the suffix -- replace later
        $tpnam =~ s/(\%|\@|\[\])$//;
    }

    die "$filnam: type \"untyped\" for arg \"$argnam\" cannot be array or hash"
        if (($tpnam eq "untyped") && length($multi));

    # NOTE: "untyped" is zero-length string (vs an undef for an invalid type)

    my $primh = $coth->{primitives};

    # get a "primitive" suffix like "i" or "s"
    $primt = ($primh->{$tpnam})
        if (exists($primh->{$tpnam}));

    # append the multiple value suffix like "%" or "@"
    $primt .= $multi
        if (defined($primt));

    return $primt;
} # end get_primitive_option_type

# make_getoptions_args(hash of cmdline option types, filename, breezly defs)
#
# helper routine for fixup_breezly_cmdline()
#
# construct the argument list for GetOptions()
sub make_getoptions_args
{
    my ($coth, $filnam, $bigh) = @_;

    my @biga;

    if (exists($bigh->{args}) &&
        scalar(@{$bigh->{args}}))
    {
        for my $ii (0..((scalar(@{$bigh->{args}})-1)))
        {
            my $arg1 = $bigh->{args}->[$ii];

            my $nam  = $arg1->{name};

            next if ($nam =~ m/^(help|man)$/);

            # append the aliases
            $nam .= "|" . $arg1->{alias}
                if (exists($arg1->{alias}));

            my $typ = get_primitive_option_type($coth, 
                                                $filnam, $nam, $arg1->{type});

            if ($typ)
            {
                $nam .= (($arg1->{required}) ? "=" : ":") . $typ;
            }
            else 
            {
                # NOTE: type "untyped" returns a zero-length string,
                # versus an undef.
                die "$filnam: unknown type \"$arg1->{type}\" for arg \"$nam\""
                    if (!defined($typ));
            }

            push @biga, "\'" . $nam . "\'";

        }
    }

    # build comma-separated list of all GetOptions() arguments
    return (join(",\n", @biga) . "\n")
        if scalar(@biga);

    return "";
} # end make_getoptions_args

# helper function for get_typecheck()
sub get_choices_typedef
{
    my ($coth, $filnam, $bigh, $tpnam, $argdef) = @_;
    my @checkset;

    my $ignor   = "";
    my $abbrev  = 0;

    return undef
        unless (exists($argdef->{choices}));

    my $valuea;

    if (ref($argdef->{choices}) eq 'ARRAY')
    {
        # choices is an array of values: only support exact,
        # case-sensitive matching.

        $valuea = $argdef->{choices};
    }
    elsif (ref($argdef->{choices}) eq 'HASH')
    {
        die "$filnam: no choices values for type $tpnam"
            unless (exists($argdef->{choices}->{values}) &&
                    (
                    (ref($argdef->{choices}->{values}) eq 'ARRAY') ||
                    (ref($argdef->{choices}->{values}) eq 'HASH')));

        if (ref($argdef->{choices}->{values}) eq 'ARRAY')
        {
            $valuea = $argdef->{choices}->{values};
        }
        else
        {
            # hash case
            my @k1  = sort(keys(%{$argdef->{choices}->{values}}));
            $valuea = \@k1;
        }


        # check for match modifiers in choices hash
        goto L_tpd
            unless (exists($argdef->{choices}->{match}));

        # choices can have an option match modifier: 
        # ignore and/or auto_abbrev
        $ignor = "i"
            if ($argdef->{choices}->{match} =~ m/ignore/);

        $abbrev = 1
            if ($argdef->{choices}->{match} =~ m/abbrev/);

    }
    else
    {
        die "$filnam: bad choices definition for type $tpnam"
    }


  L_tpd:
    if (!($abbrev))
    {
        # no auto_abbreviation: option value must exactly match a
        # single member of the "value array"

        my $msgtmpl = '{NAM}: " . {VAL} . " not in ({VALSETCOMMA})';
        my $tsttmpl = '{VAL} =~ m/^({VALSETBAR})$/{IGNORE}';

        my $vcom    = join(", ", @{$valuea});
        my $vbar    = join("|",  map(quotemeta, @{$valuea}));

        my $tpdmsg = doformat($msgtmpl, 
                              { 
                                  VALSETCOMMA => $vcom
                              });
        
        my $tpdtst = doformat($tsttmpl, 
                              { 
                                  VALSETBAR => $vbar,
                                  IGNORE    => $ignor
                              });

        my $tpd = { msg => $tpdmsg, test => $tpdtst };
        push @checkset, $tpd;
    }
    else
    {
        # support auto_abbreviation
        #
        # existence check:
        # grep for val over all choices, must match at least once (nonzero)
        #   (0 != scalar(grep { $_ ~= m/quotemeta(VAL)/ } @CHOICES))
        #
        # example:
        #   unless (0 != 
        #           (scalar(grep { $_ =~ m/^\Q$h{ttt}\E/i } 
        #                    ("cable", "cabal", "frog", "frugal", "regal", "regulate"))))

        my $msgtmpl1 = '{NAM}: " . {VAL} . " not in ({VALSETCOMMA})';
        my $tsttmpl1 = '0 != (scalar(grep { $_ =~ m/^\Q{VAL}\E/{IGNORE} } ({VALSETARR})))';

        my $vcom1    = join(", ", @{$valuea});

        # comma separated, doubled quoted list of values (eg '"a", "b", "c"')
        my $varr1    = join(", ",  map { '"' . $_ . '"'} @{$valuea});

        my $tpdmsg1 = doformat($msgtmpl1, 
                              { 
                                  VALSETCOMMA => $vcom1
                              });
        
        my $tpdtst1 = doformat($tsttmpl1, 
                              { 
                                  VALSETARR => $varr1,
                                  IGNORE    => $ignor
                              });

        my $tpd1 = { msg => $tpdmsg1, test => $tpdtst1 };
        push @checkset, $tpd1;

        # unambiguity check: 
        # grep for val over all choices, must match only once
        #   (1 == scalar(grep { $_ ~= m/VAL/ } @CHOICES))

        my $msgtmpl2 = '{NAM}: " . {VAL} . " ambiguous match for ({VALSETCOMMA})';
        my $tsttmpl2 = '1 == (scalar(grep { $_ =~ m/^\Q{VAL}\E/{IGNORE} } ({VALSETARR})))';

        my $tpdmsg2 = doformat($msgtmpl2, 
                              { 
                                  VALSETCOMMA => $vcom1
                              });
        
        my $tpdtst2 = doformat($tsttmpl2, 
                              { 
                                  VALSETARR => $varr1,
                                  IGNORE    => $ignor
                              });

        my $tpd2 = { msg => $tpdmsg2, test => $tpdtst2 };
        push @checkset, $tpd2;

    } 

    return \@checkset;

} # end get_choices_typedef

# get_typecheck(hash of cmdline option types, file name, breezly defs,
#               type name, cmdline argument definition [from "args" array])
#
# return a list (array) of typedefs for a "checkable" type, in order
# from the most primitive to the least (ie the typecheck associated
# with the current type is last, the typecheck for its parent precedes
# it, etc)
sub get_typecheck
{
    my ($coth, $filnam, $bigh, $tpnam, $argdef) = @_;

    my $typnam = $tpnam . "";

    # check for array/hash -- trim the suffix 
    $typnam =~ s/(\%|\@|\[\])$//;

    die "$filnam: no such type $typnam"
        unless (exists($coth->{all_types_h}->{$typnam}));

    my $checkset = [];

    # NOTE: msg format similar to GetOpt error messages
    # eg:
#        int => {
#            test => '{VAL} =~ m/^\d+$/',
#            msg => '{NAM}: \"{VAL}\" must be an integer' 
#        },
#        file => {
#            test => 'length({VAL}) && (-e {VAL})',
#            msg => 'Value \"{VAL}\" invalid for option {NAM}: file \"{VAL}\" does not exist'
#        }

    # check "extra" type first
    if (exists($argdef->{xtra}) &&
        exists($argdef->{xtra}->{type}) &&
        exists($argdef->{xtra}->{type}->{msg}) &&
        exists($argdef->{xtra}->{type}->{test}))
    {
        # this is actually the *last* typecheck 
        push @{$checkset}, $argdef->{xtra}->{type};
    }

    my $idx = $coth->{all_types_h}->{$typnam};

    # negative offset indicates primitive type, without a typecheck
    while ($idx >= 0)
    {
        # "checkable" type has a boolean test, and a failure message
        if (exists($coth->{all_types}->[$idx]->{msg}) &&
                exists($coth->{all_types}->[$idx]->{test}))
        {
            # do more "primitive" typecheck first (use unshift vs push)
            unshift @{$checkset}, $coth->{all_types}->[$idx];
        }

        # find the parent, and see if it has a typecheck
        $typnam = $coth->{all_types}->[$idx]->{parent};

        $idx = $coth->{all_types_h}->{$typnam};

    } # end while

    if (exists($argdef->{choices}))
    {
        my $tpda = get_choices_typedef($coth, $filnam, $bigh, $tpnam, $argdef);
        push @{$checkset}, @{$tpda}
            if (defined($tpda));
    }

    return $checkset;
} # end get_typecheck

# make_checkoptions(hash of cmdline option types, filename, breezly defs)
#
# helper routine for fixup_breezly_cmdline()
#
# build the statements for validating options based upon "test"/"msg"
# attributes of the type definition.
sub make_checkoptions
{
    my ($coth, $filnam, $bigh) = @_;

    my @biga;

    my $if_exists = << 'EOF_if_exists';
if (exists({VAL}))
{
    unless ({TEST})
    {
        warn "{DIEMSG}";
        pod2usage(-msg => $glob_id, -exitstatus => 1, -verbose => 0);
    }
}
EOF_if_exists

    my $arr_exists = << 'EOF_arr_exists';
if (exists({VAL}))
{
    for my $elt (@{{VAL}})
    {
        unless ({TEST})
        {
            warn "{DIEMSG}";
            pod2usage(-msg => $glob_id, -exitstatus => 1, -verbose => 0);
        }
    }
}
EOF_arr_exists
 
    my $reqstr = << 'EOF_reqstr';
{
    warn "Missing required option \"{NAM}\"";
    pod2usage(-msg => $glob_id, -exitstatus => 1, -verbose => 0);
}
EOF_reqstr

    return ""
        unless (exists($bigh->{args}) &&
                scalar(@{$bigh->{args}}));

    for my $ii (0..((scalar(@{$bigh->{args}})-1)))
    {
        my $arg1 = $bigh->{args}->[$ii];

        my $nam  = $arg1->{name};
        my $typ  = $arg1->{type};
        my $req  = $arg1->{required};

        my $bArrayType = 0;

        my $str  = "";

        # if the type has a check routine, use it
        my $typcheck = get_typecheck($coth, $filnam, $bigh, $typ, $arg1);
            
        if (scalar(@{$typcheck}))
        {
            $str = $if_exists . "";
            
            if ($typ =~ m/(\@|\[\])$/)
            {
                $str = doformat($arr_exists,
                             {
                                 NAM => $nam,
                                 VAL => '$h{' . $nam . '}'
                             });
                $bArrayType = 1;
            }

        }
        else
        {
            next unless (2 == $req);
        }

        # required == 1 means the option **must** have a value if
        # it is specified.
        # required == 2 is **really** required, ie the option
        # **must** exist and have a value (ie it's not really
        # optional)
        if (2 == $req)
        {
            if (length($str))
            {
                # add "else" to "if exists..."
                $str .= "else\n";
            }
            else
            {
                # no "if exists", so use "unless"
                $str = "unless (exists({VAL}))\n";
            }
            
            # add the "really required" check
            $str .= $reqstr;
        }
        
        my $diemsg   = "";
        my $testbool = "";
        
        if (scalar(@{$typcheck}))
        {
            my $valstr = '$h{' . $nam . '}';
            
            $valstr = '$elt'
                if ($bArrayType);

            # may have set of typchecks
            for my $tc (@{$typcheck})
            {
                $diemsg = 
                    doformat($tc->{msg},
                             {
                                 NAM => $nam,
                                 VAL => $valstr
                             });
                
                $testbool = 
                    doformat($tc->{test},
                             {
                                 NAM => $nam,
                                 VAL => $valstr
                             });
                
                push @biga, doformat($str,
                                     {
                                         NAM    => $nam,
                                         VAL    => $valstr,
                                         DIEMSG => $diemsg,
                                         TEST   => $testbool
                                     });
            } # end for
        }
        else
        {
            $str = doformat($str,
                            {
                                NAM    => $nam,
                                VAL    => '$h{' . $nam . '}',
                                DIEMSG => $diemsg,
                                TEST   => $testbool
                            });
            
            push @biga, $str;
        }
        
    } # end for my ii

    # build text for combined checkoption statements
    return (join("\n", @biga) . "\n")
        if scalar(@biga);

    return "";
} # end make_checkoptions

# make_nudepos(hash of cmdline option types, filename, breezly defs)
#
# helper routine for fixup_breezly_cmdline()
#
sub make_nudepos
{
    my ($coth, $filnam, $bigh) = @_;
    my $bigstr = "";
    my $hdr = << 'EOF_hdr';
# convert "nude" (positional) arguments to named options
# before GetOpt() processing
EOF_hdr
    
    # 20210706: 
    # allow positional arguments with embedded, non-leading dash "-"
    # Cannot have positional arguments with leading dash because then
    # they just look like normal arguments!
    my $nudetmpl = << 'EOF_tmpl';

$ARGV[{VAL}] = '--{NAM}=' . $ARGV[{VAL}] 
    if ((scalar(@ARGV) >= {VALPLUS}) && ($ARGV[{VAL}] !~ /^\s*\-/));
EOF_tmpl

    if (exists($bigh->{args}) &&
        scalar(@{$bigh->{args}}))
    {
        for my $ii (0..((scalar(@{$bigh->{args}})-1)))
        {
            my $arg1 = $bigh->{args}->[$ii];

            my $nam     = $arg1->{name};
            my $shortop = $arg1->{short};
            my $longop  = unquurl($arg1->{long});

            if (exists($arg1->{xtra}))
            {
                my $xtra = $arg1->{xtra};

                if (exists($xtra->{nude_pos}) && $xtra->{nude_pos})
                {
                    # add header if processing first argument
                    $bigstr .= $hdr
                        if (0 == length($bigstr));

                    unless ($xtra->{nude_pos} =~ m/^\d+/)
                    {
                        die "$filnam: invalid nude position \"" .
                            $xtra->{nude_pos} . "\" for option \"$nam\" : " .
                            " must be a positive integer ";
                    }

                    $bigstr .=  doformat(
                        $nudetmpl, {
                            NAM     => $nam,
                            VAL     => ($xtra->{nude_pos} - 1),
                            VALPLUS => ($xtra->{nude_pos})
                        });
                }
            }
        }
    }

    return $bigstr;
}

# make_cmdline_option_types_hash(breezly.pl optdef hash (not target defs),
#                                file name, file contents [as string], 
#                                breezly defs)
#
# take the breezly defs cmdline_option_types and add runtime
# structures (eg named hash of types)
sub make_cmdline_option_types_hash
{
    my ($breezly_bop, $filnam, $bigstr, $bigh) = @_;

    # NOTE: the $breezly_optdef_h here is the definitions for this
    # program (breezly.pl), not the generated output (which goes into
    # $bigh)
    my $breezly_prog_defs = $breezly_bop->{_defs}->{prog}->{breezly};

    # the cmdline option types hash
    my $coth = 
        breezly_deep_copy(
            $breezly_bop,
            $breezly_prog_defs->{cmdline_option_types});

    my $primitive_optionh = $coth->{primitives};

    # build hash by name for all types array
    $coth->{all_types_h} = {};

    my $ath = $coth->{all_types_h};

    for my $kk (keys(%{$primitive_optionh}))
    {
        # load ath with primitives with invalid array offset -1
        $ath->{$kk} = -1;
    }

    ### XXX XXX: if the bigh has
    ### prog.breezly.cmdline_option_types.all_types, then add those to
    ### cmdline option types hash
    if (!isBreezly($filnam) &&
        exists($bigh->{_defs}) &&
        exists($bigh->{_defs}->{prog}) &&
        exists($bigh->{_defs}->{prog}->{breezly}) &&
        exists($bigh->{_defs}->{prog}->{breezly}->{cmdline_option_types}))
    {
        my $loc_prog_defs = $bigh->{_defs}->{prog}->{breezly};

        my $loc_coth = 
            breezly_deep_copy(
                $breezly_bop,
                $loc_prog_defs->{cmdline_option_types});

        push @{$coth->{all_types}}, @{$loc_coth->{all_types}}
            if (exists($loc_coth->{all_types}));
    }

    for my $ii (0..(scalar(@{$coth->{all_types}})-1))
    {
        my $typdef = $coth->{all_types}->[$ii];

        die "$filnam: no name for type definition $ii"
            unless (exists($typdef->{name}) &&
                    defined($typdef->{name}) &&
                    length($typdef->{name}));
        
        my $typnam = $typdef->{name};

        die "$filnam: no parent for type \"$typnam\""
            unless (exists($typdef->{parent}) &&
                    defined($typdef->{parent}) &&
                    length($typdef->{parent}));

        my $typpar = $typdef->{parent};

        die "$filnam: no such parent \"$typpar\" for type \"$typnam\""
            unless (exists($primitive_optionh->{$typpar}));

        die "$filnam: type \"$typnam\" cannot inherit from \"untyped\""
            if ($primitive_optionh->{$typpar} eq "untyped");

        die "$filnam: duplicate type \"$typnam\""
            if (exists($primitive_optionh->{$typnam}));

        # save the array offset in the named type hash
        $ath->{$typnam} = $ii;

        $primitive_optionh->{$typnam} = $primitive_optionh->{$typpar};
    }

    return ($coth);
} # end make_cmdline_option_types_hash

# fixup_breezly_cmdline(breezly.pl optdef hash (not target),
#                       file name, file contents [as string], breezly defs)
#
# generate the cmdline processing
sub fixup_breezly_cmdline
{
    my ($breezly_bop, $filnam, $bigstr, $bigh) = @_;

    # XXX XXX: .pm files don't have a commandline...
    return $bigstr
        if ($filnam =~ m/\.pm$/);

    # find the basic region with the breezly definitions
    my $prefx = quotemeta("BREEZLY_CMDLINE_BEGIN");
    my $suffx = quotemeta("BREEZLY_CMDLINE_END");

    my @ddd = 
        ($bigstr =~ m/^\s*\#\s*$prefx\s*$(.*)^\s*\#\s*$suffx\s*$/ms);

    die ("$filnam: could not fixup breezly command line options")
        unless (scalar(@ddd));

    # save the original region as a regex so we can replace it later
    my $orig_rex = quotemeta($ddd[0]);

    # build runtime typechecking structure for cmdline arguments
    my $coth = 
        make_cmdline_option_types_hash(
            $breezly_bop,
            $filnam, $bigstr, $bigh);

    # get the strings for GetOptions() parsing and basic option
    # validation
    my $getoptstr   = make_getoptions_args($coth, $filnam, $bigh);
    my $checkoptstr = make_checkoptions($coth, $filnam, $bigh);
    my $nudeposstr  = make_nudepos($coth, $filnam, $bigh);

    # version info for breezly generator
    # NOTE: the $breezly_optdef_h here is the definitions for this
    # program (breezly.pl), not the generated output (which goes into
    # $bigh)
    my $dt    = localtime();
    my $brzvz = $breezly_bop->{_defs}->{version}->{number};

    # NOTE: a bit grotesque.  The issue is that if breezly.pl operates
    # on *itself*, then it may have a breezly_def() with triple quotes
    # that would break JSON::PP::decode_json() in parse_cmdline().  So
    # splice in a special triple-quote fixup for that case.  
    my $special = isBreezly($filnam) ? 
        special_breezly_def_cmdline_triplequote_fixup_tmpl() : "";

    my $clstr = doformat(breezly_parse_cmdline_tmpl(),
                         {
                             OPTDEFH       => '$breezly_optdef_h',
                             GETOPTIONS    => $getoptstr,
                             CHECKOPTIONS  => $checkoptstr,
                             PROG_ID       => $filnam,
                             BRZ_VERSION   => $brzvz,
                             BRZ_DATE      => $dt,
                             SPECIAL_FIXUP => $special,
                             NUDE_POS      => $nudeposstr,
                         });

    $bigstr =~ s/$orig_rex/$clstr/gm;

    return $bigstr;
} # end fixup_breezly_cmdline

# fixup_breezly_utility_functions(breezly.pl optdef hash (not target),
#                                 this file, target file name, 
#                                 target file contents [as string])
# returns modified file contents string [if the marked region exists]
# 
# breezly.pl contains a useful set of utility functions.  If the
# target file contains a BEGIN/END "marked region" for the utility
# functions, breezly.pl will extract the functions from **itself** and
# copy them into the target file (potentially useful if the desire is
# to create a "standalone" utility without any other dependencies).
# NOTE: the caller checks to ensure that breezly does not run this
# function on itself, which would be bad (or at least, redundant).
sub fixup_breezly_utility_functions
{
    my ($breezly_bop,
        $brzly_filename, $filnam, $bigstr) = @_;

    # find the basic region for the utility functions
    my $prefx = quotemeta("BREEZLY_UTILITYFUNCS_BEGIN");
    my $suffx = quotemeta("BREEZLY_UTILITYFUNCS_END");

    my @ddd = 
        ($bigstr =~ m/^\s*\#\s*$prefx\s*$(.*)^\s*\#\s*$suffx\s*$/ms);

    # if file doesn't have a region for "utility functions", just end
    # (no error)
    return $bigstr
        unless (scalar(@ddd));

    # save the original region as a regex so we can replace it later
    my $orig_rex = quotemeta($ddd[0]);

    my $brz_fil_str;

    # read in breezly.pl
    {
        my $infil;

        open ($infil, "< $brzly_filename") or 
            die "Could not open $brzly_filename for reading : $! \n";

        # $$$ $$$ undefine input record separator (\n")
        # and slurp entire file into variable
        local $/;
        undef $/;
        
        $brz_fil_str = <$infil>;
    
        close $infil;
    }

    # find and extract the utility functions from breezly.pl
    @ddd = 
        ($brz_fil_str =~ m/^\s*\#\s*$prefx\s*$(.*)^\s*\#\s*$suffx\s*$/ms);

    die ("$filnam: could not find breezly utility functions")
        unless (scalar(@ddd));

    # version info 
    # NOTE: the $breezly_optdef_h here is the definitions for this
    # program (breezly.pl), not the generated output (which goes into
    # $bigh)
    my $dt       = localtime();
    my $brzvz    = $breezly_bop->{_defs}->{version}->{number};
    my $brzowner = $breezly_bop->{_defs}->{copyright}->{owner};
    my $brzyear  = $breezly_bop->{_defs}->{copyright}->{year};

    my $brz_util_funcs = doformat(
        "# The following breezly utility functions were copied from \n" .
        "# breezly.pl version {BRZ_VERSION} \n" .
        "# on {DAT}.\n#\n" .
        "# Copyright (c) {CYEAR} by {COWNER}.\n\n",
        {
            DAT         => $dt,
            BRZ_VERSION => $brzvz,
            COWNER      => $brzowner,
            CYEAR       => $brzyear
        });

    # save the original region from breezly.pl so we can substitute it
    # into the target file
    $brz_util_funcs .= $ddd[0];

    # update the target file
    $bigstr =~ 
        s/(^\s*\#\s*$prefx\s*)$orig_rex(^\s*\#\s*$suffx\s*$)/$1\n$brz_util_funcs\n$2/gm;

    return $bigstr;
} # end fixup_breezly_utility_functions

# template for breezly defs
sub breezly_defs_tmpl
{
    my $newtmpl = << 'EOF_newtmpl';

# {BEG1}
#
# The json breezly_defs control command-line parsing and pod
# documentation.  Update these definitions and run breezly.pl to
# rebuild your program.
# 
sub breezly_defs
{
    my $bigstr = << 'EOF_bigstr';
{JSONDEF}
EOF_bigstr

    return ($bigstr);
}
# {END1}
EOF_newtmpl

    return $newtmpl;
}

sub build_breezly_metadata2
{
    my ($breezly_bop, $filnam, $bigh, $brzvz) = @_;

    my $bzly = {};

    my $yy;

    {
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
            localtime();

        $yy = $year += 1900;
    }

    my $dt = localtime();
    my $tm = time();
    my $auth = "";

    # owner/author is current user unless otherwise specified (eg via
    # breezlyprefs.json)
    if (1)
    {
        $auth = `whoami`;
        chomp ($auth);
    }

    # check if the home directory has a preferences file.  The
    # definitions here will override the defaults.
    my $preffil = 
        File::Spec->catfile($ENV{HOME}, "breezlyprefs.json");

    if (-e $preffil)
    {
        my $infil;

        open ($infil, "< $preffil") or 
            die "Could not open $preffil for reading : $! \n";

        # $$$ $$$ undefine input record separator (\n")
        # and slurp entire file into variable
        local $/;
        undef $/;

        my $bigstr = <$infil>;

        close $infil;

        my $defs = breezly_json_decode($breezly_bop, $bigstr);

        $bzly = $defs->{_defs}
            if (defined($defs) &&
                exists($defs->{_defs}));
    }
    
    # NOTE: the preferences file takes precedence over standard
    # defaults.  Merge the hash with the defaults.  The module
    # Hash::Merge does this better

    $bzly->{creation}                 = {}
        unless (exists($bzly->{creation}) &&
                defined($bzly->{creation}));
    
    $bzly->{creation}->{creationdate} = $dt;
    $bzly->{creation}->{creationtime} = $tm;

    $bzly->{creation}->{orig_authors} = [ $auth ]
        unless (exists($bzly->{creation}->{orig_authors}) &&
                scalar(@{$bzly->{creation}->{orig_authors}}));

    $bzly->{copyright}                    = {}    
        unless (exists($bzly->{copyright}) &&
                defined($bzly->{copyright}));

    $bzly->{copyright}->{contributors}    = []
        unless (exists($bzly->{copyright}->{contributors}) &&
                scalar(@{$bzly->{copyright}->{contributors}}));

    $bzly->{copyright}->{maintainers}     = []
        unless (exists($bzly->{copyright}->{maintainers}) &&
                scalar(@{$bzly->{copyright}->{maintainers}}));

    $bzly->{copyright}->{support}         = {}
        unless (exists($bzly->{copyright}->{support}) &&
                defined($bzly->{copyright}->{support}));

    $bzly->{copyright}->{support}->{long} = ""
        unless (exists($bzly->{copyright}->{support}->{long}) &&
                defined($bzly->{copyright}->{support}->{long}) &&
                length($bzly->{copyright}->{support}->{long}));

    $bzly->{copyright}->{year}            = $yy;
    $bzly->{copyright}->{owner}           = $auth
        unless (exists($bzly->{copyright}->{owner}) &&
                defined($bzly->{copyright}->{owner}));

    $bzly->{copyright}->{license}         = {}
        unless (exists($bzly->{copyright}->{license}) &&
                defined($bzly->{copyright}->{license}));

    $bzly->{copyright}->{license}->{long} = ""
        unless (exists($bzly->{copyright}->{license}->{long}) &&
                defined($bzly->{copyright}->{license}->{long}) && 
                length($bzly->{copyright}->{license}->{long}));

    $bzly->{copyright}->{license}->{name} = ""
        unless (exists($bzly->{copyright}->{license}->{name}) &&
                defined($bzly->{copyright}->{license}->{name}) && 
                length($bzly->{copyright}->{license}->{name}));

    $bzly->{version}                  = {};    
    $bzly->{version}->{number}        = 0;
    $bzly->{version}->{date}          = $dt;
    $bzly->{version}->{time}          = $tm;
    $bzly->{version}->{_generator}    = "breezly.pl version $brzvz"
        if (defined($brzvz) &&
            length($brzvz));

    return $bzly;
} # end build_breezly_metadata

# check_breezly_defs(breezly.pl optdef hash (not target),
#                    input file name, target file optdef h, breezly version)
sub check_breezly_defs2
{
    my ($breezly_bop, $filnam, $bigh, $brzvz) = @_;

    $bigh->{_defs} =  
        build_breezly_metadata2(
            $breezly_bop,
            $filnam, $bigh, $brzvz)
        unless (exists($bigh->{_defs}));

    if (exists($bigh->{args}) &&
        scalar(@{$bigh->{args}}))
    {
        for my $ii (0..((scalar(@{$bigh->{args}})-1)))
        {
            my $arg1 = $bigh->{args}->[$ii];

            die "$filnam: no name for arg number $ii"
                unless (exists($arg1->{name}));

            my $nam = $arg1->{name};

            $arg1->{short} = $nam
                unless (exists($arg1->{short}) ||
                        exists($arg1->{long}));

            if (exists($arg1->{long}) &&
                !exists($arg1->{short}))
            {
                # short option cannot contain carriage returns.  
                # So if the short is *not* set, 
                #   use the long if it does *not* have a carriage return, 
                #   else use the name
                if ($arg1->{long} !~ m/\n/)
                {
                    $arg1->{short} = $arg1->{long};
                }
                else
                {
                    $arg1->{short} = $nam;
                }
            }
            $arg1->{long} = $arg1->{short}
                unless (exists($arg1->{long}));

            die "$filnam: arg $nam cannot have carriage return in short description"
                if ($arg1->{short} =~ m/\n/);

            $arg1->{required} = 0
                unless (exists($arg1->{required}));

            die "$filnam: arg $nam required must be 0, 1 or 2"
                unless ($arg1->{required} =~ m/^(\")?(0|1|2)(\")?$/);

            $arg1->{type} = "untyped"
                unless (exists($arg1->{type}));

            # "required" means the argument has a value, and untyped
            # arguments don't have one...
            die "$filnam: untyped arg $nam cannot be \"required\""
                if (("untyped" eq $arg1->{type}) &&
                    ($arg1->{required} > 0));

        } # end for

    }

    return $bigh;
} # end check_breezly_defs

# fixup_breezly_defs(breezly.pl optdef hash (not target),
#                    file name, file contents [as string])
#
# convert triple-quote expressions to "quurl" strings
# fix json formatting
sub fixup_breezly_defs2
{
    my ($breezly_bop, $filnam, $bigstr, $defp) = @_;

    my $brzvz = $breezly_bop->{_defs}->{version}->{number};

    # find the basic region with the breezly definitions
    my $prefx = quotemeta("BREEZLY_BEGIN_DEFS");
    my $suffx = quotemeta("BREEZLY_END_DEFS");

    my @ddd = 
        ($bigstr =~ m/^\s*\#\s*$prefx\s*$(.*)^\s*\#\s*$suffx\s*$/ms);

    die ("$filnam: could not fixup breezly definitions")
        unless (scalar(@ddd));

    # save the original region as a regex so we can replace it later
    my $orig_rex = quotemeta($ddd[0]);

    # triple quote fixup
    my @zzz = split(/(\"\"\")/, $ddd[0]);

    my $fixstr = "";

    if (!scalar(@zzz))
    {
        $fixstr = $ddd[0];
    }
    else
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
        die("$filnam: unterminated triple quote in breezly definitions")
            if ($inquote);
    } # end else

    # extract the JSON from the EOF_bigstr here document
    $prefx = quotemeta("EOF_bigstr");
    $suffx = quotemeta("EOF_bigstr");

    @ddd = 
        ($fixstr =~ m/\<\<\s*\'$prefx\'\;\s*$(.*)^$suffx\s*$/ms);

    die ("$filnam: could not fixup breezly json definitions")
        unless (scalar(@ddd));

    # reformat using JSON

    my $bigh = breezly_json_decode($breezly_bop, $ddd[0]);

    my $cdxfunc = \&cmdline_defs_extension2;

    if (exists($breezly_bop->{initdef}) &&
         defined($breezly_bop->{initdef}))
    {

        my $argdef;

        $argdef = $breezly_bop->{argdef}
            if (exists($breezly_bop->{argdef}) &&
                defined($breezly_bop->{argdef}));

        do_initdefs($breezly_bop->{initdef},
                    $argdef, $brzvz, $filnam, $bigh, $cdxfunc);
    }

    # revise definition hash using command line defs...
    if ((exists($breezly_bop->{define}) &&
         defined($breezly_bop->{define})) ||
        (exists($breezly_bop->{jsondefine}) &&
         defined($breezly_bop->{jsondefine})) ||
        (exists($breezly_bop->{delete}) &&
         defined($breezly_bop->{delete})) ||
        (exists($breezly_bop->{increment}) &&
         defined($breezly_bop->{increment})) ||
        (exists($breezly_bop->{append}) &&
         defined($breezly_bop->{append})) ||
        (exists($breezly_bop->{jsonappend}) &&
         defined($breezly_bop->{jsonappend})))
    {

        my $argdef;

        $argdef = $breezly_bop->{argdef}
            if (exists($breezly_bop->{argdef}) &&
                defined($breezly_bop->{argdef}));

        if (exists($breezly_bop->{delete}) &&
            defined($breezly_bop->{delete}))
        {
            my $delh = {};
            
            for my $delk (@{$breezly_bop->{delete}})
            {
                $delh->{$delk} = 0;
            }

            # delete
            do_cmdline_defs2($breezly_bop, $argdef, $brzvz, $filnam, $bigh, $delh, 
                            0,  # !blong
                            1,  # delete=1
                            $cdxfunc);
        }

        do_cmdline_defs2($breezly_bop, $argdef, $brzvz, 
                        $filnam, $bigh, $breezly_bop->{define}, 
                        0,  # !blong
                        0,  # not delete/append/inc
                        $cdxfunc)
            if (exists($breezly_bop->{define}) &&
                defined($breezly_bop->{define}));

        do_cmdline_defs2($breezly_bop, $argdef, $brzvz, 
                        $filnam, $bigh, $breezly_bop->{jsondefine}, 
                        1,  # blong
                        0,  # not delete/append/inc
                        $cdxfunc)
            if (exists($breezly_bop->{jsondefine}) &&
                defined($breezly_bop->{jsondefine}));

        do_cmdline_defs2($breezly_bop, $argdef, $brzvz, 
                        $filnam, $bigh, $breezly_bop->{append}, 
                        0,  # !blong
                        2,  # append=2
                        $cdxfunc)
            if (exists($breezly_bop->{append}) &&
                defined($breezly_bop->{append}));

        do_cmdline_defs2($breezly_bop, $argdef, $brzvz, 
                        $filnam, $bigh, $breezly_bop->{jsonappend}, 
                        1,  # blong
                        2,  # append=2
                        $cdxfunc)
            if (exists($breezly_bop->{jsonappend}) &&
                defined($breezly_bop->{jsonappend}));

        if (exists($breezly_bop->{increment}) &&
            defined($breezly_bop->{increment}))
        {
            my $inc_h = {};
            
            for my $inck (@{$breezly_bop->{increment}})
            {
                $inc_h->{$inck} = 0;
            }

            # increment
            do_cmdline_defs2($breezly_bop, $argdef, $brzvz, 
                            $filnam, $bigh, $inc_h,
                            0,  # !blong
                            3,  # increment=3
                            $cdxfunc);
        }

    } # end if do_cmdline_defs...

    $defp->{defh} = $bigh;

    $fixstr = 
        breezly_json_encode_pretty(
            $breezly_bop,
            check_breezly_defs2($breezly_bop, $filnam, $bigh, $brzvz));

    # rebuild the function from the template
    my $newstr =  doformat(
        breezly_defs_tmpl(), {
            BEG1    => "BREEZLY_BEGIN_DEFS",
            END1    => "BREEZLY_END_DEFS",
            JSONDEF => $fixstr
        });

    # replace the entire function in the bigstr for the file contents
    $prefx = quotemeta("BREEZLY_BEGIN_DEFS");
    $suffx = quotemeta("BREEZLY_END_DEFS");

    $bigstr =~ s/^\s*\#\s*$prefx\s*$orig_rex^\s*\#\s*$suffx\s*$/$newstr/gm;

    return ($bigstr);
} # end fixup_breezly_defs

# unfix_breezly_defs(file name, file contents [as string])
#
# take a "fixed" json definition and convert all "long" strings to
# their triple-quoted representation.
sub unfix_breezly_defs
{
    my ($filnam, $bigstr) = @_;

    # find the basic region with the breezly definitions
    my $prefx = quotemeta("BREEZLY_BEGIN_DEFS");
    my $suffx = quotemeta("BREEZLY_END_DEFS");

    my @ddd = 
        ($bigstr =~ m/^\s*\#\s*$prefx\s*$(.*)^\s*\#\s*$suffx\s*$/ms);

    die ("$filnam: could not unfix breezly definitions")
        unless (scalar(@ddd));

    # save the original region as a regex so we can replace it later
    my $orig_rex = quotemeta($ddd[0]);

    # triple quote fixup
    my @zzz = split(/\n/, $ddd[0]);

    my $fixstr = "";

    if (!scalar(@zzz))
    {
        $fixstr = $ddd[0];
    }
    else
    {
        my $inquote = 0;

        my @lin2;

        # for each "long" definition, convert to a triple-quoted
        # region. skip over existing triple-quoted regions
        for my $lin (@zzz)
        {
            if ($inquote) # in a triple=quoted region
            {
                push @lin2, $lin;

                $inquote = 0
                    if ($lin =~ m/\"\"\"/);
            }
            else # not in a triple-quoted region yet
            {
                if ($lin =~ m/\"\"\"/)
                {
                    $inquote = 1;
                    push @lin2, $lin;
                    next;
                }

                # find /"long" : "<definition>"[,]/
                if ($lin =~ m/\s*\"long\"\s*\:\s*\".*\"(\,)?$/)
                {
                    # split into ("long" : "), (<definition>), ("[,])
                    #
                    my @mmm = 
                        ($lin =~ m/(\s*\"long\"\s*\:\s*\")(.*)(\"(?:\,)?)$/);
                    
                    die ("$filnam: could not unfix breezly definitions -\n$lin")
                        unless (3 == scalar(@mmm));

                    # rebuild the "long" with the unquoted string,
                    # surrounded by triple-quotes
                    push @lin2, $mmm[0] . '""' . 
                        unquurl($mmm[1]) . '""' .
                        $mmm[2];
                    next;
                }
                
                # normal case - no change
                push @lin2, $lin;
            } # end else

        } # end for my $lin

        # should have terminated triple quote before end of loop
        die("$filnam: unterminated triple quote in breezly definitions")
            if ($inquote);

        $fixstr = join("\n", @lin2);

    } # end else

    $bigstr =~ 
        s/(^\s*\#\s*$prefx\s*)$orig_rex(^\s*\#\s*$suffx\s*$)/$1\n$fixstr\n$2/gm;

    return ($bigstr);
} # end unfix_breezly_defs


# do_getdef2(breezly.pl optdef hash (not target),
#           argdef name [if defined], bool check_existence_only
#           getdef array, defh, bool longdump)
#
# return the json for each getdef entry.  Definitions are rooted under
# the "_defs" hash in defh.  
# Convert "dot" notation, ie "a.b.c", to {_defs}->{a}->{b}->{c}.
# In addition, convert array references like "a[5]" to {_defs}->{a}->[5]
#
# if check_existence_only = true, then return 1 if the provided defs are
# valid, else return 0.
#
# 
sub do_getdef2
{
    my ($breezly_bop, $argdef, $check_only, $getdefa, $defh, $blong) = @_;

    my $diemsg = "";
    my $bigstr = "";

    for my $entry (@{$getdefa})
    {
        my $dumpdef = $defh->{_defs};
        my $defstr  = '{_defs}';

        # check if possibly an "argdef"
        if (defined($argdef))
        {
            my $adef = $argdef;

            if ($entry =~ m/^$adef(((\.|\[).*)?)$/)
            {
                $dumpdef = $defh; # not defh->{args},
                $defstr = '';
                $entry =~ s/^$adef/args/;

                # check if argdef "by name" reference, ie 
                #   -getdef args.argname
                # vs args[argnum]
                if ($entry =~ m/^args\./)
                {
                    my @zzz = split(/\./, $entry, 3);

                    unless (scalar(@zzz) >= 2)
                    {
                        $diemsg = "illegal argdef reference $entry";
                        goto L_baddef;
                    }

                    shift @zzz; # pop "args"

                    # if treat "args" as hash by name, get the name
                    my $argname = shift @zzz; 
                    my $argidx;
                    
                    for my $ii (0..(scalar(@{$defh->{args}})-1))
                    {
                        if (exists($defh->{args}->[$ii]->{name}) &&
                            ($defh->{args}->[$ii]->{name} eq $argname))
                        {
                            $argidx = $ii;
                            last;
                        }
                    }

                    unless (defined($argidx))
                    {
                        $diemsg = 
                            "no such named argument \"$argname\" for $entry";
                        goto L_baddef;
                    }

                    # convert the entry to the array ref
                    $entry = 'args[' . $argidx . ']';

                    # append final bit if exists
                    $entry .= "." . $zzz[0] if (scalar(@zzz));
                }
            }
        } # end if defined $argdef

        my @foo = split(/\./, $entry);

        for my $pp (@foo)
        {
            my @arroff; # array offset

            # allow negative offsets
            if ($pp =~ m/(\[(\-)?\d+\])+$/) # [nn] suffix -- array notation
            {
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

                push @arroff, @zzz;

            }

            if (length($defstr))
            {
                $defstr .= '->{' . $pp . '}';
            }
            else
            {
                $defstr = '{' . $pp . '}';
            }

            unless (exists($dumpdef->{$pp}))
            {
                $diemsg = "no such entry \"$defstr\"";
                goto L_baddef;
            }

            $dumpdef = $dumpdef->{$pp};

            if (scalar(@arroff))
            {
                while (scalar(@arroff))
                {
                    my $aa = shift @arroff;

                    unless (ref($dumpdef) =~ m/ARRAY/)
                    {
                        $diemsg =
                            "entry \"$defstr\" is not an array -- " . 
                            "illegal offset \"$aa\"";
                        goto L_baddef;
                    }

                    # don't allow getdef of non-existent array entries

                    $defstr .= '->[' . $aa . ']';
                    
                    if (($aa >= scalar(@{$dumpdef})) ||
                        # negative subscript
                        ( 0 > ($aa + scalar(@{$dumpdef}))))
                    {
                        $diemsg = "no such entry \"$defstr\"";
                        goto L_baddef;
                    }

                    # add the array offset
                    $dumpdef = $dumpdef->[$aa];

                }
                
            }
        } # end for my $pp

        if (ref($dumpdef) =~ m/HASH|ARRAY/)
        {
            my $outstr = breezly_json_encode_pretty($breezly_bop,
                                                    $dumpdef);

            # convert to JSON and dump as "percent-encoded" string
            $outstr = quurl($outstr)
                if ($blong);

            if (!$check_only)
            {
                $bigstr .=  $outstr;
            }
            else
            {
                $bigstr .=  ref($dumpdef) . "\n";
            }
        }
        else # not a ref (scalar?)
        {

            if (!$check_only)
            {
                $bigstr .=  $dumpdef . "\n"
                    if (defined($dumpdef));

                # XXX XXX: maybe print "null" if $blong 
            }
            else
            {
                if (defined($dumpdef))
                {
                    $bigstr .= "SCALAR"  . "\n";
                }
                else
                {
                    $bigstr .= "UNDEF"  . "\n";
                }

            }
        }

    } # end for my entry

    return $bigstr;

  L_baddef:
    die $diemsg
        if (!$check_only);
    return "";
}
# end do_getdef

# dump_preferences(breezly.pl opdtdef hash (not target bigh), defh)
# prints to stdout
#
# NOTE: destructive!! 
sub dump_preferences
{
    my ($breezly_bop, $defh) = @_;
    my $genr;

    delete $defh->{args};
    delete $defh->{_defs}->{long};
    delete $defh->{_defs}->{short};
    delete $defh->{_defs}->{synopsis};

    $genr = $defh->{_defs}->{version}->{_generator}
        if (exists($defh->{_defs}->{version}) &&
            exists($defh->{_defs}->{version}->{_generator}));
    
    delete $defh->{_defs}->{version};

    # store the generator to check pref file compatibility
    $defh->{_defs}->{version} = { _generator => $genr }
        if (defined($genr) && length($genr));
    
    delete $defh->{_defs}->{copyright}->{year};
    
    delete $defh->{_defs}->{creation}->{creationdate};
    delete $defh->{_defs}->{creation}->{creationtime};
    
#    delete $defh->{_defs}->{prog};
    $defh->{_defs}->{prog} = {};

    print breezly_json_encode_pretty($breezly_bop, $defh);
    
}

# copy the original file to a new version, then replace with .brzly file
sub version_file
{
    my $filename = shift;

    my $vfile = $filename . '.*';
	
    my $foo = `ls $vfile`;
	
    my @file_list = split(/\n/, $foo);
	
    my $last_num = 0;
	
    for my $f2 (@file_list)
    {
        chomp $f2;
#        print "# ", $f2, "\n";
        my @baz = split(/\./, $f2);
        
        my $file_num = pop @baz;
        
        next
            unless ($file_num =~ m/^\d*$/);
        
        $last_num = $file_num
            if ($file_num > $last_num);
    }
	
    $last_num++;
	
    my $new_name = $filename . '.' . $last_num;
    my $brz_name = $filename . '.brzly';
	
    my $cpstr = "cp $filename $new_name\n";

    `$cpstr`;
    
    $cpstr = "cp $brz_name $filename\n";

    `$cpstr`;
	
} # end version_file

# template for bash completion function
sub compofunc_tmpl
{
    my $bigstr = << 'EOF_bigstr';
# Generated from the breezly_defs by breezly.pl version {BRZ_VERSION} 
# on {BRZ_DATE}.
_{FUNCNAME}() 
{
    local cur prev 
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    cwordarrstr=( $(echo ${COMP_WORDS[@]} | perl -ple '{s/([^a-zA-Z0-9])/uc(sprintf("%%%02lx",  ord $1))/eg;}' ) )

    if [[ ${cur} == -* ]] ; then
        COMPREPLY=( $(breezly.pl --compgen --compoptionname=${cur} --compoptionposition=${COMP_CWORD} --compoptionwords=${cwordarrstr} `which {FILENAME}`) )
        return 0
    else
        if [[ ${prev} == -* ]] ; then
           COMPREPLY=( $(breezly.pl --compgen --compoptionname=${prev} --compoptionvalue=${cur} --compoptionposition=${COMP_CWORD} --compoptionwords=${cwordarrstr} `which {FILENAME}`) )
           return 0
        else
           COMPREPLY=( $(breezly.pl --compgen --compoptionvalue=${cur} --compoptionposition=${COMP_CWORD} --compoptionwords=${cwordarrstr} `which {FILENAME}`) )
           return 0
        fi
    fi
}
complete -F _{FUNCNAME} {FILENAME}
#  -o bashdefault -o default
EOF_bigstr

    return $bigstr;
}

# generate a bash command-line completion function for the specified
# filename.  The file must have valid breezly_defs.
sub do_compofunc
{
    my ($breezly_bop, $filename) = @_;

    my $fnam = $filename;

    # trim suffix
    $fnam =~ s/\..*$//;

    my $brzvz = $breezly_bop->{_defs}->{version}->{number};
    my $dt = localtime();

    my $compfuncstr =
        doformat(compofunc_tmpl,
                 {
                     FUNCNAME    => $fnam,
                     FILENAME    => $filename,
                     BRZ_VERSION => $brzvz,
                     BRZ_DATE    => $dt
                 }
        );

    return $compfuncstr;
}


# do_compgen_do_disp1(breezly optdef hash, debug,
#                     target script name,
#                     defh args, array of COMP_WORDS,
#                     option name, position, value)
#
# helper for do_compgen_dispatch(), do_compgen()
sub do_compgen_do_disp1
{
    my ($breezly_bop, $dbg, $tgt, 
        $optworda,
        $optname, $optpos, $optval) = @_;
    
    my $nam2 = "";
    my $val2 = "";
    my $wda3 = "";
    
    # reduce the current position by 1 
    # (treat target script as if called directly)
    my $pos2 = " --compoptionposition=" . 
        ($optpos - 1) . " ";
            
    if (1)
    {
        $nam2 = " --compoptionname=$optname " 
            if (defined($optname) &&
                length($optname) &&
                ($optname =~ m/^\-/));
    }
            
    $val2 = " --compoptionvalue=$optval " 
        if (defined($optval));
        
    if (0)
    {
        unless (length($val2))
        {
            $val2 = " --compoptionvalue= "
                if (length($nam2));
        }
    }

    if (scalar(@{$optworda}) > 2)
    {
        my @tgtcworda; # target script cword array
        
        # rebuild the word array stripping the original script
        # name and first argument
        for my $ii (2..(scalar(@{$optworda}) - 1))
        {
            push @tgtcworda, quotemeta($optworda->[$ii]);
        }
        if (scalar(@tgtcworda))
        {
            # prepend the word list with the new target script name
            unshift @tgtcworda, quotemeta($tgt);
            
            $wda3 = " --compoptionwords=" . quurl(join(" ", @tgtcworda))
        }
        
    }
    
    # use current path of breezly
    my $sysstr = 
        "$0 --compgen $nam2 $val2 $pos2 $wda3 $tgt";

    warn("\nWarn! " . $sysstr . "\n")
        if ($dbg);

    system($sysstr);
} # end do_compgen_do_disp1


# do_compgen_dispatch(breezly optdef hash, debug,
#                     defh args, array of COMP_WORDS,
#                     option name, position, value)
#
# dispatch "compgen" style command completion to another script!
#
# helper function for do_compgen.  Returns 1 if did dispatch, else 0
sub do_compgen_dispatch
{
    my ($breezly_bop, $dbg, $allargs, $optworda,
        $optname, $optpos, $optval) = @_;

    my $bstat = 0;

    # check for the case of a leading positional arguments 
    # (check the COMP_WORDS array for a "-" for option 1)

    return $bstat
        unless (defined($optworda) && 
                (scalar(@{$optworda}) > 1) &&
                ($optworda->[1] !~ m/^\-/));

    # XXX XXX: strictly speaking, we want a "choices" attribute with a
    # dispatch, not a nude_pos option.
    # XXX XXX:
    
    for my $arg (@{$allargs})
    {
        next 
            unless (exists($arg->{xtra}) &&
                    exists($arg->{xtra}->{nude_pos}));

        # special case: if have a nude_pos option, and its
        # definition has a "choices" attribute with
        # "compoption" completion that redirects to subsidiary
        # perl scripts, then start invoking breezly --compgen
        # against those scripts.  
        # For example, the parent script supports commands
        # "fly" and "dance", but those invoke scripts
        # "foofly.pl" and "foodance.pl".  The "command" entry
        # could look like:
        #
        #     "choices" : {
        #        "dispatch" : "script",
        #        "values" : {
        #           "dance" : "foodance.pl",
        #           "fly" : "foofly.pl"
        #        },        
        #

        next
            unless (($arg->{xtra}->{nude_pos} == 1) &&
                    exists($arg->{choices}) &&
                    (ref($arg->{choices}) eq 'HASH') &&
                    exists($arg->{choices}->{values}) &&
                    (ref($arg->{choices}->{values}) eq 'HASH') &&
                    exists($arg->{choices}->{dispatch}) &&
                    ($arg->{choices}->{dispatch} eq "script") &&
                    exists($arg->{choices}->{values}->{$optworda->[1]}));
                    


        # IF have nude_pos option with dispatch THEN --

        # find the target script for the current choice
        my $tgt_raw  = 
            $arg->{choices}->{values}->{$optworda->[1]} . "";
        
        # try to resolve full path if name does not have "/"
        my $tgt = $tgt_raw . "";
        $tgt = `which $tgt_raw` unless ($tgt_raw =~ m/\//);
            
        unless (length($tgt))
        {
            # complain about invalid target but just skip
            warn("\ncannot resolve script $tgt_raw for option $optworda->[1]\n");
            last;
        }

        ## do the actual dispatch
        do_compgen_do_disp1($breezly_bop, $dbg, $tgt, 
                            $optworda,
                            $optname, $optpos, $optval);        
        return 1; # NOTE: only "success" case

    } # end for all args
    
    return $bstat;
} # end do_compgen_dispatch

# do_compgen_arg_choices(breezly optdef hash, defh arg, option value)
#
# process completion for choices attribute for supplied arg1, if they
# exist
#
# helper function for do_compgen.  Returns 1 if found choices, else 0
sub do_compgen_arg_choices
{
    my ($breezly_bop, $arg1, $optval) = @_;

    my $bstat = 0;

    return $bstat
        unless (exists($arg1->{choices}));

    my $valuea; # array of values
    my $ignor;  # ignore case

    if (ref($arg1->{choices}) eq "ARRAY")
    {
        # choices is an array of values: only support exact,
        # case-sensitive matching.
        
        $valuea = $arg1->{choices};
    }
    elsif ((ref($arg1->{choices}) eq 'HASH') &&
           (exists($arg1->{choices}->{values})))
    {
        if (ref($arg1->{choices}->{values}) eq 'ARRAY')
        {
            $valuea = $arg1->{choices}->{values};
        }
        # NEW: allow a hash - get keys
        # (yeah, I realize it's confusing that the hash keys are the
        # values array)
        if (ref($arg1->{choices}->{values}) eq 'HASH')
        {
            my @k1  = sort(keys(%{$arg1->{choices}->{values}}));
            $valuea = \@k1;
        }

        # check for match modifiers in choices hash
        if (exists($arg1->{choices}->{match}))
        {
            # choices can have an option match modifier: 
            # ignore and/or auto_abbrev
            $ignor = "(?i)"
                if ($arg1->{choices}->{match} =~ m/ignore/);
                        
            # NOTE: no special processing for "abbrev"
            # match -- compgen is expanding abbreviations
        }
    }

    # must have values to match
    return $bstat
        unless (defined($valuea) && scalar(@{$valuea}));

    if (!length($optval))
    {
        # no option specified (yet) so print all possible
        # values
        
        print join("\n", @{$valuea}) . "\n";
    }
    else
    {
        # NOTE: the option value is a substring of a
        # possible choice, so the match the full choice
        # value against this prefix
        my $rex = quotemeta($optval);
        
        # use "(?i)" ignore case prefix if defined
        $rex = $ignor . $rex 
            if (defined($ignor));
        
        for my $choice (@{$valuea})
        {
            print $choice . "\n"
                if ($choice =~ m/^$rex/);
        }
    }
    return 1; # NOTE: only "success" case

} # end do_compgen_arg_choices

# do_compgen(breezly optdef hash, defh)
#
# perform "compgen" style command completion
sub do_compgen
{
    my ($breezly_bop, $breezly_defp) = @_;

    my $allargs = $breezly_defp->{defh}->{args};
    my $optname = "";
    my $optval;
    my $optpos;
    my $optworda;

##    my $dbg = 1;
    my $dbg = 0;

    $optname = $breezly_bop->{compoptionname}
        if (exists($breezly_bop->{compoptionname}) &&
            defined($breezly_bop->{compoptionname}));

    $optval = $breezly_bop->{compoptionvalue}
        if (exists($breezly_bop->{compoptionvalue}) &&
            defined($breezly_bop->{compoptionvalue}));

    $optpos = $breezly_bop->{compoptionposition}
        if (exists($breezly_bop->{compoptionposition}) &&
            defined($breezly_bop->{compoptionposition}));

    # unpack the stringified COMP_WORDS array (rfc 3986 encoded)
    if (exists($breezly_bop->{compoptionwords}) &&
        defined($breezly_bop->{compoptionwords}))
    {
        my $wordstr = unquurl($breezly_bop->{compoptionwords});

        use Text::ParseWords;

        my @www = parse_line('\s+', 0, $wordstr);
        $optworda = \@www;
    }

    # special case: check if need to dispatch to another script
    if (defined($optpos) && 
        ($optpos > 1) &&
        defined($optworda) &&
        (scalar(@{$optworda}) > 2) &&
        ($optworda->[1] !~ m/^(\-)/))
    {
        # already "parsed" first argument, which was dispatch to
        # another script


        # sigh: need to find the "nude" argument again in the arg list...
        for my $arg (@{$allargs})
        {
            next 
                unless (exists($arg->{xtra}) &&
                        exists($arg->{xtra}->{nude_pos}));

            next
                unless (($arg->{xtra}->{nude_pos} == 1) &&
                        exists($arg->{choices}) &&
                        (ref($arg->{choices}) eq 'HASH') &&
                        exists($arg->{choices}->{values}) &&
                        (ref($arg->{choices}->{values}) eq 'HASH') &&
                        exists($arg->{choices}->{dispatch}) &&
                        ($arg->{choices}->{dispatch} eq "script") &&
                        exists($arg->{choices}->{values}->{$optworda->[1]}));
            
            # so now have found the argument with the choice value
            # that identifies the target script


            # find the target script for the current choice
            my $tgt_raw  = 
                $arg->{choices}->{values}->{$optworda->[1]} . "";

            
            # try to resolve full path if name does not have "/"
            my $tgt = $tgt_raw . "";
            $tgt = `which $tgt_raw` unless ($tgt_raw =~ m/\//);
            
            unless (length($tgt))
            {
                # complain about invalid target but just skip
                warn("\ncannot resolve script $tgt_raw for option $optworda->[1]\n");
                last;
            }

            ## do the actual dispatch
            do_compgen_do_disp1($breezly_bop, $dbg, $tgt, 
                                $optworda,
                                $optname, $optpos, $optval);        
            return; 

        } # end for

    } # end special case: dispatch to other script

    # remove "--" prefix for option name
    my $bdash = ($optname =~ m/^(\-)/);
    $optname =~ s/^(\-)((\-)?)//;

    # check for positional arguments
    if (defined($optpos) && 
        (0 == length($optname)) && defined($optval))
    {
        for my $arg (@{$allargs})
        {
            next 
                unless (exists($arg->{xtra}) &&
                        exists($arg->{xtra}->{nude_pos}));

            # if find a matching positional argument, treat it as the
            # option "name"
            if ($arg->{xtra}->{nude_pos} == $optpos)
            {
                $bdash = 1;
                $optname = $arg->{name} . "";
                last;
            }
        }
    }
        
    if (defined($optval))
    {
        unless ($bdash &&
                defined($optname) &&
                length($optname))
        {
            $optname = $optval;

            $bdash = ($optname =~ m/^(\-)/);
            $optname =~ s/^(\-)((\-)?)//;

            goto L_optname;
        }

        my $arg1;

        for my $arg (@{$allargs})
        {
            if ($arg->{name} =~ m/^$optname$/)
            {
                $arg1 = $arg;
                last;
            }
            else
            {
                # or find matching aliases
                if (exists($arg->{alias}))
                {
                    my @allalias = split(/\|/, $arg->{alias});
                    
                    push @allalias, $arg->{alias}
                        unless (scalar(@allalias));
                    
                    for my $ali (@allalias)
                    {
                        if ($ali =~ m/^$optname$/)
                        {
                            $arg1 = $arg;
                            last;
                        }
                    }
                }
            }
        } # end for my arg

        if (defined($arg1))
        {
            if ($arg1->{type} =~ m/^untyped/)
            {
                $optname = $optval;

                $bdash = ($optname =~ m/^(\-)/);
                $optname =~ s/^(\-)((\-)?)//;

                goto L_optname;
            }

            # see if this arg supports a list of choices
            return 
                if do_compgen_arg_choices($breezly_bop, $arg1, $optval);

            if ($arg1->{type} =~ m/file/)
            {
                system('bash -c "compgen -A file ' . "$optval\"");
                return;
            }
        }
        return;
    } # end if defined optval

  L_optname:

    # check if dispatching compgen to subsidiary script
    if ($bdash)
    {
        if (0) # XXX XXX: fix ?
{
        return 
            if (do_compgen_dispatch($breezly_bop, $dbg,
                                    $allargs, $optworda,
                                    # NOTE: replace missing dashes
                                    "--" . $optname, 
                                    $optpos, $optval));
}
    }

    unless ($bdash) # no leading dash for option ?
    {
        # check if dispatching compgen to subsidiary script
        return 
            if (do_compgen_dispatch($breezly_bop, $dbg,
                                    $allargs, $optworda,
                                    $optname, 
                                    $optpos, $optval));
        # 
        system('bash -c "compgen -A file ' . "$optname\"");
        return;
    } # end unless bdash

    # find names, matching names or aliases
    for my $arg (@{$allargs})
    {
        if (!length($optname))
        {
            # empty string: print all args
            print "--" . $arg->{name} . "\n";
        }
        else
        {
            # print matching arg names
            if ($arg->{name} =~ m/^$optname/)
            {
                print "--" . $arg->{name} . "\n";
            }
            else
            {
                # or find matching aliases
                if (exists($arg->{alias}))
                {
                    my @allalias = split(/\|/, $arg->{alias});
                    
                    push @allalias, $arg->{alias}
                    unless (scalar(@allalias));
                    
                    for my $ali (@allalias)
                    {
                        print "--" . $ali . "\n"
                            if ($ali =~ m/^$optname/);
                    }
                }
            }
        }
    } # end for my arg
    
    
    return;

} # end do_compgen

# do_breezly(input file name, breezly.pl optdef hash (not the target bigh))
#
# read in the file, modify it, and write out the ".brzly" file
#
sub do_breezly
{
    my ($filnam, $breezly_bop) = @_;

    my $infil;

    open ($infil, "< $filnam") or die "Could not open $filnam for reading : $! \n";

    # $$$ $$$ undefine input record separator (\n")
    # and slurp entire file into variable
    local $/;
    undef $/;

    my $bigstr = <$infil>;

    close $infil;

    my $breezly_defp = {};

    $bigstr = fixup_breezly_defs2($breezly_bop, 
                                  $filnam, $bigstr, $breezly_defp); 

    # reset back to triple-quoted form if specified
    if (exists($breezly_bop->{triplequote}) &&
        defined($breezly_bop->{triplequote}))
    {
        $bigstr =  unfix_breezly_defs($filnam, $bigstr);
    }

    if (exists($breezly_bop->{show}) &&
        defined($breezly_bop->{show}))
    {
        print Data::Dumper->Dump([$breezly_defp->{defh}]);
        return;
    }

    if (exists($breezly_bop->{preferences}) &&
        defined($breezly_bop->{preferences}))
    {
        dump_preferences($breezly_bop, $breezly_defp->{defh});
        return;
    }

    my $markup_only = (exists($breezly_bop->{wikimarkup}) &&
                       defined($breezly_bop->{wikimarkup}));

    $bigstr = 
        fixup_breezly_pod(
            $breezly_bop,
            $filnam, $bigstr, $breezly_defp->{defh}, 
            $markup_only); 

    if ($markup_only)
    {
        print $bigstr, "\n";
        return;
    }

    if (exists($breezly_bop->{compgen}) &&
        defined($breezly_bop->{compgen}))
    {
        return do_compgen($breezly_bop, $breezly_defp);
    }

    if (exists($breezly_bop->{compoptionfunction}) &&
        defined($breezly_bop->{compoptionfunction}))
    {
        use File::Basename;

        print do_compofunc($breezly_bop, basename($filnam));
        return;
    }

    if ((exists($breezly_bop->{checkdef}) &&
         defined($breezly_bop->{checkdef})) ||
        (exists($breezly_bop->{getdef}) &&
         defined($breezly_bop->{getdef})) ||
        (exists($breezly_bop->{getjsondef}) &&
         defined($breezly_bop->{getjsondef})))
    {
        my $argdef;

        $argdef = $breezly_bop->{argdef}
            if (exists($breezly_bop->{argdef}) &&
                defined($breezly_bop->{argdef}));

        print do_getdef2($breezly_bop,
                         $argdef, 1,
                        $breezly_bop->{checkdef}, $breezly_defp->{defh}, 0)
            if (exists($breezly_bop->{checkdef}) &&
                defined($breezly_bop->{checkdef}));

        print do_getdef2($breezly_bop,
                         $argdef, 0,
                        $breezly_bop->{getdef}, $breezly_defp->{defh}, 0)
            if (exists($breezly_bop->{getdef}) &&
                defined($breezly_bop->{getdef}));

        print do_getdef2($breezly_bop,
                         $argdef, 0,
                        $breezly_bop->{getjsondef}, 
                        $breezly_defp->{defh}, 1)
            if (exists($breezly_bop->{getjsondef}) &&
                defined($breezly_bop->{getjsondef}));

        return;
    }

    $bigstr = 
        fixup_breezly_cmdline(
            $breezly_bop,
            $filnam, $bigstr, $breezly_defp->{defh}); 

    # fixup utility functions for all files except breezly.pl
    $bigstr = 
        fixup_breezly_utility_functions(
            $breezly_bop,
            $0, $filnam, $bigstr)
        if (!isBreezly($filnam));

    my $outfilnam = $filnam . ".brzly";

    my $outfil;

    open ($outfil, "> $outfilnam") or die "Could not open $outfilnam for writing : $! \n";

    print $outfil $bigstr;

    close $outfil;

    if (exists($breezly_bop->{replace}) &&
        defined($breezly_bop->{replace}))
    {
        version_file($filnam);
    }
} # end do_breezly

# make_breezly_template(breezly optdef hash, breezly version)
# prints to stdout
#
sub make_breezly_template
{
    my ($bop, $brzvz) = @_;

    my $bigstr = << 'EOF_bigstr';
#!/usr/bin/perl
#
#
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;
use POSIX;

EOF_bigstr

    # basic options are help, man
    my $basic_opth = {
        args => [
            {
                alias => "?",
                name  => "help",
                short => "brief help message",
                long  => "Print a brief help message and exits."
            },
            {
                name  => "man",
                short => "full documentation",
                long  => "Prints the manual page and exits."
            }
            ]
    };

    # fill out internal breezly defs
    my $opth = 
        check_breezly_defs2(
            $bop,
            "template", $basic_opth, $brzvz);

    # add stubs for short, long, and synopsis (user should replace)
    if (exists($opth->{_defs}))
    {
        $opth->{_defs}->{short} = "<one line description of script>"
            unless (exists($opth->{_defs}->{short}));
        $opth->{_defs}->{synopsis} = "[options]"
            unless (exists($opth->{_defs}->{synopsis}));
        $opth->{_defs}->{long} = "<much longer description of this script...>"
            unless (exists($opth->{_defs}->{long}));
    }

    # construct the pod (documentation) header
    $bigstr .=
        fixup_breezly_pod(
            $bop,
            "template", 
            "# BREEZLY_POD_BEGIN\nXXXXXX\n# BREEZLY_POD_END\n",
            $opth);

    # build the breezly_defs() function
    my $fixstr = 
        breezly_json_encode_pretty(
            $bop, $opth);

    # rebuild the function from the template
    my $newstr =  doformat(
        breezly_defs_tmpl(), {
            BEG1    => "BREEZLY_BEGIN_DEFS",
            END1    => "BREEZLY_END_DEFS",
            JSONDEF => $fixstr
        });

    $bigstr .= $newstr;

    # add the validate_more() function and command line parsing
    $bigstr .= breezly_validate_more_tmpl();

    my $dt = localtime();

    $bigstr .= "\n# BREEZLY_CMDLINE_BEGIN\n" .
        doformat(breezly_parse_cmdline_tmpl(),
                 {
                     # NOTE: string "breezly_optdef_h", not hash value
                     OPTDEFH       => '$breezly_optdef_h',
                     GETOPTIONS    => '',
                     CHECKOPTIONS  => '',
                     PROG_ID       => 'template.pl',
                     BRZ_VERSION   => $brzvz,
                     BRZ_DATE      => $dt,
                     SPECIAL_FIXUP => '',
                     NUDE_POS      => ''
                 }) .
                     "\n# BREEZLY_CMDLINE_END\n";

    print $bigstr;

    return (0);
} # end make_breezly_template

# MAIN
if (1)
{
    my $bop = $breezly_optdef_h;

    # dump the breezly defs, perl-style
    if (exists($bop->{dump}) &&
        defined($bop->{dump}))
    {
        print Data::Dumper->Dump([$bop]);
        exit(0);
    }

    # build a template 
    if (exists($bop->{maketemplate}) &&
        defined($bop->{maketemplate}))
    {
        my $brzvz = $bop->{_defs}->{version}->{number};        
        exit(make_breezly_template($bop, $brzvz));
    }

    # version
    if (exists($bop->{version}) &&
        defined($bop->{version}))
    {
        print breezly_showversion($bop);
        exit(0);
    }

    for my $filnam (@ARGV)
    {
        do_breezly($filnam, $bop);
    }
}

if (0)
{
    my $bigstr = "aa|bb\nddd|e|ff\nh|iiiiiii";

    my $rowa = breezly_tbl_split($bigstr);

    print Data::Dumper->Dump($rowa);

    my $rowb = breezly_tbl_pad($rowa);

    print Data::Dumper->Dump($rowb);    

    print breezly_tbl_join($rowb,4);
}

##
## TODO: 
## improve long description
## m/^(a|b|c)$/i, m/[0..9]/
## extensible types
##
## xtra: short_header/footer, long_header/footer, hidden
## eg:
## xtra: aheader  { short: ... long: ...}, footer {short: ... long: ... }
##
## move alignment to breezly_tbl_pad
##
## line2tq - take an encoded line and revert to triple quoted form
## file2long - convert file to single quurl encoded line
## 
## help for types
##
## do_cmdline_defs - fix array of array assignment (ie a[2][3][4])
## allow negative? (eg -1 for last array entry?)
## def where no "=" creates an empty string, not a null
##
## short/long/template
## short - string
## long - formatted string
## template - separate def/fn for formatted string
##
##{
##   "msg" : "Value \"{VAL}\" invalid for option {NAM}: not a valid JSON string",
##   "name" : "json",
##   "parent" : "string",
##   "test" : "breezly_check_json({VAL})"
##}
##
## pod functions: key : templatefn(breezly defs)
##
## check file[], file% type inheritance...
##
## move utility functions to Breezly.pm: 
## format_with_lead_spaces, doformat, quurl, quurl2, unquurl
## breezly_tbl_split, breezly_tbl_pad, breezly_tbl_join, breezly_fmt_tbl
## basic_wikicreole2pod
## inc_lastnum, breezly_from_json
## maybe: do_cmdline_defs, do_getdef [would need to fix "argdef"]
## breezly_showversion
##
## leave extended types in breezly.pl because it generates the code --
## but could put validation functions in Breezly.pm (probably includes
## breezly_args_tmpl format function -- breezly.pl needs to load and
## execute them)
##
## array of named hashes def - aonh ? named hash array? for initdef
## 
## python style argparse "choices"
##   choices = [1,2,3]           # actual array
##   choices = "m/^(a|b|c)$/i"   # match string
##   choices = "[1..10]"         # range spec
## 
##   choices = { match = "abbrev, ignorecase", values = [a,b,c] }
##
## xtra: nude_pos - similar to python argparse positional arguments
##   just convert to named options prior to GetOptions() call
##   and fix compgen to return position
##  (argparse replaces optparse) 
