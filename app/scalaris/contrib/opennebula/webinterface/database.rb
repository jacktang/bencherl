
set :database, 'sqlite://contrail.db'

puts "the scalaris table doesn't exist" if !database.table_exists?('scalaris')


# define database migrations. pending migrations are run at startup and
# are guaranteed to run exactly once per database.
migration "create scalaris table" do
  database.create_table :scalaris do
    primary_key :id
    String      :user
    String      :known_nodes
    DataTime    :created_at
    DataTime    :updated_at
    String      :head_node
  end
end

migration "create scalarisvms table" do
  database.create_table :scalarisvms do
    primary_key :id
    String      :one_vm_id
    foreign_key :scalaris_id, :scalaris
  end
end

migration "create hadoop table" do
  database.create_table :hadoops do
    primary_key :id
    String      :user
    String      :known_nodes
    DataTime    :created_at
    DataTime    :updated_at
    String      :master_node
  end
end

migration "create hadoopvms table" do
  database.create_table :hadoopvms do
    primary_key :id
    String      :one_vm_id
    foreign_key :hadoop_id, :hadoops
  end
end

migration "create wiki table" do
  database.create_table :wikis do
    primary_key :id
    String      :user
    String      :known_nodes
    DataTime    :created_at
    DataTime    :updated_at
    String      :master_node
  end
end

migration "create wikivms table" do
  database.create_table :wikivms do
    primary_key :id
    String      :one_vm_id
    foreign_key :wiki_id, :wikis
  end
end
# you can also alter tables
#migration "everything's better with bling" do
#  database.alter_table :foos do
#    drop_column :baz
#    add_column :bling, :float
#  end
#end

# models just work ...
class Scalaris < Sequel::Model
  one_to_many :scalarisvms

  def before_create
    return false if super == false
    self.created_at = Time.now.utc
  end

  def before_update
    return false if super == false
    self.updated_at = Time.now.utc
  end
end

class Scalarisvm < Sequel::Model
  many_to_one :scalaris
end

class Hadoop < Sequel::Model
  one_to_many :hadoopvms

  def before_create
    return false if super == false
    self.created_at = Time.now.utc
  end

  def before_update
    return false if super == false
    self.updated_at = Time.now.utc
  end
end

class Hadoopvm < Sequel::Model
  many_to_one :hadoops
end

class Wiki < Sequel::Model
  one_to_many :wikivms

  def before_create
    return false if super == false
    self.created_at = Time.now.utc
  end

  def before_update
    return false if super == false
    self.updated_at = Time.now.utc
  end
end

class Wikivm < Sequel::Model
  many_to_one :wikis
end
