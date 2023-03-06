use warnings;
use strict;
use v5.12;

package Caller::Context 0.001;
use Exporter;
use parent 'Exporter';

BEGIN {
	our @EXPORT = ('context');
}

my $void_str   = 'VOID';
my $list_str   = 'LIST';
my $scalar_str = 'SCALAR';

my $void_obj   = bless \$void_str,   'Caller::Context::VOID';
my $list_obj   = bless \$list_str,   'Caller::Context::LIST';
my $scalar_obj = bless \$scalar_str, 'Caller::Context::SCALAR';

sub context {
	if (my $wantarray = (caller(1))[5]) {
		$list_obj;
	} elsif (defined $wantarray) {
		$scalar_obj;
	} else {
		$void_obj;
	}
}

package Caller::Context::Object;
use overload (
	'""' => 'as_string',
	'eq' => 'string_eq',
);

sub as_string {
	return ${$_[0]};
}

sub string_eq {
	return ${$_[0]} eq $_[1];
}

sub is_void   { undef }
sub is_list   { undef }
sub is_scalar { undef }

package Caller::Context::VOID;   our @ISA = ('Caller::Context::Object'); sub is_void   { 1 }
package Caller::Context::LIST;   our @ISA = ('Caller::Context::Object'); sub is_list   { 1 }
package Caller::Context::SCALAR; our @ISA = ('Caller::Context::Object'); sub is_scalar { 1 }

1;

=pod

=head1 NAME

Caller::Context -- A less cryptic replacement for perl's wantarray() function.

=head1 SYNOPSIS

	use Caller::Context;
	sub mysub {
		return (qw/wants list/) if context->is_list;     # object interface
		return 'wants scalar'   if context eq 'SCALAR';  # or use string eq
		say context;
	}

	my @x = mysub(); # returns ('wants', 'list')
	my $x = mysub(); # returns 'wants scalar'
	mysub();         # says 'VOID'

=head1 JUSTIFICATION

Not only is the C<wantarray> function incorrectly named for the reason that
there is no such thing as array context (it is actually list context -- even
perldoc says it should have been called wantlist instead), but also for the
reason that it can actually tell you which context of three it's being called
in: list, scalar, or void. So it really should have been three functions:
wantlist(), wantscalar(), and wantvoid().

This module allows you to obtain this information in a more readable way. You
can use string comparisons, or call methods on the returned object. The latter
is not only faster but probably more readable.

CPAN already has the L<Want> module, but that module requires XS and its API is
quite different than this one. This module is written in pure perl but is 5 to
10 times faster than L<Want>, though it does not have as many features.

=head1 EXPORTS

The only export is the C<context> function. If you would prefer to not import
this function into your namespace, you can

	use Caller::Context ();

and then call C<Caller::Context::context> instead.

=head1 FUNCTIONS

=over 4

=item context

It takes no arguments and returns an instance of Caller::Context::VOID,
Caller::Context::LIST, or Caller::Context::SCALAR (which all inherit from
Caller::Context::Object), according to the context in which the currently
executing subroutine is being called.

You may call methods on this object, or take advantage of its string overloading
and compare it to C<'VOID'>, C<'LIST'>, or C<'SCALAR'>.

=back

=head1 METHODS

The context() function returns an object that responds to the following methods:

=over 4

=item is_void

Returns a true value if the object is an instance of Caller::Context::VOID,
otherwise returns false.

=item is_list

Returns a true value if the object is an instance of Caller::Context::LIST,
otherwise returns false.

=item is_scalar

Returns a true value if the object is an instance of Caller::Context::SCALAR,
otherwise returns false.

=back

=head1 SEE ALSO

L<Want>

=head1 AUTHOR
 
Dondi Michael Stroma, E<lt>dstroma@gmail.comE<gt>
 
=head1 COPYRIGHT AND LICENSE
 
Copyright (C) 2023 by Dondi Michael Stroma
 
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
 
=cut
