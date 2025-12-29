import pytest
from falcon_core.physics.device_structures.connection import Connection


def test_constructors_and_accessors():
    plunger = Connection.new_plunger("P1")
    assert plunger.name() == "P1"
    assert plunger.type() == "PlungerGate"
    assert plunger.is_plunger_gate()
    assert not plunger.is_barrier_gate()
    assert not plunger.is_screening_gate()
    assert not plunger.is_ohmic()
    assert not plunger.is_reservoir_gate()

    barrier = Connection.new_barrier("B1")
    assert barrier.name() == "B1"
    assert barrier.type() == "BarrierGate"
    assert not barrier.is_plunger_gate()
    assert barrier.is_barrier_gate()
    assert not barrier.is_screening_gate()
    assert not barrier.is_ohmic()
    assert not barrier.is_reservoir_gate()

    screening = Connection.new_screening("S1")
    assert screening.name() == "S1"
    assert screening.type() == "ScreeningGate"
    assert not screening.is_plunger_gate()
    assert not screening.is_barrier_gate()
    assert screening.is_screening_gate()
    assert not screening.is_ohmic()
    assert not screening.is_reservoir_gate()

    ohmic = Connection.new_ohmic("O1")
    assert ohmic.name() == "O1"
    assert ohmic.type() == "Ohmic"
    assert not ohmic.is_plunger_gate()
    assert not ohmic.is_barrier_gate()
    assert not ohmic.is_screening_gate()
    assert ohmic.is_ohmic()
    assert not ohmic.is_reservoir_gate()

    reservoir = Connection.new_reservoir("R1")
    assert reservoir.name() == "R1"
    assert reservoir.type() == "ReservoirGate"
    assert not reservoir.is_plunger_gate()
    assert not reservoir.is_barrier_gate()
    assert not reservoir.is_screening_gate()
    assert not reservoir.is_ohmic()
    assert reservoir.is_reservoir_gate()


def test__equality():
    screening = Connection.new_screening("S1")
    assert not (screening == 4)
    plunger = Connection.new_plunger("P1")
    other_plunger = Connection.new_plunger("P1")
    assert plunger == other_plunger
    assert plunger != screening
    assert screening != 4


def test_serialization_roundtrip():
    screening = Connection.new_screening("S1")

    screening_json_str = screening.to_json()
    rec_screening = Connection.from_json(screening_json_str)
    assert rec_screening.name() == "S1"
    assert rec_screening.is_screening_gate() and rec_screening.type() == "ScreeningGate"
    assert rec_screening == screening
