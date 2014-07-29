import unittest
import string
import bankocr

valid_line = """

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

"""

multi_valid_line = """

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

    _  _     _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|
  ||_  _|  | _||_|  ||_| _|

"""

class StoryOne(unittest.TestCase):

    def test_can_find_numbers(self):
        self.assertEquals(1, bankocr.lookup("     |  |"))

    def test_works_on_invalid(self):
        self.assertEquals(-1, bankocr.lookup("|||||||||"))

    def test_parses_a_valid_line(self):
        expect = [[1,2,3,4,5,6,7,8,9]]
        self.assertEquals(expect, bankocr.parse(valid_line))

    def test_parses_multiple_valid_lines(self):
        expect = [[1,2,3,4,5,6,7,8,9],[1,2,3,4,5,6,7,8,9]]
        self.assertEquals(expect, bankocr.parse(multi_valid_line))

class StoryTwo(unittest.TestCase):

    def test_should_validate(self):
        input = [
                [1,2,3,4,5,6,7,8,9],
                [-1,2,3,4,5,6,7,8,9],
                [0,0,0,0,0,0,0,5,1],
                [7,7,7,7,7,7,1,7,7],
                [9,9,3,9,9,9,9,9,9],
                [9,8,7,6,5,4,3,2,1]
                ]
        expected = [True, False, True, True, True, False]

        self.assertEquals(expected, map(bankocr.validate,input))

class StoryThree(unittest.TestCase):

    def test_should_output_nicely(self):
        input = [
                [1,2,3,4,5,6,7,8,9],
                [-1,2,3,4,5,6,7,8,9],
                [9,8,7,6,5,4,3,2,1],
                ]

        expected = [
                "123456789",
                "?23456789 ILL",
                "987654321 ERR",
                ]

        self.assertEquals(expected, map(bankocr.prepare_for_output,input))

if __name__ == '__main__':
    unittest.main()
