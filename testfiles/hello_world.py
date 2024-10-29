# hello_world.py
import numpy as np
import pandas as pd


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
    print("Hello, world!")

def say_hello4() -> None:
    """Docstring for say_hello2"""
    say_hello()

if __name__ == "__main__":
    say_hello()

df = pd.DataFrame()
