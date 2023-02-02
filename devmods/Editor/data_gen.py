import re
from typing import List


class TypeStyle(object):
    var = 0
    list = 1
    dict = 2


def cap_str(key: str):
    return re.sub('([a-zA-Z])', lambda x: x.groups()[0].upper(), key, 1)


def is_base_type(type_name: str):
    return type_name in ("number", "string", "boolean", "table", "any")


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


def has_symbol(symbol_list, symbol):
    for s in symbol_list:
        if s == symbol:
            return True
    return False


def to_lua_boolean_str(b_value):
    return "true" if b_value else "false"


def gen_page(symbol_lists: List[List[str]], index: int):
    members = []
    if index >= len(symbol_lists):
        return index, ""
    if symbol_lists[index][0] == "class":
        class_name = symbol_lists[index][1]
        need_parent_hooked = has_symbol(symbol_lists[index], "@notifyParent")
    else:
        return index, ""
    index += 1
    while symbol_lists[index][0] != "class":
        symbol_list = symbol_lists[index]
        type_style = TypeStyle.var
        type_name = symbol_list[0]
        if type_name.endswith("[]"):
            type_style = TypeStyle.list
            type_name = type_name[:-2]
        elif type_name.endswith("{}"):
            type_style = TypeStyle.dict
            type_name = type_name[:-2]
        member = (symbol_list[1], cap_str(symbol_list[1]), type_name, symbol_list[3], type_style)
        members.append(member)

        index += 1
        if index >= len(symbol_lists):
            break

    print(members)
    res = '''local BaseWidget = require("BaseWidget")
---@class TCE.{0}:TCE.BaseWidget
local {0} = class("{0}", BaseWidget)\n'''.format(class_name)
    res += '''local DataDefine = {{ notifyParent = {0}, }}\n'''.format(to_lua_boolean_str(need_parent_hooked))
    res += '''local PropertyDefines = {\n'''

    for member in members:
        var_name = member[0]
        type_name = member[2]
        type_style = member[4]
        res += '''    ''' + member[0] + " = BaseWidget.newPropDef({ " + member[3]
        if is_base_type(type_name):
            res += " }),\n"
        else:
            res += ''', "{0}"'''.format(type_name)
            if type_style != TypeStyle.var:
                if type_style == TypeStyle.list:
                    res += ''', "list"'''
            res += " }),\n"
    res += "}\n"

    res += '''
function {0}:__init()
    {0}.super.__init(self, DataDefine, PropertyDefines)
end

'''.format(class_name, to_lua_boolean_str(need_parent_hooked))

    for member in members:
        var_name = member[0]
        var_name_cap = member[1]
        type_name = member[2]
        comment_type_name = type_name
        type_style = member[4]
        if not is_base_type(type_name):
            comment_type_name = "TCE." + comment_type_name
        if type_style == TypeStyle.var:
            res += '''---@param {1} {3}
function {0}:set{2}({1})
    self:_set("{1}", {1})
end

---@return {3}
function {0}:get{2}()
    return self["{1}"]
end

'''.format(class_name, var_name, var_name_cap, comment_type_name)
        elif type_style == TypeStyle.list:
            res += '''---@return {3}[]
function {0}:get{2}()
    return self["{1}"]
end

---@param widget {3}
function {0}:{1}Add(widget)
    self:_propertyListAdd("{1}", widget)
end

---@param index number
---@param widget {3}
function {0}:{1}Insert(index, widget)
    self:_propertyListInsert("{1}", index, widget)
end

---@param widget {3}
function {0}:{1}Remove(widget)
    self:_propertyListRemove("{1}", widget)
end

---@param index number
function {0}:{1}RemoveAt(index)
    self:_propertyListRemoveAt("{1}", index)
end

function {0}:{1}Clear()
    self:_propertyListClear("{1}")
end

'''.format(class_name, var_name, var_name_cap, comment_type_name)

    res += "return {}".format(class_name)

    print(res)

    with open("widget/" + class_name + ".lua", "w") as output:
        output.write(res)

    return index, class_name


def start_gen():
    lines = read_file_to_lines("data_pattern.txt")
    index = 0
    symbols = process_lines(lines)
    print("symbols", symbols)
    classes = []
    while True:
        new_index, class_name = gen_page(symbols, index)
        if class_name:
            classes.append(class_name)
        if new_index == index:
            break
        index = new_index

    s = '''---@class TCE.WidgetPool
local WidgetPool = class("WidgetPool")
local WidgetPoolImpl = require("WidgetPoolImpl")'''

    for class_name in classes:

        s += '''\n\n---@return TCE.{0}
function WidgetPool.load{0}(data)
    return WidgetPoolImpl.load("{0}", data)
end'''.format(class_name)

    s += '''\n\nreturn WidgetPool'''

    with open("widget/WidgetPool.lua", "w") as output:
        output.write(s)


if __name__ == '__main__':
    start_gen()
