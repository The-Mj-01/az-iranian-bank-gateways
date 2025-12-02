from setuptools import setup, find_packages
import re
import os

def get_version():
    init_file = os.path.join(os.path.dirname(__file__), 'azbankgateways', '__init__.py')
    if os.path.exists(init_file):
        with open(init_file, 'r') as f:
            content = f.read()
            match = re.search(r'__version__\s*=\s*["\']([^"\']+)["\']', content)
            if match:
                return match.group(1)
    return '1.0.0'

setup(
    name='az-iranian-bank-gateways',
    version=get_version(),
    packages=find_packages(),
    install_requires=[
        'six',
        'Django>=3.0',
        'pycryptodome>=3.9.7',
        'zeep',
        'requests',
    ],
)

