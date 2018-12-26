#!node_modules/bats/libexec/bats
############
# Authors: Ankshit Jain
# Purpose: Check the length of log file generated by the evaluation.
# Date: 01-Feb-2018
# Previous Versions: None
###########

# Setup and teardown functions.
setup() {
  echo "TEST_TYPE='evaluation_logs'" > "$BATS_TMPDIR/submission.conf"
  chmod +x "$BATS_TMPDIR/submission.conf"
  mkdir "$BATS_TMPDIR/$TESTDIR"
  cp -rf ../../docs/examples/io_tests/* "$BATS_TMPDIR/$TESTDIR/"
}

teardown() {
  rm "${BATS_TMPDIR:?}/submission.conf"
  rm -rf "${BATS_TMPDIR:?}/${TESTDIR:?}"
  mysql -h 127.0.0.1 -uroot -proot -e "DELETE FROM AutolabJS.llab1;"
}

@test "No log generated" {
  node ../test_modules/submit.js -i 2015A7PS006G -l lab1 --lang=java --host='localhost:9000' > \
    "$BATS_TMPDIR/$TESTDIR/no_log.txt"
  cmp "$BATS_TMPDIR/$TESTDIR/no_log.txt" "data/$TESTDIR/travis/no_log.txt"
  result="$?"
  [ "$result" -eq 0 ]
}

@test "Log file greater than 25 lines: shellOut.txt" {
  #For generating a log file that generates a shellout of more than 25 lines,
  #We create a submission which will generate more than 25 lines in shellOut.txt.
  #Setup : Copy the required files for achieving this situation
  cp -f "data/$TESTDIR/input1.txt" "$BATS_TMPDIR/$TESTDIR/test_cases/checks/input1.txt"
  cp -f "data/$TESTDIR/output1.txt" "$BATS_TMPDIR/$TESTDIR/test_cases/checks/output1.txt"
  cp -f "data/$TESTDIR/test_info.txt" "$BATS_TMPDIR/$TESTDIR/test_info.txt"
  #Submit and compare with expected result
  node ../test_modules/submit.js -i 2015A7PS006G -l lab1 --lang=java --host='localhost:9000' > \
    "$BATS_TMPDIR/$TESTDIR/java_exception.txt"
  cmp "$BATS_TMPDIR/$TESTDIR/java_exception.txt" "data/$TESTDIR/travis/shellOut_greater_than_25.txt"
  result="$?"
  [ "$result" -eq 0 ]
}

@test "Log file greater than 25 lines: log.txt" {
  #For generating a log file that generates a log file of more than 25 lines,
  #We create a submission which will generate more than 25 lines in log.txt.
  #Setup : Copy the required files for achieving this situation
  cp -f "data/$TESTDIR/compilation_error.cpp" "$BATS_TMPDIR/$TESTDIR/student_solution/cpp/a.cpp"
  #Submit and compare with expected result
  node ../test_modules/submit.js -i 2015A7PS006G -l lab1 --lang=cpp --host='localhost:9000' > \
    "$BATS_TMPDIR/$TESTDIR/cpp_compilation_error.txt"
  cmp "$BATS_TMPDIR/$TESTDIR/cpp_compilation_error.txt" "data/$TESTDIR/log_greater_than_25.txt"
  result="$?"
  [ "$result" -eq 0 ]
}

@test "Log file greater than 50 lines: log.txt and shellOut.txt" {
  #For generating a log file that generates a log file of more than 25 lines,
  # in both log files, log.txt and shellOut.txt
  #We create a submission which will generate such a case.
  #Setup : Copy the required files for achieving this situation
  cp -f "data/$TESTDIR/Solution_Exception.java" "$BATS_TMPDIR/$TESTDIR/student_solution/java/Solution_Exception.java"
  cp -f "data/$TESTDIR/Solution_Compilation.java" "$BATS_TMPDIR/$TESTDIR/student_solution/java/Solution.java"
  cp -f "data/$TESTDIR/input1.txt" "$BATS_TMPDIR/$TESTDIR/test_cases/checks/input1.txt"
  cp -f "data/$TESTDIR/output1.txt" "$BATS_TMPDIR/$TESTDIR/test_cases/checks/output1.txt"
  cp -f "data/$TESTDIR/test_info.txt" "$BATS_TMPDIR/$TESTDIR/test_info.txt"
  cp -f "data/$TESTDIR/Test.sh" "$BATS_TMPDIR/$TESTDIR/test_cases/java/setup/Test.sh"

  #Submit and compare with expected result
  node ../test_modules/submit.js -i 2015A7PS006G -l lab1 --lang=java --host='localhost:9000' > \
    "$BATS_TMPDIR/$TESTDIR/log_greater_than_50.txt"
  cmp "$BATS_TMPDIR/$TESTDIR/log_greater_than_50.txt" "data/$TESTDIR/travis/log_greater_than_50.txt"
  result="$?"
  [ "$result" -eq 0 ]
}
