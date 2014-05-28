import sys

class PartitionEnumerator:

    def __init__(self, n, k):
        self.n = n
        self.k = k
        self.hasNext = (k <= n)

        # Private
        self.sub = None
        self.nAlone = True
        self.counter = 0

    def getNext(self):

        if not self.hasNext:
            return None
        
        # Base cases
        if self.k == 1:
            self.hasNext = False
            return [[i + 1 for i in xrange(self.n)]]
        
        if self.k == self.n:
            self.hasNext = False
            return [[i + 1] for i in xrange(self.n)]
            
        # First, generate the partitions in which n is by itself
        if self.nAlone:

            # Very first time
            if self.sub == None:
                self.sub = PartitionEnumerator(self.n - 1, self.k - 1)

            if self.sub.hasNext:
                partition = self.sub.getNext()
                partition.append([self.n])
                return partition
            else:
                self.nAlone = False
                self.sub = PartitionEnumerator(self.n - 1, self.k)

        # Done with partitions in which n is by itself
        partition = self.sub.getNext()

        # partition should not be None
        assert partition != None

        partition[self.counter].append(self.n)
        if not self.sub.hasNext:
            if self.counter < self.k - 1:
                self.counter += 1
                self.sub = PartitionEnumerator(self.n - 1, self.k)
            else:
                self.hasNext = False

        return partition

def main():
    enum = PartitionEnumerator(int(sys.argv[1]), int(sys.argv[2]))
    while enum.hasNext:
        print enum.getNext()

if __name__ == "__main__":
    main()
