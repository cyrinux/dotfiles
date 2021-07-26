#!/usr/bin/env python3
# Original source: https://github.com/prahladyeri/enforce-git-message/
# Extended with BREAKING CHANGE, exclamation mark support (!) and space before " : " for French people

import re, sys, os

examples = """+ 61c8ca9 fix: navbar not responsive on mobile
+ 479c48b test: prepared test cases for user authentication
+ a992020 chore: moved to semantic versioning
+ b818120 fix: button click even handler firing twice
+ c6e9a97 fix: login page css
+ dfdc715 feat(auth): added social login using twitter
+ b235677 BREAKING CHANGE: remove support for XXX
+ a234556 revert!: back to version X.Y.Z for component ZZZ
+ b123456 feat : we support space before : for French people :-)
"""

def main():
    pattern = r'(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test|BREAKING CHANGE)(\([\w\-\s]+\))?!?\s?:\s.*'
    filename = sys.argv[1]
    ss = open(filename, 'r').read()
    m = re.match(pattern, ss)
    if m == None:
        print("\nCOMMIT FAILED!")
        print("\nPlease enter commit message in the conventional format and try to commit again. Examples:")
        print("\n" + examples)
        sys.exit(1)

if __name__ == "__main__":
    main()
