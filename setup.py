# Learn more: https://github.com/kennethreitz/setup.py

from setuptools import setup, find_packages

with open('README.md') as f:
    readme: str = f.read()

with open('app/VERSION') as f:
    version: str = f.read().strip()

setup(
    name='infinity',
    version=version,
    description='Fastapi',
    long_description=readme,
    packages=["app"]
)
