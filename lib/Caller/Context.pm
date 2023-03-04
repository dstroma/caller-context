use warnings;
use strict;

package Caller::Context 0.001 {
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
		my $wantarray = (caller(1))[5];
		return $void_obj   if !defined $wantarray;
		return $list_obj   if $wantarray;
		return $scalar_obj if !$wantarray;
	}
}

package Caller::Context::Object {
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
};

package Caller::Context::VOID   { our @ISA = ('Caller::Context::Object'); sub is_void   { 1 } };
package Caller::Context::LIST   { our @ISA = ('Caller::Context::Object'); sub is_list   { 1 } };
package Caller::Context::SCALAR { our @ISA = ('Caller::Context::Object'); sub is_scalar { 1 } };

1;

=pod

=head1 NAME

Caller::Context -- A less cryptic replacement for perl's wantarray builtin.

=head1 SYNOPSIS

	use Caller::Context;
	sub mysub {
		return 'void'   if context eq 'VOID';
		return 'list'   if context->is_list;
		return 'scalar' if context->isa('Caller::Context::SCALAR');
	}

	mysub(); # void
	my $x = mysub(); # scalar
	my @x = mysub(); # list

=head1 EXPORTS

The only export is the context() function. If you would prefer to fully qualify
it, you can use Caller::Context::context() instead.

=head1 FUNCTIONS

The only function is the context() function. It takes no arguments and it
returns an instance of a Caller::Context::Object (either Caller::Context::VOID,
::LIST, or ::SCALAR) depending upon the context in which the currently executing
subroutine is being called.

These Caller::Context::Object objects overload stringification and string
equals, to equal 'VOID', 'LIST', or 'SCALAR' as appropriate.

=head1 METHODS

The object returned by Caller::Context::context contains the following methods:

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

=head1 AUTHOR

Dondi Michael Stroma

=cut

