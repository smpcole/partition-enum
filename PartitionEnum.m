classdef PartitionEnum < handle
    properties
        n
        k
        hasNext
        index

        % Private
        sub
        nAlone
        counter
    end

    methods
        
        function this = PartitionEnum(n, k)
            this.n = n;
            this.k = k;
            this.reset();
        end

        % Compute number of k-partitions of [n] (i.e., Stirling number of 2nd kind)
        % via dynamic programming.  Takes O(n) time and space
        function S = numPartitions(this)
            table = ones(1, this.n);
            for n = 1 : this.n
                for k = fliplr(2 : n - 1)
                    table(k) = table(k - 1) + k * table(k);
                end
            end
            S = table(this.k);
        end

        function partition = getRandom(this)
            % Randomly order the numbers
            order = randperm(this.n);
            for i = 1 : this.n
                if i <= this.k
                    % Assign first k numbers to their own parts
                    partition{i} = order(i);
                else
                    % Assign remaining vertices randomly
                    part = randi(this.k, 1, 1);
                    partition{part} = [partition{part}, order(i)];
                end
            end
        end

        function reset(this)
            this.hasNext = (this.k <= this.n);
            this.sub = 0;
            this.nAlone = true;
            this.counter = 1;
            this.index = 0;
        end

        function partition = getNext(this)
            % partition = {};
            if ~(this.hasNext)
                partition = {};
                return;
            end

            this.index = this.index + 1;
                        
            % Base cases
            if this.k == 1
                this.hasNext = false;
                partition = {1 : this.n};
                return;
            end
                        
            if this.k == this.n
                this.hasNext = false;
                for i = 1 : this.n
                    partition{i} = i;
                end
                return;
            end

            % First, generate the partitions in which n is by itself
            if this.nAlone
                            
                % Very first time
                if this.sub == 0
                    this.sub = PartitionEnum(this.n - 1, this.k - 1);
                end

                if this.sub.hasNext
                    partition = this.sub.getNext();
                    partition{this.k} = this.n;
                    return;
                else
                    this.nAlone = false;
                    this.sub = PartitionEnum(this.n - 1, this.k);
                end
            end
                
            % Done with partitions in which n is by itself
            partition = this.sub.getNext();
                        
            assert(length(partition) > 0);

            partition{this.counter} = [partition{this.counter}, this.n];
            if ~(this.sub.hasNext)
                if this.counter < this.k
                    this.counter = this.counter + 1;
                    this.sub = PartitionEnum(this.n - 1, this.k);
                else
                    this.hasNext = false
                end
            end
        end

        function test(this)
            while this.hasNext
                partition = this.getNext();
                fprintf('Partition:\n');
                for i = 1 : this.k
                    display(partition{i});
                end
                fprintf('\n');
            end
            assert(this.index == this.numPartitions());
        end

    end

end
