import sys
import random

class PartitionEnum:

    def __init__(self, n, k):
        self.n = n
        self.k = k
        self.reset();

    def reset(self):
        self.hasNext = (self.k <= self.n)
        self.sub = None
        self.index = 0 # Number of partitions that have been generated so far
        self.nAlone = True
        self.counter = 0

    def getRandom(self):
        order = range(1, self.n + 1)
        # Randomly order the numbers
        random.shuffle(order)
        partition = [[] for i in xrange(self.k)]
        for i in xrange(self.n):
            part = None
            if i < self.k:
                # Place first k in their own parts
                part = i
            else:
                # Randomly assign other vertices
                part = random.randint(0, self.k - 1)
            partition[part].append(order[i])
        return partition
            

    def numPartitions(self):
        """Compute number of k-partitions of [n] (i.e., Stirling number of 2nd kind) via dynamic programming.  Takes O(n) time and O(n) space."""
        table = [0];
        for n in xrange(1, self.n + 1):
            table.append(1)
            # n == len(table) - 1
            for k in reversed(xrange(2, n)):
                table[k] = table[k - 1] + k * table[k]
        return table[self.k]

    def getNext(self):

        if not self.hasNext:
            return None
        
        self.index += 1

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
                self.sub = PartitionEnum(self.n - 1, self.k - 1)

            if self.sub.hasNext:
                partition = self.sub.getNext()
                partition.append([self.n])
                return partition
            else:
                self.nAlone = False
                self.sub = PartitionEnum(self.n - 1, self.k)

        # Done with partitions in which n is by itself
        partition = self.sub.getNext()

        # partition should not be None
        assert partition != None

        partition[self.counter].append(self.n)
        if not self.sub.hasNext:
            if self.counter < self.k - 1:
                self.counter += 1
                self.sub = PartitionEnum(self.n - 1, self.k)
            else:
                self.hasNext = False

        return partition

def main():
    enum = PartitionEnum(int(sys.argv[1]), int(sys.argv[2]))
    while enum.hasNext:
        print enum.getNext()
    assert enum.index == enum.numPartitions()

if __name__ == "__main__":
    main()
