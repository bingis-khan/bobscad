// personal library for openscad
// Usage:
// use <bobscad/bob.scad>

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



module live_hinge_2d(w, h, n, l, movejoin = false) {
	assert(n > 0);

	u = h / (3 + (n - 1) * 4);
	r = u / 2;

	m = (w - 4*r) / l - u;

	br = 3 * r;

	module hinge_cutout(r, width) {
			circle(r);
			translate([0, -r]) {
				square([width, 2*r]);
			};
			translate([width, 0]) {
				circle(r);
			}
	}

	module link() {
		difference() {
			hinge_cutout(r = 3*r, width = w - 6*r);
			hinge_cutout(r = r, width = w - 6*r);
		}

		for (x = [-(br- r) + 3*r + m:m + u:w - 6*r]) {
			translate([x, 0]) difference() {
				square(3*u, center=true);

				translate([-3*r, 0]) circle(r);
				translate([3*r, 0]) circle(r);
			}
		}
	}

	translate([br, br - (movejoin ? (4*r) : 0)]) {  // controversial: move it slightly to allow jouining it easily to other stuff
		link();
		if (n > 1) {
			for (i = [0:n-1 - (movejoin ? 0 : 1)]) translate([0, i * 4 * u + 4*u, 0]) {
				link();

				for (x = [-(br - r) + 2*r + m/2:m + u:w]) {
					translate([x, -2*u]) difference() {
						square(3*u, center=true);

						translate([-3*r, 0]) circle(r);
						translate([3*r, 0]) circle(r);
					}
				}

			}
		}
	}
}

// todo: add another option for starting and ending the hinge with joins
// todo: add yet another option for starting and ending the hinge with the "circle" part? not sure how to explain it. basically, currently with movejoin, we "cut" the hole in the hinge by half. I want the whole hole to be preserved, so that it looks nice. like, offet by 2r from either side.
module live_hinge(w, h, n, l, d, movejoin=false) {
	linear_extrude(d) {
		live_hinge_2d(w, h, n, l, movejoin=movejoin);
	}
}
