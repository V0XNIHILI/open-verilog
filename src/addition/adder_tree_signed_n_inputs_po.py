import argparse
import math

from jinja2 import Template

def generate_layer(n_inputs: int):
    n_outputs = n_inputs // 2

    n_bypass = 0

    if n_inputs % 2 != 0:
        n_bypass = 1

    return n_outputs, n_bypass

def get_adder_tree_str(n_og_inputs: int, prevent_overflow: bool, signed: bool):
    n_inputs = n_og_inputs

    out = -1
    n_bypass = -1
    layer_index = 0

    table = []

    signed_prefix = "signed" if signed else ""

    adder_tree_str  = ""

    while out != 1 or n_bypass != 0:
        out, n_bypass = generate_layer(n_inputs)

        table.append((out, n_bypass))

        adder_tree_str += f"\n\twire{' ' + signed_prefix + ' '}[WIDTH+{layer_index+1 if prevent_overflow else ''}-1:0] layer_{layer_index} [{out}-1:0];\n\n"

        input_source = f"layer_{layer_index-1}" if layer_index > 0 else "in"

        for i in range(out):
            sum_indices = [2*i, 2*i+1]

            previous_layer_input = ""

            if len(table) > 1 and table[-2][1] == 1 and i == out-1:
                previous_layer_input = " + " + (f"layer_{layer_index-2}[{table[-3][0]+table[-3][1]-1}]" if layer_index > 1 else f"in[{n_og_inputs-1}]")
                sum_indices = [2*i]

            sum_str = " + ".join([f"{input_source}[{j}]" for j in sum_indices])

            adder_tree_str += f"\tassign layer_{layer_index}[{i}] = {sum_str}{previous_layer_input};\n"

        n_inputs = out + n_bypass

        layer_index += 1

    adder_tree_str += f"\n\tassign out = layer_{layer_index-1}[0];\n"

    return adder_tree_str

def generate_adder_tree_n_inputs(n_inputs: int, extra_out_bits: int, signed: bool, adder_tree_str: str):
    with open("adder_tree_signed_n_inputs_po.v.jinja2") as t:
        template = Template(t.read())

        with open("adder_tree_" + ("signed_" if signed else "") + str(n_inputs) +  "_inputs" + ("_po" if extra_out_bits != 0 else "" ) + ".v", "w") as r:
            r.write(
                template.render(
                    adder_tree_str=adder_tree_str,
                    n_inputs=n_inputs,
                    signed=signed,
                    extra_out_bits=extra_out_bits
                )
            )

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("-n", "--n_inputs", type=int, help="The number of inputs of the adder tree", default=4)
    parser.add_argument("-po", "--prevent_overflow", action="store_true", help="Prevent overflow by adding a bit to the output of each layer")
    parser.add_argument("-s", "--signed", action="store_true", help="Use signed inputs")
    args = parser.parse_args()

    n_inputs = args.n_inputs
    prevent_overflow = args.prevent_overflow
    signed = args.signed
    adder_tree_str = get_adder_tree_str(n_inputs, prevent_overflow, signed)

    extra_out_bits = math.ceil(math.log2(n_inputs)) if prevent_overflow else 0

    generate_adder_tree_n_inputs(n_inputs, extra_out_bits, signed, adder_tree_str)
