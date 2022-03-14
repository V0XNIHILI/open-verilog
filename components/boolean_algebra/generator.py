
from jinja2 import Template

operators = [("xor", "xnor", "^"), ("and", "nand", "&"), ("or", "nor", "|")]

with open("operator4.v.jinja2") as t:
        template = Template(t.read())

        for op, nop, op_symbol in operators:
            with open(op + str(4) + ".v", "w") as r:
                r.write(
                    template.render(
                        operator=op,
                        symbol=op_symbol,
                    )
                )
                
            with open(nop + str(4) + ".v", "w") as r:
                r.write(
                    template.render(
                        operator=nop,
                        symbol=op_symbol,
                        negate=True
                    )
                )
