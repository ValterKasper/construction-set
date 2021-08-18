module line(a, b, width = 3) {
    radius = width / 2;

    $fn = 36;

    hull() {
        translate(a)
            circle(r=radius);
        translate(b)
            circle(r=radius);
    }
}

line([0, 0], [20, 10]);
line([20, 10], [25, -5]);
line([25, -5], [0, 0]);