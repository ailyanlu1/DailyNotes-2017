/*
 * Q: Convert a non-negative integer to its English words representation. Given input is guaranteed to be less than 2^31 - 1 (2147483647).
 */

#include<iostream>
#include<stdlib.h>
#include<string>
#include<vector>
using namespace std;

static string dict1[] = {"Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten",
						"Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen","Seventeen","Eighteen","Nineteen"};
static string dict2[] = {"","","Twenty","Thirty","Forty","Fifty","Sixty","Seventy","Eighty","Ninety"};
static string dict3[] = {"Hundred","Thousand","Million","Billion"};

string numberLess1000ToWords(int num)
{
	string result;

	if (num == 0)
	{
		return result;
	}
	else if (num < 20)
	{
		return dict1[num];
	}
	else if (num < 100)
	{
		result = dict2[num / 10];
		if (num % 10 > 0)
		{
			result += " " + dict1[num % 10];
		}
	}
	else
	{
		result = dict1[num/100] + " " + dict3[0];
		if (num%100 > 0)
		{
			result += " " + numberLess1000ToWords(num % 100);
		}
	}
	return result;
}

string numberToWords(int num)
{
	if (num == 0)
		return dict1[num];

	vector<string> ret;
	for (;num > 0;num/=1000)
	{
		ret.push_back(numberLess1000ToWords(num % 1000));
	}

	string result = ret[0];
	for (int i = 1; i < ret.size(); i++)
	{
		if (ret[i].size() > 0)
		{
			if (result.size() > 0)
			{
				result = ret[i] + " " + dict3[i] + " " + result;
			}
			else
			{
				result = ret[i] + " " + dict3[i];
			}
		}
	}
	return result;
}

#define TEST(num) cout << num << " -> \"" << numberToWords(num) << "\"" << endl
int main(int argc,char** argv)
{
	int num = 123;
	if (argc > 1)
	{
		num = atoi(argv[1]);
	}
	TEST(num);
	TEST(6);
	TEST(12);
	TEST(34);
	TEST(189);
	TEST(6254);
	TEST(96215);
	TEST(8513943);
	TEST(32494112);
	TEST(2147483647);
	return 0;
}
