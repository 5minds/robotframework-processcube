import os
import xml.etree.ElementTree as ET

class ParseTestResult:

    def __init__(self, filename):
        self._filename = filename

    def parse(self):
        tree = ET.parse(self._filename)
        
        suites = tree.findall(".//suite[@source]")

        for suite in suites:
            source = os.path.relpath(suite.get('source'))

            status = suite.find('status')
            doc = suite.find('doc')
            print('-' * 50)
            print(f"suite '{suite.get('name')}' with status '{status.get('status')}' from {source}")
            print(f"doc: {doc.text}")
            print('-' * 50)
            tests = suite.findall('test')

            for test in tests:
                status = test.find('status')
                print(f"test: '{test.get('name')}' with status '{status.get('status')}'")


            print('=' * 50)


def main():
    filename = os.path.join(os.path.dirname(__file__), 'output.xml')

    parser = ParseTestResult(filename)

    parser.parse()


if __name__ == '__main__':
    main()