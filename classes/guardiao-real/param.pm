sub inicializarParamsClasses {
    my %paramsClasses = (
        idC1 => 1,
        idC2 => 14,
        idC2Alt => 21,
        idC1T => 4002,
        idC2T => 4015,
        idC2TAlt => 4022,
        idC3 => '4066,4073'
    );
    my $eventMacro = $eventMacro::Data::eventMacro;
    $eventMacro->set_full_hash('paramsClasses', \%paramsClasses);
}

