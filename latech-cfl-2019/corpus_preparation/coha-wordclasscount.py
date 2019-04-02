import sys
from collections import Counter


def main():
    in_files = sys.argv[1:]
    pos = 2
    column = 1
    txt = Counter()
    # lecical verb, common noun or adjective
    allowed_pos = set([x.lower() for x in ["NN", "NN1", "NN2", "VV0", "VVD", "VVG",
                                           "VVGK", "VVI", "VVN", "VVNK", "VVZ", "JJ", "JJR", "JJT", "JK"]])

    print("vv0_nn1_jj" in allowed_pos)
    sys.exit(1)
    for in_file in in_files:
        with open(in_file, "r") as f:
            for line in f:
                if not line.startswith("//"):
                    parts = line.strip().split("\t")
                    if len(parts) == 3 and parts[0] != "@" and not parts[0].startswith("@@") and parts[pos] != "null" and not (parts[0] == "\x00" and parts[1] == "\x00") and not parts[0].startswith("&"):
                        if parts[pos] in allowed_pos:
                            if column == 0 or parts[1] == "\x00":
                                it = parts[0]
                            else:
                                it = parts[column]
                            if it == "n't":
                                it = "not"
                            txt[it] += 1
    for word, count in txt.most_common():
        print(word + " " + str(count))

if __name__ == "__main__":
    main()
