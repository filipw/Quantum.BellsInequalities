namespace BellsInequalities {

   open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    operation BellsInequalityA() : (Bool, Bool) {
        using ((q1, q2) = (Qubit(), Qubit())) {
            X(q1);
            X(q2);

            H(q1);
            CNOT(q1, q2);

            Rz(PI() / 3.0, q2);
            H(q1);
            H(q2);
            return (MResetZ(q1) == One, MResetZ(q2) == One);
        }
    }

    operation BellsInequalityB() : (Bool, Bool) {
        using ((q1, q2) = (Qubit(), Qubit())) {
            X(q1);
            X(q2);

            H(q1);
            CNOT(q1, q2);

            Rz(2.0 * PI() / 3.0, q2);
            H(q1);
            H(q2);
            return (MResetZ(q1) == One, MResetZ(q2) == One);
        }
    }

    operation BellsInequalityC() : (Bool, Bool) {
        using ((q1, q2) = (Qubit(), Qubit())) {
            X(q1);
            X(q2);

            H(q1);
            CNOT(q1, q2);

            Rz(PI() / 3.0, q1);
            Rz(2.0 * PI() / 3.0, q2);
            H(q1);
            H(q2);
            return (MResetZ(q1) == One, MResetZ(q2) == One);
        }
    }
}

