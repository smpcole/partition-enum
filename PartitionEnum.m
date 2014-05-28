classdef PartitionEnum < handle
    properties
        n
	k
	hasNext

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

    function reset(this)
        this.hasNext = (this.k <= this.n);
		this.sub = 0;
		this.nAlone = true;
		this.counter = 1;
    end

	function partition = getNext(this)
%	    partition = {};
	    if ~(this.hasNext)
	        partition = {};
		return;
	    end
			
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
	end

    end

end
