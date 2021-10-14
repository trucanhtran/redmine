# encoding: utf-8
#
# Redmine plugin for Document Management System "Features"
#
# Copyright (C) 2011-17 Karel Pičman <karel.picman@kontron.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class CreateDmsfWorkflows < ActiveRecord::Migration[5.2]
  def self.up
    create_table :dmsf_workflows do |t|
      t.string :name, :null => false
      t.references :project    
    end
    add_index :dmsf_workflows, [:name], :unique => true
        
    change_table :dmsf_file_revisions do |t|
      t.references :dmsf_workflow
      t.integer :dmsf_workflow_assigned_by
      t.datetime :dmsf_workflow_assigned_at
      t.integer :dmsf_workflow_started_by
      t.datetime :dmsf_workflow_started_at
    end
  end
  
  def self.down
    remove_column :dmsf_file_revisions, :dmsf_workflow_id
    remove_column :dmsf_file_revisions, :dmsf_workflow_assigned_by
    remove_column :dmsf_file_revisions, :dmsf_workflow_assigned_at
    remove_column :dmsf_file_revisions, :dmsf_workflow_started_by
    remove_column :dmsf_file_revisions, :dmsf_workflow_started_at
    drop_table :dmsf_workflows
  end    
end
