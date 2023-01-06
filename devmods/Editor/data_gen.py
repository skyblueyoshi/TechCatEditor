from typing import List


class TypeStyle(object):
    var = 0
    list = 1
    dict = 2


def is_base_type(type_name: str):
    return type_name in ["int", "string"]


def read_file_to_lines(file_name: str):
    with open(file_name) as file:
        lines = [line.rstrip() for line in file]
    return lines


def process_lines(lines: List[str]):
    symbol_lists = []
    for line in lines:
        line = line.replace("    ", "")
        symbol_list = line.split(" ")
        if symbol_list:
            symbol_lists.append(symbol_list)
    return symbol_lists


def gen_page(symbol_lists: List[List[str]], index: int):
    res = ""
    class_name = ""
    members = []
    if symbol_lists[index][0] == "class":
        class_name = symbol_lists[index][1]
    else:
        return index
    index += 1
    while symbol_lists[index][0] != "class":
        symbol_list = symbol_lists[index]
        type_style = TypeStyle.var
        type_name = symbol_list[0]
        if type_name.endswith("[]"):
            type_style = TypeStyle.list
            type_name.removesuffix("[]")
        elif type_name.endswith("{}"):
            type_style = TypeStyle.dict
            type_name.removesuffix("{}")
        member = (symbol_list[1], symbol_list[1].capitalize(), type_name, symbol_list[3], type_style)
        members.append(member)

        index += 1
        if index >= len(symbol_lists):
            break

    print(members)
    res = '''---@class TCE.{0}:TCE.BaseData
local {0} = class("{0}", require("BaseData"))'''.format(class_name)

    res += '''local DataMembers = {\n'''

    for member in members:
        var_name = member[0]
        type_name = member[2]
        type_style = member[4]
        res += '''    ''' + member[0] + " = { " + member[3]
        if is_base_type(type_name):
            res += " },\n"
        else:
            res += ''', "{0}"'''.format(type_name)
        if type_style != TypeStyle.var:
            if type_style == TypeStyle.list:
                res += ''', "list" },\n'''

    print(res)


def start_gen():
    lines = read_file_to_lines("data_pattern.txt")
    gen_page(process_lines(lines), 0)


if __name__ == '__main__':
    start_gen()
