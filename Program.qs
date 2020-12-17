namespace BellsInequalities {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;

    @EntryPoint()
    operation Main() : Unit {
            let p1 = Run("P(a,b)", BellsInequalityA);
            let p2 = Run("P(a,c)", BellsInequalityB);
            let p3 = Run("P(b,c)", BellsInequalityC);
            Message("|P(a,b)−P(a,c)| − P(b,c) ≤ 1, (if lower than 1, then EPR was right): " + DoubleAsString(-(p1 - p2) - p3));
    }

    operation Run(name : String, fn: (Unit => (Bool, Bool))) : Double {
        let runs = 4096;
        mutable zerozero = 0;
        mutable zeroone = 0;
        mutable onezero = 0;
        mutable oneone = 0;

        for (i in 0..runs) 
        {
            let (r1, r2) = fn();
            if (not r1 and not r2) { set zerozero += 1; }
            if (not r1 and r2) { set zeroone += 1; }
            if (r1 and not r2) { set onezero += 1; }
            if (r1 and r2) { set oneone += 1; }
        }

        let p1 = IntAsDouble(zerozero) / IntAsDouble(runs);
        let p2 = IntAsDouble(oneone) / IntAsDouble(runs);
        let p3 = IntAsDouble(zeroone) / IntAsDouble(runs);
        let p4 = IntAsDouble(onezero) / IntAsDouble(runs);

        Message("|00> " + DoubleAsString(p1));
        Message("|11> " + DoubleAsString(p2));
        Message("|01> " + DoubleAsString(p3));
        Message("|10> " + DoubleAsString(p4));

        let p = p1 + p2 - p3 - p4;
        Message(name + " " + DoubleAsString(p));
        return p;
    }

    operation BellsInequalityA() : (Bool, Bool) {
        using ((q1, q2) = (Qubit(), Qubit())) {
            X(q1);
            X(q2);

            H(q1);
            CNOT(q1, q2);

            Rz(PI() / 3.0, q2);
            return (MResetX(q1) == One, MResetX(q2) == One);
        }
    }

    operation BellsInequalityB() : (Bool, Bool) {
        using ((q1, q2) = (Qubit(), Qubit())) {
            X(q1);
            X(q2);

            H(q1);
            CNOT(q1, q2);

            Rz(2.0 * PI() / 3.0, q2);
            return (MResetX(q1) == One, MResetX(q2) == One);
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
            return (MResetX(q1) == One, MResetX(q2) == One);
        }
    }
}