#!/usr/bin/env bats

. src/util.sh

@test "dateDiff returns the difference in days between two YYYY-MM-DD dates" {
  result="$(dateDiff 2014-01-01 2014-01-31)"

  [ "$result" = "30" ]
}

@test "dateDiff prints error if invoked with dates in inverted order" {
  run dateDiff 2014-01-02 2014-01-01

  [ "$status" -eq 1 ]
  [ "$output" = "2014-01-02 is after 2014-01-01" ]
}

@test "checkDependenciesInPath returns true if dependencies are found" {
  run checkDependenciesInPath git
  [ "$status" -eq 0 ]
}

@test "checkDependenciesInPath returns false if dependencies are not found" {
  run checkDependenciesInPath git foobarqwer

  [ "$status" -eq 1 ]
  [ "$output" = "foobarqwer not found in PATH" ]
}