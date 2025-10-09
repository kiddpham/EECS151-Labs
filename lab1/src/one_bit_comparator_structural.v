module one_bit_comparator_structural (
    input a,
    input b,
    output greater,
    output less,
    output equal
);
    wire a_not, b_not;

    not(a_not, a); // TODO
    not(b_not, b); // TODO

    and(greater, a, b_not); // TODO
    and(less, a_not, b); // TODO
    xnor(equal, a, b); // TODO
endmodule
