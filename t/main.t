#!perl

use strict;
use warnings;
use Test::More;

# Begin the tests! ############################################################
use_ok('Caller::Context');

# Test that the modlue is imported into a namespace
package My::Test::Namespace::XXX1 {
	use Caller::Context;
}
ok(My::Test::Namespace::XXX1->can('context'), 'context() function is imported successfully');

# Test that the modlue is imported into a namespace
package My::Test::Namespace::XXX2 {
	use Caller::Context ();
}
ok(!My::Test::Namespace::XXX2->can('context'), 'context() function should not be imported in `use MODULE ()` form');

# Test string overloading and string eq
my $context;

set_context();
is(  $context  =>  'VOID', 'check void context');
is(" $context" => ' VOID' );
ok( $context->is_void);
ok(!$context->is_list);
ok(!$context->is_scalar);

my @array = set_context();
is(  $context  =>  'LIST', 'check list context');
is(" $context" => ' LIST');
ok(!$context->is_void);
ok( $context->is_list);
ok(!$context->is_scalar);


my $scalar = set_context();
is(  $context  =>  'SCALAR', 'check scalar context');
is(" $context" => ' SCALAR');
ok(!$context->is_void);
ok(!$context->is_list);
ok( $context->is_scalar);

# All done
done_testing();

# Helper subs #################################################################

sub set_context {
	$context = context;
}


