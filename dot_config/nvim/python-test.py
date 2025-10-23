#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""Module documentation goes here."""

from __future__ import print_function

__author__ = "First Last"
__copyright__ = "Copyright 2018, First Last"
__credits__ = ["C D", "A B"]
__license__ = "Apache 2.0"
__version__ = "1.0.1"
__maintainer__ = "First Last"
__email__ = "test@example.org"
__status__ = "Development"

x = 4 + 8
print("hello")
print("Testing")

import argparse
import os

from logzero import logger


def log(function):
    """Handy logging decorator."""

    def inner(*args, **kwargs):
        """Innter method."""
        logger.debug(function)
        function(*args, **kwargs)

    return inner


class Greeter:
    """Example function with types documented in the docstring."""

    def __init__(self):
        self.message = "Hello world!"

    def set_message(self, message: str):
        """Function description."""
        self.message = message

    @log
    def print_message(self):
        """Function description."""
        print(self.message)


def main(args: argparse.Namespace):
    """Main entry point of the app"""
    Greeter().print_message()
    logger.info(args)


if __name__ == "__main__":
    PARSER = argparse.ArgumentParser()

    # Required positional argument
    PARSER.add_argument("arg", help="Required positional argument")

    # Optional argument flag which defaults to False
    PARSER.add_argument("-f", "--flag", action="store_true", default=False)

    # Optional argument which requires a parameter (eg. -d test)
    PARSER.add_argument("-n", "--name", action="store", dest="name")

    # Optional verbosity counter (eg. -v, -vv, -vvv, etc.)
    PARSER.add_argument(
        "-v", "--verbose", action="count", default=0, help="Verbosity (-v, -vv, etc)"
    )

    # Specify output of "--version"
    PARSER.add_argument(
        "--version",
        action="version",
        version="%(prog)s (version {version})".format(version=__version__),
    )

    MYARGS = PARSER.parse_args()
    main(MYARGS)

import bingbong  # noqa: INP001
import bingbong
import sys
import sys

bingbong.feet()


# Syntax Errors
def function_with_syntax_error(:  # Missing closing parenthesis for function definition
    print("This function has a syntax error")


if True:
    print("This is fine")

# Name Errors
undefined_variable = some_undefined_name + 5


def another_function():
    print(non_existent_variable)


# Type Errors
result = "hello" + 5
length = len(123)


# Index Errors
my_list = [1, 2, 3]
print(my_list[5])

my_string = "abc"
print(my_string[3])


# Attribute Errors
class MyClass:
    def __init__(self):
        self.value = 10


obj = MyClass()
print(obj.non_existent_attribute)

# ZeroDivisionError
numerator = 10
denominator = 0
division_result = numerator / denominator

# FileNotFoundError
with open("non_existent_file.txt", "r") as f:
    content = f.read()


# Indentation Error (will cause a SyntaxError during parsing)
def indented_error_function():
    print("This is correctly indented")
    print("This line has an incorrect indentation")  # Incorrect indentation


# Logical Error (no error raised, but incorrect behavior)
def calculate_average(numbers):
    total = 0
    for num in numbers:
        total += num
    return total / len(numbers) - 1  # Incorrect calculation for average


# Example of calling a function with a syntax error (will not execute)
# function_with_syntax_error()

# Example of calling a function with a NameError
# another_function()

# Example of calling the function with a logical error
# print(calculate_average([1, 2, 3]))
