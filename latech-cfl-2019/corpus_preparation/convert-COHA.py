import sys
from nltk.tokenize import sent_tokenize


def main():
    in_files = sys.argv[1:]
    pos = 2
    column = 1
    for in_file in in_files:
        txt = []
        try:
            with open(in_file, "r") as f:
                for line in f:
                    if not line.startswith("//"):
                        parts = line.strip().split("\t")
                        if len(parts) == 3 and parts[0] != "@" and not parts[0].startswith("@@") and parts[pos] != "null" and not (parts[0] == "\x00" and parts[1] == "\x00") and not parts[0].startswith("&"):
                            if column == 0 or parts[1] == "\x00":
                                it = parts[0]
                            else:
                                it = parts[column]
                            if it == "n't":
                                it = "not"
                            txt.append(it)
                print(" ".join(txt))
        except:
            sys.stderr.write("Error in "+in_file)

if __name__ == "__main__":
    main()
