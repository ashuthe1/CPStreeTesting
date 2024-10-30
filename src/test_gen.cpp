#include <bits/stdc++.h>
using namespace std;

string generate_test() {
    int n = rand() % 100 + 1;  // Number of integers between 1 and 100
    stringstream ss;
    ss << n << "\n";
    for (int i = 0; i < n; i++) {
        ss << (rand() % 21 - 10) << " ";  // Numbers between 1 and 1000
    }
    ss << "\n";
    int q = rand() % 10 + 1;  // Number of queries between 1 and 100
    ss << q;
    int lim = n * (n+1)/2;
    for (int i = 0; i < q; i++) {
        int l = rand() % lim + 1;  // Random index between 1 and n
        int r = rand() % lim + 1;  // Random index between 1 and n
        ss << "\n" << min(l, r) << " " << max(l, r);
    }
    return ss.str();
}

int main(int argc, char* argv[]) {
    srand(time(0));

    // Default number of test cases
    int num_tests = 10;

    // Update num_tests if an argument is provided
    if (argc > 1) {
        num_tests = stoi(argv[1]);
    }

    // Generate the specified number of test cases
    for (int i = 0; i < num_tests; i++) {
        ofstream outfile("../tests/input/test_" + to_string(i) + ".txt");
        outfile << generate_test();
        outfile.close();
    }

    return 0;
}
