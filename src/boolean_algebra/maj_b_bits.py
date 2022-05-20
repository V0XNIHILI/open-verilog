from itertools import combinations

from jinja2 import Template

MAJORITY_GATE_WIDTH = 9


def generate_n_bit_majority_gate_verilog():
    majority_gate_half_width = int(MAJORITY_GATE_WIDTH/2+1)

    combs = list(map(lambda x: list(x), combinations(
        list(range(MAJORITY_GATE_WIDTH)), majority_gate_half_width)))

    with open("maj_n_bits.v.jinja2") as t:
        template = Template(t.read())

        with open("maj_" + str(MAJORITY_GATE_WIDTH) + "_bits.v", "w") as r:
            r.write(
                template.render(
                    width=MAJORITY_GATE_WIDTH,
                    half_width=majority_gate_half_width,
                    combs=combs,
                    final_nand_width=len(combs)
                )
            )


if __name__ == "__main__":
    generate_n_bit_majority_gate_verilog()
