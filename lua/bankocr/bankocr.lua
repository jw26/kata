
local lookupt = {
  [" _ | ||_|"] = 0, ["     |  |"] = 1,
  [" _  _||_ "] = 2, [" _  _| _|"] = 3,
  ["   |_|  |"] = 4, [" _ |_  _|"] = 5,
  [" _ |_ |_|"] = 6, [" _   |  |"] = 7,
  [" _ |_||_|"] = 8, [" _ |_| _|"] = 9,
}

local function lookup (inp)
  return lookupt[inp] == nil and -1 or lookupt[inp]
end

-- pilfered from http://lua-users.org/wiki/SplitJoin
local function lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

local function parse (inp)
  local split = lines(inp)
  -- thanks to http://lua.2524044.n2.nabble.com/filter-an-array-in-place-td5920644.html
  for i=#split,1,-1 do
    if split[i] == "" then
      table.remove(split,i)
    end
  end

  -- now take 3 lines at a time
  local all = {}
  for i=1,#split-(#split/3),3 do
    local l = {}
    for j=1,9*3,3 do
      local num = split[i]:sub(j,j+2) .. split[i+1]:sub(j,j+2) .. split[i+2]:sub(j,j+2)
      table.insert(l,lookup(num))
    end
    table.insert(all,l)
  end
  return all
end

local function validate (inp)
  local result = 0
  local cnt = 1
  for i=9,1,-1 do
    result = result + inp[i]*cnt
    cnt = cnt + 1
  end

  return result % 11 == 0
end

return {
  lookup = lookup,
  parse = parse,
  validate = validate
}
