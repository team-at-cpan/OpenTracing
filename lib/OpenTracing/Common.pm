package OpenTracing::Common;

use strict;
use warnings;

# VERSION

sub new {
    my ($class, %args) = @_;
    bless \%args, $class
}

1;

