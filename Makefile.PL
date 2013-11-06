use ExtUtils::MakeMaker;
 
my %args = (
##{ $plugin->get_default(qw(NAME ABSTRACT AUTHOR LICENSE VERSION EXE_FILES)) ##}
##{ $plugin->get_prereqs(1) ##}
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
	my $ret = $self->SUPER::postamble;

	$ret .= <<'END';
$(INST_SCRIPT)/psed: $(INST_SCRIPT)/s2p
	$(CP) $(INST_SCRIPT)/s2p $(INST_SCRIPT)/psed
	$(FIXIN) $(INST_SCRIPT)/psed
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/psed

pure_all :: $(INST_SCRIPT)/psed

END

}
