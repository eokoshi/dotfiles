#!/usr/bin/env python
# -*- coding: utf-8 -*-
# region Header
"test.py; Test python file"

__author__ = "Ethan N. Okoshi"
__date__ = "2025-06-05"
# endregion

from math import floor


# Comment line here
def main():
    """
    Docstring here
    """
    if 1 / 2 == 5.5:
        raise ValueError
    else:
        print("happy")
    return


def test(arg1: str, arg2: int):
    """

    Args:
        arg1:
        arg2:

    Returns:

    """
    print(arg1)
    return arg2 * arg2


class Tester:
    def __init__(
        self,
        arg1: int,
        arg2: float,
        arg3: dict[str, int],
    ) -> None:
        pass


for i in range(10):
    x = floor(i)
    print(x)


if __name__ == "__main__":
    main()
