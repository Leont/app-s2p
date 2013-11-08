package inc::MyMakeMaker;
use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

override 'exe_files' => sub {
	return qw{script/s2p script/psed};
};

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;
	my $template = super();
 
	$template .= <<'TEMPLATE';
package MY;

use File::Spec;

sub postamble {
	my $self = shift;

	my ($s2p, $psed) = map { File::Spec->catfile('script', $_) } qw/s2p psed/;
	return $self->SUPER::postamble . <<"END";
$psed: $s2p
	\$(CP) $s2p $psed
END
}
TEMPLATE
 
	return $template;
};
 
__PACKAGE__->meta->make_immutable;

no Moose;

