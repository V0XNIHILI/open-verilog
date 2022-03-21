from jinja2 import Template

operators = [("xor", "xnor", "^"), ("and", "nand", "&"), ("or", "nor", "|")]


def generate_3_4_input_boolean_operators_verilog():
    with open("boolean_operator.v.jinja2") as t:
        template = Template(t.read())

        for op, nop, op_symbol in operators:
            for size in [3, 4]:
                for (opToWrite, negate) in zip([op, nop], [False, True]):
                    with open(opToWrite + str(size) + ".v", "w") as r:
                        r.write(
                            template.render(
                                operator=opToWrite,
                                symbol=op_symbol,
                                size=size,
                                negate=negate,
                            )
                        )


if __name__ == "__main__":
    generate_3_4_input_boolean_operators_verilog()
