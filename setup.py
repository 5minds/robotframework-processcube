#!/usr/bin/env python

import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

name = "5Minds IT-Solutions GmbH & Co. KG"

setuptools.setup(
    name="robotframework-processcube",
    version=setuptools.sic('2.0.0-alpha.4'),
    description="Robot Framework Keywords for processcube workflow engine.",
    long_description=long_description,
    long_description_content_type="text/markdown",
    author=name,
    author_email="processcube@5minds.de",
    url="https://github.com/atlas-engine-contrib/robotframework-processcube",
    packages=setuptools.find_packages(),
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
    install_requires=["robotframework>=3.2", "requests", "frozendict", 'atlas-engine-client>=2.0.0a4','dataclass_json'],
)