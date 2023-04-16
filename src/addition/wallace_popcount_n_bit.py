from jinja2 import Template
import math

import numpy as np


def calc_left_right(size: int, width: int, index: int):
    left_column_size = size // 3
    right_column_size = left_column_size + size % 3

    if size == 2:
        left_column_size = 0
        right_column_size = 2
    elif size == 1:
        left_column_size = 0
        right_column_size = 1

    column_sizes = np.zeros(width, dtype=np.int32)
    column_sizes[width-index-1] = right_column_size
    column_sizes[width-index-2] = left_column_size

    return column_sizes


def calc_all_column_sizes(size: int):
    width = math.ceil(math.log2(size+1))

    first_column = np.zeros(width, dtype=np.int32)
    first_column[width-1] = size

    all_columns = [first_column]

    while np.max(all_columns[-1]) >= 3:
        new_column = np.zeros(width, dtype=np.int32)

        index = width - 1

        for value in all_columns[-1]:
            new_column += calc_left_right(value, width, index)
            index -= 1

        all_columns.append(new_column)

    adder_columns = [all_columns[-1]]

    while not (adder_columns[-1] == np.ones(width, dtype=np.int32)).all():
        new_column = np.copy(adder_columns[-1])

        for index, value in enumerate(reversed(new_column)):
            actual_index = width - index - 1

            if value == 2:
                new_column[actual_index] = 1
                new_column[actual_index-1] += 1
                break
            elif value == 3:
                new_column[actual_index] = 1
                new_column[actual_index-1] += 1
                break

        adder_columns.append(new_column)

    return (width, all_columns, adder_columns[1:])


def generate_n_bit_majority_gate_verilog(mapping, row_sizes, width, output_width):
    with open("wallace_popcount_n_bit.v.jinja2") as t:
        template = Template(t.read())

        with open("wallace_popcount_" + str(width) + "_bit.v", "w") as r:
            r.write(
                template.render(
                    width=width,
                    output_width=output_width,
                    row_mapping=mapping,
                    row_sizes=row_sizes,
                )
            )


def generate_hardware_mapping(cols, half_adder_section=False):
    mapping = []

    for j, col in enumerate(cols):
        row_mapping = []
        row_indices = np.zeros(width, dtype=np.int32)

        for i, value in enumerate(col):
            current_index = 0

            if value == 0:
                row_mapping.append([])
            else:
                entry = []
                while value > 0:
                    if value >= 3:
                        entry.append(("fa", [current_index, current_index+1, current_index+2], {
                                     "prev_col": row_indices[i-1], "current_col": row_indices[i]}))
                        row_indices[i-1] += 1
                        row_indices[i] += 1
                        current_index += 3
                        value -= 3
                    elif (half_adder_section == True or j + 1 == len(cols)) and value >= 2:
                        entry.append(("ha", [current_index, current_index+1], {
                                     "prev_col": row_indices[i-1], "current_col": row_indices[i]}))
                        row_indices[i-1] += 1
                        row_indices[i] += 1
                        current_index += 2
                        value -= 2
                    elif value >= 1:
                        entry.append(("pt", [current_index], {
                                     "current_col": row_indices[i]}))
                        row_indices[i] += 1
                        current_index += 1
                        value -= 1
                row_mapping.append(entry)

        mapping.append(row_mapping)

    return mapping


if __name__ == "__main__":
    N = 11

    width, rows, half_adder_rows = calc_all_column_sizes(N)

    print(np.array(rows + half_adder_rows))

    mapping = generate_hardware_mapping(rows)
    final_sum_mapping = generate_hardware_mapping(half_adder_rows, True)

    generate_n_bit_majority_gate_verilog(mapping + final_sum_mapping, rows + half_adder_rows, N, width)
