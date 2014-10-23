# Copyrights 2007-2014 by [Mark Overmeer].
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 2.01.
use warnings;
use strict;

package Log::Report::Lexicon::Table;
our $VERSION = '1.02';


use Log::Report 'log-report-lexicon';

use POSIX       qw/strftime/;
use IO::File    ();
use List::Util  qw/sum/;


sub new(@)  { my $class = shift; (bless {}, $class)->init({@_}) }
sub init($) {shift}

#-----------------------

#-----------------------

sub msgid($;$)   {panic "not implemented"}
sub msgstr($;$$) {panic "not implemented"}

#------------------

sub add($)      {panic "not implemented"}


sub translations(;$) {panic "not implemented"}


sub pluralIndex($)
{   my ($self, $count) = @_;
    my $algo = $self->{algo} or panic;
    $algo->($count);
}


sub setupPluralAlgorithm()
{   my $self  = shift;
    my $forms = $self->header('Plural-Forms')
        or error __x"there is no Plural-Forms field in the header";

    my $alg   = $forms =~ m/plural\=([n%!=><\s\d|&?:()]+)/ ? $1 : "n!=1";
    $alg =~ s/\bn\b/(\$_[0])/g;
    my $code  = eval "sub(\$) {$alg}";
    $@ and error __x"invalid plural-form algorithm '{alg}'", alg => $alg;
    $self->{algo}     = $code;

    $self->{nplurals} = $forms =~ m/\bnplurals\=(\d+)/ ? $1 : 2;
    $self;
}


sub nrPlurals() {shift->{nplurals}}


sub header($@)
{   my ($self, $field) = @_;
    my $header = $self->msgid('') or return;
    $header =~ m/^\Q$field\E\:\s*([^\n]*?)\;?\s*$/im ? $1 : undef;
}

1;
