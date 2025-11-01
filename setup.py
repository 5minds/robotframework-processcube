#!/usr/bin/env python

import setuptools

try:
    from pip.req import parse_requirements
except ImportError:  # pip >= 10.0.0
    from pip._internal.req import parse_requirements

parsed_reqs = parse_requirements('requirements.txt', session='hack')
installed_reqs = [str(ir.requirement) for ir in parsed_reqs]

with open("README.md", "r") as fh:
    long_description = fh.read()

name = "5Minds IT-Solutions GmbH & Co. KG"

setuptools.setup(
    name="robotframework-processcube",
<<<<<<< HEAD
    version=setuptools.sic('6.0.5-alpha.2'),
=======
    version=setuptools.sic('6.0.4-alpha.1'),
>>>>>>> 348f482f02c148a183775439ec6b491ac566c8c0
    description="Robot Framework Keywords for processcube workflow engine.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    author=name,
    author_email="processcube@5minds.de",
    url="https://github.com/atlas-engine-contrib/robotframework-processcube",
    packages=setuptools.find_packages(),
    install_requires=installed_reqs,
    classifiers=[
        "Intended Audience :: Developers",
        "Natural Language :: English",
        "Programming Language :: Python :: 3",
        "Topic :: Software Development",
        "License :: OSI Approved :: Apache Software License",
        "Operating System :: OS Independent",
        "Development Status :: 5 - Production/Stable",
        "Framework :: Robot Framework",
    ],
    license="MIT Licence",
)
