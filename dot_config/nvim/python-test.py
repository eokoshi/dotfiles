#!/usr/bin/env python3
#region Header
'''Description: Description'''
__author__ = 'Ethan N. Okoshi'
__date__ = '2025-12-03'
__email__ = ' ethan <at> nagasaki-u.ac.jp '
#endregion


import numbers
from typing import Optional

import numpy as np
import torch
import torch.nn as nn
from PIL import Image
from skimage import color
from torchvision.transforms.v2 import Transform
from torchvision.transforms.v2 import functional as F


class HEDJitter1:
    """Randomly perturbe the HED color space value an RGB image.
    First, it disentangled the hematoxylin and eosin color channels by color deconvolution method using a fixed matrix.
    Second, it perturbed the hematoxylin, eosin and DAB stains independently.
    Third, it transformed the resulting stains into regular RGB color space.
    Args:
        theta (float): How much to jitter HED color space,
         alpha is chosen from a uniform distribution [1-theta, 1+theta]
         betti is chosen from a uniform distribution [-theta, theta]
         the jitter formula is $s' = \alpha * s + \betti$
    """

    def __init__(self, theta=0.0):  # HED_light: theta=0.05; HED_strong: theta=0.2
        assert isinstance(theta, numbers.Number), f"{theta} theta should be a single number."
        self.theta = theta
        self.alpha = np.random.uniform(1 - theta, 1 + theta, (1, 3))
        self.betti = np.random.uniform(-theta, theta, (1, 3))

    @staticmethod
    def adjust_HED(img, alpha, betti):
        img = np.array(img)

        s = np.reshape(color.rgb2hed(img), (-1, 3))
        ns = alpha * s + betti  # perturbations on HED color space
        nimg = color.hed2rgb(np.reshape(ns, img.shape))

        imin = nimg.min()
        imax = nimg.max()
        rsimg = (255 * (nimg - imin) / (imax - imin)).astype(
            "uint8"
        )  # rescale to [0,255]
        # transfer to PIL image
        return Image.fromarray(rsimg)

    def __call__(self, img):
        return self.adjust_HED(img, self.alpha, self.betti)

    def __repr__(self):
        format_string = self.__class__.__name__ + "("
        format_string += f"theta={self.theta}"
        format_string += f",alpha={self.alpha}"
        format_string += f",betti={self.betti}"
        return format_string


    class HEDJitter(nn.Module):
        def __init__(
            self,
            alpha: float = 0.05,
            beta: float = 0.05,
        ):
            super().__init__()
            self.alpha: tuple[float, float] = (1 - alpha, 1 + alpha)
            self.beta: tuple[float, float] = (-beta, beta)

        @staticmethod
        def _generate_value(left: float, right: float) -> float:
            return torch.empty(1).uniform_(left, right).item()

        def forward(self, image: torch.Tensor):
            # get alpha and beta for H&E channels
            alpha_H = self._generate_value(self.alpha[0], self.alpha[1])
            alpha_E = self._generate_value(self.alpha[0], self.alpha[1])

            beta_H = self._generate_value(self.beta[0], self.beta[1])
            beta_E = self._generate_value(self.beta[0], self.beta[1])

            # convert to float32
            orig_dtype = image.dtype
            image = F.convert_image_dtype(image, torch.float32)

            # jitter channels
            image = color.rgb2hed(image.permute(1, 2, 0).numpy())  # pyright: ignore[reportAssignmentType]
            image[..., 0] = image[..., 0] * alpha_H + beta_H
            image[..., 1] = image[..., 1] * alpha_E + beta_E

            # convert back to rgb tensor
            image = torch.tensor(color.hed2rgb(image)).permute(2, 0, 1)
            return F.convert_image_dtype(image, orig_dtype)


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
