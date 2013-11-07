use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Spec;
 
my %args = (
##{ $plugin->get_default(qw(NAME ABSTRACT AUTHOR LICENSE VERSION)) ##}
##{ $plugin->get_prereqs(1) ##}
  EXE_FILES => [ map { File::Spec->catfile('script', $_) } qw{s2p psed} ]
);
 
unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $args{TEST_REQUIRES};
  my $br = $args{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}
 
unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $args{BUILD_REQUIRES};
  my $pp = $args{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}
 
delete $args{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };
 
delete $args{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };
 
WriteMakefile(%args);
 
package MY;

sub postamble {
	my $self = shift;

	return $self->SUPER::postamble . <<'END';
script/psed: script/s2p
	$(CP) script/s2p script/psed
END
}
