#!/usr/bin/env python3
"""
Description: Description
"""

__date__ = "2025-12-03"


import os
import math
import random
import collections
from typing import List, Dict, Iterable, Generator
import logging

# Global constants
PI = math.pi
EULER = math.e
DEFAULT_PATH = os.path.expanduser("~")

logging.basicConfig()


def greet(name: str) -> str:
    """Return a greeting message."""
    return f"Hello, {name}!"


def compute_factorial(n: int) -> int:
    """Compute factorial using math library."""
    if n < 0:
        raise ValueError("n must be non-negative")
    return math.factorial(n)


def random_numbers(count: int, start: int = 0, end: int = 100) -> List[int]:
    """Generate a list of random integers."""
    return [random.randint(start, end) for _ in range(count)]


def group_by_length(words: Iterable[str]) -> Dict[int, List[str]]:
    """Group words by their length."""
    result: Dict[int, List[str]] = collections.defaultdict(list)
    for w in words:
        result[len(w)].append(w)
    return dict(result)


def infinite_counter(start: int = 0) -> Generator[int, None, None]:
    """Yield an infinite sequence of integers starting from `start`."""
    while True:
        yield start
        start += 1


class Demo:
    """Demo class illustrating various Python features."""

    _instance_count = 0

    def __init__(self, name: str, values: List[int] | None = None):
        self.name = name
        self.values = values or []
        Demo._instance_count += 1

    @property
    def count(self) -> int:
        """Number of stored values."""
        return len(self.values)

    def add_value(self, value: int) -> None:
        """Add a value to the list."""
        self.values.append(value)

    def mean(self) -> float:
        """Calculate the mean of the stored values."""
        return sum(self.values) / len(self.values) if self.values else 0.0

    @staticmethod
    def static_info() -> str:
        """Return static information."""
        return "Demo static method"

    @classmethod
    def total_instances(cls) -> int:
        """Return total number of Demo instances created."""
        return cls._instance_count

    def __repr__(self) -> str:
        return f"<Demo name={self.name!r} values={self.values}>"


def main() -> None:
    print(greet("World"))
    print(f"Factorial of 5: {compute_factorial(5)}")
    print("Random numbers:", random_numbers(5))
    words = ["apple", "banana", "cherry", "date", "elderberry"]
    print("Grouped words by length:", group_by_length(words))
    counter = infinite_counter(10)
    print("First three from infinite counter:", [next(counter) for _ in range(3)])

    demo = Demo("Sample", [1, 2, 3])
    demo.add_value(4)
    print(demo)
    print(f"Mean: {demo.mean():.2f}")
    print("Instance count:", Demo.total_instances())
    print(Demo.static_info())


if __name__ == "__main__":
    main()
