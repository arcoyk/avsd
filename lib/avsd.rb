require "rubygems"
require "sqlite3"
require "matrix"
require "priority_queue"

module Enumerable

    def sum
      self.reduce { |accum, i| accum + i }
    end

    def mean
      self.sum / self.length.to_f
    end

    def sample_variance
      m = self.mean
      sum = self.reduce { |accum, i| accum + (i - m) ** 2 }
      sum / (self.length - 1).to_f
    end

    def sd
      Math.sqrt(self.sample_variance)
    end

end 

module Avsd
	def self.hello
		puts 'hello'
	end
end

class Matrix
	def []=(i, j, x)
	@rows[i][j] = x
	end

	def fold
		for col in 0..self.column_size - 1
			for row in col..self.row_size - 1
				sum = self[row, col] + self[col, row]
				self[row, col] = sum
				self[col, row] = sum
			end
		end
		self
	end

	def show
		for col in 0..self.column_size - 1
			for row in 0..self.row_size - 1
				print self[row, col] == nil ? "n" : self[row, col]
				print "  "
			end
			puts
		end
		self
	end

	def zero_diagonal
		for col in 0..self.column_size - 1
			self[col, col] = 0
		end
		self
	end
end

# class Avsd
# 	include Avsd
# 	cooccurance_matrix = all_record.unique_words.g_matrix.band
# 	dist_matrix = cooccurance_matrix.dik_matrix
# 	sample dist_matrix, 3
# end

class Labeled_matrix
	def initialize(labels)
		@labels = labels
		@co_mat = Matrix.unit(labels.length)
	end

	def band label1, label2
		@co_mat[@labels.index(label1), @labels.index(label2)] += 1
	end

	def band_matrix records
		@labels.each do |label_a|
			records.each do |record|
				if record.include? label
					record.each do |label_b|
						band(label_a, label_b)
					end
				end
			end
		end
		@co_mat.fold
	end

	def g_short_mat
		@short_mat = dijkstra_all @co_mat
	end

	def sample num
		arr = Array.new(@short_mat.column_size) { |idx| idx }
		set = arr.sample 4
		arr = []
		set.length.times do |i|
			for k in i + 1..set.length - 1
				arr << [set[i], set[k]]
			end
		end
		# debug
		sampled_labels = Hash.new
		set.each do |i|
			sampled_labels[@labels[set[i]]] = set[i]
		end
		[sampled_labels, arr.mean, arr.sd].inspect
	end

	attr_accessor :short_mat, :co_mat, :labels
end

def all_record
	# db = SQLite3::Database.new("database.db")
	[['a','b','c'],['a','b'],['a','b'],['b','c'],['c','d','e','f']]
end

def unique_labels all_record
	all_record.flatten.uniq
end

def dijkstra_all dist_mat
	short_mat = Matrix.zero(dist_mat.column_size)
	short_mat = short_mat.collect { |x| x = nil }
	for s_id in 0..dist_mat.column_size - 1
		q = PriorityQueue.new
		q[s_id] = 0
		while not q.empty?
			puts q.inspect
			f = q.delete_min
			short_mat[s_id, f[0]] = f[1]
			short_mat.show
			dist_mat.row(f[0]).each_with_index do |val, i|
				next if i == f[0] or val == 0 or short_mat[s_id, i] != nil
				if q[i] == nil or q[i] > f[1] + val
					q[i] = f[1] + val
				end
			end
		end
	end
	short_mat
end

def sample short_mat, num
	arr = Array.new(short_mat.column_size) { |idx| idx }
	set = arr.sample 4
	arr = []
	set.length.times do |i|
		for k in i + 1..set.length - 1
			arr << [set[i], set[k]]
		end
	end
	[set, arr.mean, arr.sd].inspect
end

# class Avsd
# 	include Avsd
# 	cooccurance_matrix = all_record.unique_words.g_matrix.band
# 	dist_matrix = cooccurance_matrix.dik_matrix
# 	sample dist_matrix, 3
# end

records = all_record
labeled_mat = Labeled_matrix.new unique_labels(records)
labeled_mat.band records
labeled_mat.g_short_mat
puts sample short_mat, 3



