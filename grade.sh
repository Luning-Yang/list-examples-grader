CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'

# Check if ListExamples.java exists in the student-submission directory
if [ ! -f student-submission/ListExamples.java ]
then
    echo "Error: ListExamples.java was not found in the student submission directory. Please ensure it's included in your submission."
    exit 1
fi

# Copy the student's .java files into the grading-area directory
cp student-submission/*.java grading-area/

# Copy the TestListExamples.java from the current directory to the grading-area
cp TestListExamples.java grading-area/

# Compile the .java files in the grading-area directory
cd grading-area
javac -cp $CPATH *.java 2> compile_errors.txt
COMPILE_STATUS=$?

# Check if compilation was successful
if [ $COMPILE_STATUS -ne 0 ]
then
    echo "Compilation failed. Please see compile_errors.txt in the grading-area directory for details."
    exit 1
fi


# Run the JUnit tests
java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > test_results.txt 2>&1

# Parse the test results and generate a grade report
TOTAL_TESTS=$(grep -o 'run=[0-9]*' test_results.txt | cut -d'=' -f2)
FAILED_TESTS=$(grep -o 'failure=[0-9]*' test_results.txt | cut -d'=' -f2)

echo "Total tests run: $TOTAL_TESTS"
echo "Total tests failed: $FAILED_TESTS"

# Go back to the original directory
cd ..


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
