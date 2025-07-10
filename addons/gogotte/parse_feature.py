"""Gherkin parser."""
from gherkin import Parser
from sys import argv, exit
from pathlib import Path
import json

def main() -> int:
    """Parse a feature file to an AST."""
    if len(argv) != 2:
        raise ValueError(f"Wrong number of arguments ({len(argv)}); expected path to file")

    feature_path = Path(argv[1])

    with open(feature_path) as file:
        document = Parser().parse(file.read())

    print(json.dumps(document))

    return 0

if __name__ == '__main__':
    exit(main())