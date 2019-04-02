import sys
from collections import Counter
import xml.etree.ElementTree as etree


def main():
    wordCount = Counter()
    good_tags = set(["NN", "VVFIN", "VVIMP", "VVINF",
                     "VVIZU", "VVPP", "ADJA", "ADJD"])
    for xml in sys.argv[1:]:
        tree = etree.parse(xml)
        root = tree.getroot()
        for corpus in root.findall("{http://www.dspin.de/data/textcorpus}TextCorpus"):
            correct_tags = set()
            for postags in corpus.findall("{http://www.dspin.de/data/textcorpus}POStags"):
                for tag in postags.findall("{http://www.dspin.de/data/textcorpus}tag"):
                    if tag.text in good_tags:
                        correct_tags.add(tag.attrib["tokenIDs"])
            for lemmas in corpus.findall("{http://www.dspin.de/data/textcorpus}lemmas"):
                for lemma in lemmas.findall("{http://www.dspin.de/data/textcorpus}lemma"):
                    if lemma.attrib["tokenIDs"] in correct_tags:
                        wordCount[lemma.text.encode("utf-8")] += 1

    for word, count in wordCount.most_common():
        print(word + " " + str(count))

if __name__ == "__main__":
    main()
