# hello_world.py
import numpy as np
import pandas as pd
from pudb import set_trace
set_trace()
# Run as... python -m pudb.run testfiles/hello_world_pudb.py


def say_hello():
    """Docstring for say_hello.
    """
    print("Hello, world!")


def say_hello2() -> None:
    """Docstring for say_hello2"""
    say_hello()


def say_hello3():
    """Docstring for say_hello.
    """
    say_hello()
    print("Hello, world!")


def say_hello4() -> None:
    """Docstring for say_hello2"""
    pudb.set_trace()
    say_hello3()


def say_hello5() -> None:
    """Docstring for say_hello2"""
    say_hello()


def say_hello6():
    """Docstring for say_hello.
    """
    print("Hello, world!")


def say_hello7() -> None:
    """Docstring for say_hello2"""
    say_hello()


if __name__ == "__main__":
    say_hello()

df = pd.DataFrame()
