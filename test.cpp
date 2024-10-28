#include <bits/stdc++.h>
using namespace std;
bool containsDigit(int number, char unwantedDigit)
{
    string numStr = to_string(number);
    return numStr.find(unwantedDigit) != string::npos;
}
int minNumberToAdd(int number, char unwantedDigit)
{
    int increment = 0;
    while (containsDigit(number + increment, unwantedDigit))
    {
        increment++;
    }
    return increment;
}
int main()
{
    int number;
    char unwantedDigit;
    cin >> number;
    cin >> unwantedDigit;
    int result = minNumberToAdd(number, unwantedDigit);
    cout << result << endl;
    return 0;
}