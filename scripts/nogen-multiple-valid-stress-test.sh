#!/bin/bash
source .env

# Compile solution and validator with error checking
$GCC_VERSION ../code/solution.cpp -o ../code/exec/solution || { echo "Failed to compile solution.cpp"; exit 1; }
$GCC_VERSION ../code/anypossible_validator.cpp -o ../code/exec/validator || { echo "Failed to compile validator.cpp"; exit 1; }

# Clean up previous logs while preserving .gitkeep files
echo "Cleaning up previous logs..."
find ../logs -type f ! -name '.gitkeep' -delete
find ../tests/actual_output -type f ! -name '.gitkeep' -delete
echo "Cleanup complete."

# Directory setup for logs
mkdir -p ../logs/checker_logs
mkdir -p ../logs/test_logs

# Define color codes for terminal output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'  # No Color

# Initialize counters
passed_tests=0
failed_tests=0

# Run through each previously generated test case and validate output
for input in ../tests/input/*.txt; do
    test_name=$(basename "$input" .txt)
    actual_output="../tests/actual_output/${test_name}_actual.txt"
    checker_log="../logs/checker_logs/${test_name}_checker_log.txt"
    test_log="../logs/test_logs/${test_name}_log.txt"

    # Clear log files at the start of each test run
    > "$checker_log"
    > "$test_log"

    # Run solution and save actual output
    ../code/exec/solution < "$input" > "$actual_output" || { echo "Failed to generate actual output"; exit 1; }

    # Validate output with anypossible_validator
    if ../code/exec/validator "$input" "$actual_output" | tee -a "$checker_log" | grep -q "Valid"; then
        # Log success details
        echo "Test $test_name: PASSED" >> "$test_log"
        echo "Input:" >> "$test_log"
        cat "$input" >> "$test_log"
        echo -e "\nOutput generated by solution:" >> "$test_log"
        cat "$actual_output" >> "$test_log"

        # Increment passed test counter and show "Passed" status in green
        ((passed_tests++))
        echo -e "Test $test_name: ${GREEN}Passed${NC}"
    else
        # Log failure details
        echo "Test $test_name: FAILED" >> "$test_log"
        echo "Input:" >> "$test_log"
        cat "$input" >> "$test_log"
        echo -e "\nOutput generated by solution:" >> "$test_log"
        cat "$actual_output" >> "$test_log"

        # Increment failed test counter and show "Failed" status in red
        ((failed_tests++))
        echo -e "Test $test_name: ${RED}Failed${NC}"
    fi
done

# Display summary of results
total_tests=$((passed_tests + failed_tests))
if [ $failed_tests -gt 0 ]; then
    echo -e "${RED}$failed_tests tests failed out of $total_tests.${NC}"
else
    echo -e "${GREEN}All test cases passed!${NC}"
fi
