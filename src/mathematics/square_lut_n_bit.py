import argparse

from jinja2 import Template

def get_d_str(inp: int, bit_width: int):
    prepend = ""

    if inp < 0:
        prepend = "-"

    return f"{prepend}{bit_width}'d{abs(inp)}"

def get_square_lut_str(bit_width: int):
    min_value = -2 ** (bit_width - 1)
    max_value = 2 ** (bit_width-1) - 1

    inputs = [i for i in range(min_value, max_value + 1)]
    square_lut = [i ** 2 for i in inputs]

    lut_str = ""

    table = list(zip(inputs, square_lut))

    for inp, value in table[:-1]:
        lut_str += f"\t\t(in === {get_d_str(inp, bit_width)}) ? {get_d_str(value, 2*bit_width)} :\n"

    lut_str += f"\t\t{get_d_str(table[-1][1], 2*bit_width)};"

    return lut_str


def generate_n_bit_square_lut_verilog(bit_width: int, lut_str: str):
    with open("square_lut_n_bit.v.jinja2") as t:
        template = Template(t.read())

        with open("square_lut_" + str(bit_width) + "_bit.v", "w") as r:
            r.write(
                template.render(
                    bit_width=bit_width,
                    lut=lut_str
                )
            )

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-n", "--n_bit", type=int, help="The bit width of the square LUT", default=4)
    args = parser.parse_args()

    bit_width = args.n_bit
    lut_str = get_square_lut_str(bit_width)

    generate_n_bit_square_lut_verilog(bit_width, lut_str)
