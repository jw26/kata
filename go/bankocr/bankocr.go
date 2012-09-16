package bankocr

import (
  "strings"
  "strconv"
//  "fmt"
)

var lookup = map[string] int {
  " _ | ||_|" : 0, "     |  |" : 1,
  " _  _||_ " : 2, " _  _| _|" : 3,
  "   |_|  |" : 4, " _ |_  _|" : 5,
  " _ |_ |_|" : 6, " _   |  |" : 7,
  " _ |_||_|" : 8, " _ |_| _|" : 9,
}

func remove_blanks(s string) []string {
  r := []string {}
  for _, v := range strings.Split(s, "\n") {
    if v != "" {
      r = append( r, v )
    }
  }
  return r
}

func verifies(c []int) bool {
  t := 0
  for i, v := range c {
    if v < 0 {
      return false
    }
    t += v*(i+1)
  }
  return (t % 11) != 0
}

func contains_minus_one(in []int) bool {
  for _, v := range in {
    if v == -1 {
      return true
    }
  }
  return false
}

func prepare_for_output(in []int) string {
  s := []string {}
  for _, v := range in {
    if v < 0 {
      s = append(s, "?")
    } else {
      s = append(s, strconv.Itoa(v))
    }
  }

  r := strings.Join(s, "")
  if !verifies(in) {
    if contains_minus_one(in) {
      r += " ILL"
    } else {
      r += " ERR"
    }
  }
  return r
}

func lookup_numbers(s []string) []int {
  return lookup_numbersp(s, []int {})
}
func lookup_numbersp(s []string, acc []int) []int {
  if len(s[0]) < 3 || len(s[1]) < 3 || len(s[2]) < 3 {
    return acc
  }

  v, ok := lookup[s[0][:3] + s[1][:3] + s[2][:3]]
  s[0] = s[0][3:]
  s[1] = s[1][3:]
  s[2] = s[2][3:]

  if !ok {
    v = -1
  }
  return append(append(acc, v), lookup_numbers(s)...)
}

func parse(s string) [][]int {
  return parsep(remove_blanks(s), [][]int {})
}
func parsep(s []string, acc [][]int) [][]int {
  if len(s) == 0 {
    return acc
  }
  return append(append(acc, lookup_numbers(s[:3])), parsep(s[3:], acc)...)
}

