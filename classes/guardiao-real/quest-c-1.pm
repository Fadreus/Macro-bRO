sub inicializarParamsQuestClasse1 {
    my %paramsQuestClasse1 = (
        nomeClasse => 'espadachim',
        npc => '74 172',
        mapa => 'izlude_in',
        precisaMover => 'nao',
        sequenciaConversa => 'r1 r0',
        equipeIniciante => 13415
    );
    my $eventMacro = $eventMacro::Data::eventMacro;
    $eventMacro->set_full_hash('paramsQuestClasse1', \%paramsQuestClasse1);
}

