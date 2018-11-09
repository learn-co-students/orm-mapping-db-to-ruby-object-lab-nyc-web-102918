require('pry')
class Student
  attr_accessor :id, :name, :grade
  @@all = []
    def initialize(args=nil)
      if args
        @id = args[0]
        @name = args[1]
        @grade = args[2]
      end
      @@all << self
    end

  def self.new_from_db(row)
    Student.new(row)
  end

  def self.all
    @@all=[]
    sql= <<-SQL
    SELECT * FROM students
    SQL
    data=DB[:conn].execute(sql)
    data.each{|row|
      found=@@all.find{|instance|instance.id == row[0]}
      found
      if !found
        self.new_from_db(row.flatten)
      end
    }
    @@all
  end
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * from students WHERE name = ?
    SQL
    record=DB[:conn].execute(sql, name)
    self.new_from_db(record.flatten)
  end



  def self.all_students_in_grade_9
    self.all #update @@all array from DB
   @@all.select{|student|student.grade =="9"}
  end

  def self.students_below_12th_grade
    self.all #update @@all array from DB
   @@all.select{|student|student.grade <="11"}
  end

  def self.first_X_students_in_grade_10(num)
    sql= <<-SQL
    SELECT * from students WHERE grade="10"
    ORDER BY id LIMIT ?
    SQL
    students = DB[:conn].execute(sql,num)
    students.map{|student_data|Student.new(student_data.flatten)}
  end

  def self.first_student_in_grade_10
    self.all #update @@all array from DB
    @@all.find{|student|student.grade == "10"}
  end

  def self.all_students_in_grade_X(num)
    sql= <<-SQL
    SELECT * from students WHERE grade = ?
    SQL
    students = DB[:conn].execute(sql,num)
  end
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end


end
