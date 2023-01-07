import re
from typing import List


class TypeStyle(object):
    var = 0
    list = 1
    dict = 2


def cap_str(key: str):
    return re.sub('([a-zA-Z])', lambda x: x.groups()[0].upper(), key, 1)


def is_base_type(type_name: str):
    return type_name in ("number", "string", "boolean", "table")


def read_file_to_lines(file_name: str):
    with open(file_name) as file:
        lines = [line.rstrip() for line in file]
    return lines


def process_lines(lines: List[str]):
    symbol_lists = []
    for line in lines:
        line = line.replace("    ", "")
        if not line:
            continue
        symbol_list = line.split(" ")
        if symbol_list:
            symbol_lists.append(symbol_list)
    return symbol_lists


def gen_page(symbol_lists: List[List[str]], index: int):
    members = []
    if index >= len(symbol_lists):
        return index
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
            type_name = type_name.removesuffix("[]")
        elif type_name.endswith("{}"):
            type_style = TypeStyle.dict
            type_name = type_name.removesuffix("{}")
        member = (symbol_list[1], cap_str(symbol_list[1]), type_name, symbol_list[3], type_style)
        members.append(member)

        index += 1
        if index >= len(symbol_lists):
            break

    print(members)
    res = '''---@class TCE.{0}:TCE.BaseData
local {0} = class("{0}", require("BaseData"))\n'''.format(class_name)

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
                    res += ''', "list"'''
            res += " },\n"
    res += "}\n"

    res += '''
function {0}:__init(cfg)
    self:initData(DataMembers, cfg)
end

'''.format(class_name)

    for member in members:
        var_name = member[0]
        var_name_cap = member[1]
        type_name = member[2]
        comment_type_name = type_name
        type_style = member[4]
        if not is_base_type(type_name):
            comment_type_name = "TCE." + comment_type_name
        if type_style == TypeStyle.var:
            res += '''---@param value {3}
function {0}:set{2}(value)
    self:_set("{1}", value)
end

---@return {3}
function {0}:get{2}()
    return self:_get("{1}")
end

'''.format(class_name, var_name, var_name_cap, comment_type_name)
        elif type_style == TypeStyle.list:
            res += '''---@param value table
function {0}:set{2}(value)
    self:_set("{1}", value)
end

---@return {3}[]
function {0}:get{2}()
    return self:_get("{1}")
end

---@param element {3}
function {0}:addTo{2}(element)
    self:_listAppend("{1}", element)
end

function {0}:clear{2}()
    self:_listClear("{1}")
end

'''.format(class_name, var_name, var_name_cap, comment_type_name)

    res += "return {}".format(class_name)

    print(res)

    with open("control/data/" + class_name + ".lua", "w") as output:
        output.write(res)

    return index


def start_gen():
    lines = read_file_to_lines("data_pattern.txt")
    index = 0
    symbols = process_lines(lines)
    print("symbols", symbols)
    while True:
        new_index = gen_page(symbols, index)
        if new_index == index:
            break
        index = new_index


if __name__ == '__main__':
    start_gen()
