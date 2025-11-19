// personal library for openscad

module flip_z() {
    scale([1, 1, -1]) children();
}

module flip_y() {
    scale([1, -1, 1]) children();
}

module flip_x() {
    scale([-1, 1, 1]) children();
}

module id() {
    children();
}

function sum(l, i = 0) =
    i < len(l)
        ? l[i] + sum(l, i + 1)
        : 0;

function slice(l, from, to) =
    to != undef  // HACK: if to is undefined, then we assume 'from' is actually 'to' and from is 0.
        ? to >= from  // when range is empty, make empty list yo.
            ? [for (i = [from : to]) l[i]]
            : []
        : slice(l, 0, from);
