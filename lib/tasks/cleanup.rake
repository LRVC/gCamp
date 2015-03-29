namespace :cleanup do
  desc 'Remove invalid data from memberships'
    task list: :environment do
      Membership.where.not(user_id: User.pluck(:id)).destroy_all
      Membership.where.not(project_id: Project.pluck(:id)).destroy_all
      Membership.where(project_id: nil).destroy_all
      Membership.where(user_id: nil).destroy_all
    end

  desc 'Remove invalid data from tasks'
    task list: :environment do
      Task.where.not(project_id: Project.pluck(:id)).destroy_all
      Task.where(project_id: nil).destroy_all
    end

  desc 'Remove invalid data from comments'
    task list: :environment do
      Comment.where.not(task_id: Task.pluck(:id)).destroy_all
      Comment.where.not(user_id: User.pluck(:id)).update_all(user_id: nil)
      Comment.where(task_id: nil).destroy_all
    end
end
