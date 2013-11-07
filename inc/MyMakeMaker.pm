package inc::MyMakeMaker;
use Moose;

extends 'Dist::Zilla::Plugin::MakeMaker::Awesome';

use File::Spec;

override 'exe_files' => sub {
	return map { File::Spec->catfile('script', $_) } qw{s2p psed};
};

override _build_MakeFile_PL_template => sub {
	my ($self) = @_;
	my $template = super();
 
	$template .= <<'TEMPLATE';
package MY;

sub postamble {
	my $self = shift;

	return $self->SUPER::postamble . <<'END';
script/psed: script/s2p
	$(CP) script/s2p script/psed
END
}
TEMPLATE
 
	return $template;
};
 
__PACKAGE__->meta->make_immutable;

no Moose;

