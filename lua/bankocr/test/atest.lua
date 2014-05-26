
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

