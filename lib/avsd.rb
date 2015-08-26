require "avsd/version"
require "rubygems"
require "sqlite3"
require "matrix"
require "priority_queue"

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
		@mat = Matrix.unit(labels.length)
	end

	def band label1, label2
		@mat[@labels.index(label1), @labels.index(label2)] += 1
	end

	attr_accessor :mat, :labels
end

def all_record
	# db = SQLite3::Database.new("database.db")
	[[2,4,6],[2,2,4],[2,1,3,4,5],[2,3,4],[3]]
end

def unique_labels
	all_record.flatten.uniq
end

def g_matrix
	Labeled_matrix.new unique_labels
end


def band_matrix labeled_mat, all_record
	labeled_mat.labels.each do |label|
		all_record.each do |record|
			if record.include? label
				record.each do |tar_label|
					labeled_mat.band(label, tar_label)
				end
			end
		end
	end
	labeled_mat.fold
end


mat = Matrix.unit(5)


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
	set = arr.sample(num)
	set.
end

sample Matrix.unit(5), 3