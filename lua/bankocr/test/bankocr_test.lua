
local valid_line = [[

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

]]

local multi_valid_line = [[

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

]]

local bankocr = require 'bankocr'

describe("story 1", function()
  it("should be able to find numbers", function()
    assert.equals(1, bankocr.lookup("     |  |"))
  end)
  it("should also return invalids as -1", function()
    assert.equals(-1, bankocr.lookup("|    |  |"))
  end)
  it("should process a valid line", function()
    local expect = {{1,2,3,4,5,6,7,8,9}}
    local result = bankocr.parse(valid_line)

    assert.same(expect, result)
  end)
  it("should process multiple valid lines", function()
    local expect = {{1,2,3,4,5,6,7,8,9},{1,2,3,4,5,6,7,8,9}}
    local result = bankocr.parse(multi_valid_line)

    assert.same(expect, result)
  end)
end)

describe("story 2", function()
  it("should validate", function()
    local input = {
      {1,2,3,4,5,6,7,8,9},
      {-1,2,3,4,5,6,7,8,9},
      {0,0,0,0,0,0,0,5,1},
      {7,7,7,7,7,7,1,7,7},
      {9,9,3,9,9,9,9,9,9},
      {9,8,7,6,5,4,3,2,1}
    }
    local expected = {true, false, true, true, true, false}

    local result = {}
    for k, v in pairs(input) do
      table.insert(result, bankocr.validate(v))
    end

    assert.same(expected, result)

  end)
end)

describe("story 3", function()
  it("should output nicely", function()
    local input = {
      {1,2,3,4,5,6,7,8,9},
      {-1,2,3,4,5,6,7,8,9},
      {9,8,7,6,5,4,3,2,1},
    }

    local expected = {
      "123456789",
      "?23456789 ILL",
      "987654321 ERR",
    }

    local result = {}
    for k, v in pairs(input) do
      table.insert(result, bankocr.prepare_for_output(v))
    end

    assert.same(expected, result)

  end)
end)
