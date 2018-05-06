sub inicializarParametrosQuestEden {
    my %parametrosQuestEden = (
        armaLevel26e40 => 'maça',
        armaLevel60 => 'machado',
        IDarmaIniciante => 16004,
        IDarmaIntermediario => 16005,
        IDarmaEden => 1391
    );
    my $eventMacro = $eventMacro::Data::eventMacro;
    $eventMacro->set_full_hash('parametrosQuestEden', \%parametrosQuestEden);
}

